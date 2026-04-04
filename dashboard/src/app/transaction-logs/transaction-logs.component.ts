import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SidebarComponent } from '../sidebar/sidebar.component';
import { db } from '../firebase.config';
import { collection, onSnapshot, doc, updateDoc, serverTimestamp, setDoc, addDoc } from 'firebase/firestore';

interface Transaction {
  id: string; // Document ID
  ticketNumber: string;
  userName: string;
  dateTime: string;
  duration: string;
  amount: number;
  paymentMethod: string;
  status: string; // 'PAID' or 'PENDING'
  vehicleType: string;
  rawEntryDate: Date | null;
  fullUserId: string;
}

@Component({
  selector: 'app-transaction-logs',
  imports: [CommonModule, FormsModule, SidebarComponent],
  templateUrl: './transaction-logs.component.html',
  styleUrl: './transaction-logs.component.scss'
})
export class TransactionLogsComponent implements OnInit, OnDestroy {
  selectedDate: string = '';
  selectedStatus: string = 'All Statuses';
  searchQuery: string = '';

  transactions: Transaction[] = [];
  unsubscribeSessions: any;

  // QR Modal logic
  showQrModal = false;
  entryQrUrl = '';
  exitQrUrl = '';

  ngOnInit() {
    this.unsubscribeSessions = onSnapshot(collection(db, 'parking_sessions'), (snap) => {
      this.transactions = snap.docs.map(docSnap => {
        const data = docSnap.data();
        
        let entryDate: Date | null = null;
        let exitDate: Date | null = null;
        if (data['entryTime']) entryDate = data['entryTime'].toDate ? data['entryTime'].toDate() : new Date(data['entryTime']);
        if (data['exitTime']) exitDate = data['exitTime'].toDate ? data['exitTime'].toDate() : new Date(data['exitTime']);

        let duration = '-';
        if (entryDate) {
          const end = exitDate || new Date();
          const diffMs = end.getTime() - entryDate.getTime();
          const mins = Math.floor(diffMs / 60000);
          duration = `${Math.floor(mins / 60)}h ${mins % 60}m`;
        }

        // Mock Amount based on duration (100 LKR per hour approx for demo)
        let amt = 0;
        if (entryDate) {
          const end = exitDate || new Date();
          const diffMs = end.getTime() - entryDate.getTime();
          const hours = Math.ceil(diffMs / 3600000);
          amt = hours * 100;
        }

        return {
          id: docSnap.id,
          ticketNumber: data['ticketNumber'] || 'N/A',
          userName: data['userId'] ? data['userId'].substring(0,8) + '...' : 'Unknown User',
          dateTime: entryDate ? entryDate.toLocaleString() : 'N/A',
          duration: duration,
          amount: amt,
          paymentMethod: 'Manual/Cash',
          status: data['paymentStatus'] || 'PENDING',
          vehicleType: 'Car', // Statically mapping until vehicles fetched properly
          rawEntryDate: entryDate,
          fullUserId: data['userId'] || ''
        };
      });
    });
  }

  ngOnDestroy() {
    if (this.unsubscribeSessions) this.unsubscribeSessions();
  }

  async markPaid(txn: Transaction) {
    if (txn.status === 'PAID') return;
    try {
      const docRef = doc(db, 'parking_sessions', txn.id);
      await updateDoc(docRef, {
        paymentStatus: 'PAID',
        paymentTime: serverTimestamp(),
        markerByAdmin: 'Admin'
      });

      // Automatically send "Payment Successful" notification
      if (txn.fullUserId) {
        await addDoc(collection(db, 'notifications'), {
          userId: txn.fullUserId,
          title: 'Payment Successful',
          message: `Your payment for ticket ${txn.ticketNumber} was successful. Thank you!`,
          type: 'Payment Successful',
          icon: 'check_circle',
          iconColor: '#10b981',
          iconBg: '#ecfdf5',
          timestamp: serverTimestamp(),
          read: false
        });
      }

      alert('Payment marked as paid and notification sent.');
    } catch (e) {
      console.error("Failed to mark paid", e);
      alert('Error updating payment status.');
    }
  }

  generateWeeklyQRs() {
    const weekTimestamp = new Date().toISOString().split('T')[0]; // simple week key
    const entryToken = `ENTRY_GATE_${weekTimestamp}`;
    const exitToken = `EXIT_GATE_${weekTimestamp}`;
    
    // Using a reliable public API to encode the raw string token so the UI can physically view it.
    this.entryQrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${entryToken}`;
    this.exitQrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${exitToken}`;
    
    this.showQrModal = true;

    // Ideally, we'd save these tokens to a `qr_config` document so the IoT scanners know the week's valid code!
    setDoc(doc(db, 'system_config', 'current_gate_qrs'), {
      entryToken: entryToken,
      exitToken: exitToken,
      generatedOn: serverTimestamp()
    });
  }

  closeQrModal() {
    this.showQrModal = false;
  }

  downloadQR(url: string, filename: string) {
    fetch(url)
      .then(response => response.blob())
      .then(blob => {
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      })
      .catch(err => {
        console.error("Download failed:", err);
        // Fallback: open in new tab so user can CTRL+S / CMD+S natively
        window.open(url, '_blank');
      });
  }

  get filteredTransactions() {
    return this.transactions.filter(txn => {
      const matchStatus = this.selectedStatus === 'All Statuses' || txn.status === this.selectedStatus;
      
      let matchDate = true;
      if (this.selectedDate && txn.rawEntryDate) {
        // Date input yields YYYY-MM-DD which parses effectively
        const selDate = new Date(this.selectedDate);
        if (!isNaN(selDate.getTime())) {
          matchDate = selDate.toDateString() === txn.rawEntryDate.toDateString();
        }
      }

      let matchSearch = true;
      if (this.searchQuery && this.searchQuery.trim() !== '') {
        const term = this.searchQuery.toLowerCase().trim();
        matchSearch = txn.ticketNumber.toLowerCase().includes(term) || txn.userName.toLowerCase().includes(term);
      }

      return matchStatus && matchDate && matchSearch;
    });
  }

  resetFilters() {
    this.selectedDate = '';
    this.selectedStatus = 'All Statuses';
    this.searchQuery = '';
  }
}

