import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot.dart';
import '../models/parking_session_model.dart';
import 'dart:math';

class ParkingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of all slots
  Stream<List<ParkingSlotModel>> getAllSlots() {
    return _firestore
        .collection('parking_slots')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSlotModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Stream of available slots in a level
  Stream<List<ParkingSlotModel>> getSlotsByLevel(int levelNumber) {
    return _firestore
        .collection('parking_slots')
        .where('levelNumber', isEqualTo: levelNumber)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSlotModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Admin: update slot availability or maintainance status
  Future<void> updateSlotStatus(String slotId, String status) async {
    try {
      await _firestore.collection('parking_slots').doc(slotId).update({
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update slot status: $e');
    }
  }

  // Create a Parking Session (User scans Entry QR)
  Future<ParkingSessionModel> createSession(String userId, String slotId, String entryScannedBy) async {
    try {
      // Create random ticket number
      final ticketNumber = 'TICKET-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}';
      
      ParkingSessionModel newSession = ParkingSessionModel(
        sessionId: '', // Will be updated by Firestore
        userId: userId,
        slotId: slotId,
        ticketNumber: ticketNumber,
        entryTime: DateTime.now(),
        entryScannedBy: entryScannedBy,
        paymentStatus: 'PENDING',
        qrCodeData: '${userId}_$slotId',
      );

      DocumentReference docRef = await _firestore.collection('parking_sessions').add(newSession.toJson());

      // Mark slot as OCCUPIED
      await updateSlotStatus(slotId, 'OCCUPIED');

      return ParkingSessionModel.fromJson(newSession.toJson(), docRef.id);
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  // End Parking Session (User scans Exit QR and pays)
  Future<void> endSession(String sessionId, String exitScannedBy, String paymentStatus) async {
    try {
      // Get the session to find the slotId
      DocumentSnapshot sessionDoc = await _firestore.collection('parking_sessions').doc(sessionId).get();
      if (!sessionDoc.exists) throw Exception('Session not found');

      final sessionData = sessionDoc.data() as Map<String, dynamic>;
      
      await _firestore.collection('parking_sessions').doc(sessionId).update({
        'exitTime': FieldValue.serverTimestamp(),
        'exitScannedBy': exitScannedBy,
        'paymentStatus': paymentStatus,
        'paymentTime': paymentStatus == 'PAID' ? FieldValue.serverTimestamp() : null,
      });

      // Free up the slot
      await updateSlotStatus(sessionData['slotId'], 'AVAILABLE');
      
    } catch (e) {
      throw Exception('Failed to end session: $e');
    }
  }

  // Get User's Active Sessions
  Stream<List<ParkingSessionModel>> getUserActiveSessions(String userId) {
    return _firestore
        .collection('parking_sessions')
        .where('userId', isEqualTo: userId)
        .where('exitTime', isNull: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSessionModel.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Get User's Session History (completed sessions, ordered by most recent)
  Stream<List<ParkingSessionModel>> getUserSessionHistory(String userId) {
    return _firestore
        .collection('parking_sessions')
        .where('userId', isEqualTo: userId)
        .where('exitTime', isNull: false)
        .orderBy('entryTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ParkingSessionModel.fromJson(doc.data(), doc.id))
            .toList());
  }
}
