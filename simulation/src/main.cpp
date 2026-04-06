#include <Arduino.h>
#include <Adafruit_NeoPixel.h>

// ========================================
// 9-Slot Smart Parking Management System
// Wokwi-Compatible Version
// ========================================

#define NUM_SLOTS 9
#define LED_PIN 15
#define BRIGHTNESS 200
#define DETECTION_THRESHOLD 50 // Distance in cm to consider slot occupied

Adafruit_NeoPixel strip(NUM_SLOTS, LED_PIN, NEO_GRB + NEO_KHZ800);

// Pin assignments for 9 sensors (direct connection)
// Using only pins available in Wokwi ESP32 DevKit C V4
const int triggerPins[NUM_SLOTS] = {26, 25, 33, 32, 13, 12, 14, 27, 19};
const int echoPins[NUM_SLOTS] = {35, 34, 23, 22, 4, 16, 17, 5, 18};

// Slot names for better readability
const String slotNames[NUM_SLOTS] = {
  "A1", "A2", "A3", 
  "B1", "B2", "B3", 
  "C1", "C2", "C3"
};

// State tracking
bool slotState[NUM_SLOTS];
int slotDistance[NUM_SLOTS];
int availableCount = NUM_SLOTS;

// Read ultrasonic sensor
long readUltrasonic(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  return pulseIn(echoPin, HIGH, 30000);
}

// Update system statistics
void updateStatistics() {
  availableCount = 0;
  for (int i = 0; i < NUM_SLOTS; i++) {
    if (!slotState[i]) availableCount++;
  }
}

// Print system status
void printStatus() {
  Serial.println("\n========================================");
  Serial.println("PARKING STATUS SUMMARY");
  Serial.println("========================================");
  Serial.print("Available Slots: ");
  Serial.print(availableCount);
  Serial.print(" / ");
  Serial.println(NUM_SLOTS);
  Serial.print("Occupancy Rate: ");
  Serial.print(((NUM_SLOTS - availableCount) * 100) / NUM_SLOTS);
  Serial.println("%");
  Serial.println("----------------------------------------");
  
  for (int i = 0; i < NUM_SLOTS; i++) {
    Serial.print("Slot ");
    Serial.print(slotNames[i]);
    Serial.print(": ");
    Serial.print(slotState[i] ? "OCCUPIED" : "AVAILABLE");
    Serial.print(" (");
    Serial.print(slotDistance[i]);
    Serial.println("cm)");
  }
  Serial.println("========================================\n");
}

void setup() {
  Serial.begin(115200);
  delay(500);
  
  Serial.println("\n╔════════════════════════════════════════╗");
  Serial.println("║  SMART PARKING MANAGEMENT SYSTEM       ║");
  Serial.println("║  9-Slot Configuration                  ║");
  Serial.println("║  Author: Naveen Sanjaya                ║");
  Serial.println("╚════════════════════════════════════════╝\n");

  // Initialize sensor pins
  Serial.println("Initializing sensors...");
  for (int i = 0; i < NUM_SLOTS; i++) {
    pinMode(triggerPins[i], OUTPUT);
    pinMode(echoPins[i], INPUT);
    digitalWrite(triggerPins[i], LOW);
    slotState[i] = false;
    slotDistance[i] = 0;
    
    Serial.print("  Slot ");
    Serial.print(slotNames[i]);
    Serial.print(" (Trig: ");
    Serial.print(triggerPins[i]);
    Serial.print(", Echo: ");
    Serial.print(echoPins[i]);
    Serial.println(")");
  }

  // Initialize LED strip
  Serial.println("\nInitializing LED indicators...");
  strip.begin();
  strip.setBrightness(BRIGHTNESS);
  
  // Startup animation
  Serial.println("Running startup sequence...");
  for(int i = 0; i < NUM_SLOTS; i++) {
    strip.setPixelColor(i, strip.Color(0, 0, 255)); // Blue
    strip.show();
    delay(100);
  }
  
  // Set all to green (available)
  for(int i = 0; i < NUM_SLOTS; i++) {
    strip.setPixelColor(i, strip.Color(0, 255, 0)); // Green
  }
  strip.show();
  
  Serial.println("\n✓ System initialized successfully!");
  Serial.println("✓ All slots marked AVAILABLE (GREEN)");
  Serial.println("\nStarting real-time monitoring...\n");
  
  delay(1000);
}

void loop() {
  static unsigned long lastStatusPrint = 0;
  static int scanCount = 0;
  bool stateChanged = false;
  
  scanCount++;
  
  // Scan all slots
  for (int i = 0; i < NUM_SLOTS; i++) {
    // Read sensor
    long duration = readUltrasonic(triggerPins[i], echoPins[i]);
    int distance = duration * 0.034 / 2;
    
    slotDistance[i] = distance;
    
    // Determine occupancy
    bool isOccupied = (duration > 0 && distance < DETECTION_THRESHOLD);
    
    // Check for state change
    if (slotState[i] != isOccupied) {
      slotState[i] = isOccupied;
      stateChanged = true;
      
      // Update LED
      if (isOccupied) {
        strip.setPixelColor(i, strip.Color(255, 0, 0)); // Red
        Serial.print("🚗 Slot ");
        Serial.print(slotNames[i]);
        Serial.print(" -> OCCUPIED (Vehicle detected at ");
        Serial.print(distance);
        Serial.println("cm)");
      } else {
        strip.setPixelColor(i, strip.Color(0, 255, 0)); // Green
        Serial.print("✓ Slot ");
        Serial.print(slotNames[i]);
        Serial.println(" -> AVAILABLE");
      }
      strip.show();
      
      // JSON output for backend integration
      Serial.print("JSON: {\"slot\":\"");
      Serial.print(slotNames[i]);
      Serial.print("\",\"status\":\"");
      Serial.print(isOccupied ? "OCCUPIED" : "AVAILABLE");
      Serial.print("\",\"distance\":");
      Serial.print(distance);
      Serial.println("}");
    }
    
    delay(50); // Small delay between sensor readings
  }
  
  // Update statistics if any state changed
  if (stateChanged) {
    updateStatistics();
  }
  
  // Print full status every 10 seconds
  if (millis() - lastStatusPrint > 10000) {
    printStatus();
    lastStatusPrint = millis();
  }
  
  delay(100); // Delay between scan cycles
}