#include "BluetoothReceiver.h"

// BLE UUIDs
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

// Constructor
BluetoothReceiver::BluetoothReceiver() {
  response = "";
  complete = false;
  pCharacteristic = nullptr;
}

// Initialize BLE
void BluetoothReceiver::setupBLE() {
  NimBLEDevice::init("Catraca"); // Use NimBLEDevice instead of BLEDevice
  NimBLEServer *pServer = NimBLEDevice::createServer();

  NimBLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    NIMBLE_PROPERTY::READ | NIMBLE_PROPERTY::WRITE // Use NIMBLE_PROPERTY instead of BLECharacteristic properties
  );

  pCharacteristic->setCallbacks(this); // Set callbacks
  pCharacteristic->setValue("Hello World");
  pService->start();

  NimBLEAdvertising *pAdvertising = NimBLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();
}

// Callback for when data is written to the characteristic
void BluetoothReceiver::onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo &connInfo) {
    String value = pCharacteristic->getValue();

    if (value.length() > 0) {
        // Concatenate packets into the response
        response += value.c_str();

        // Check if the JSON is fully received
        if (response.endsWith("}")) {  // Alternatively, use a control character defined in Swift
            complete = true;
            Serial.println(">>> Complete message received!");
            Serial.println(response);
        }
    }
}

// Check if the message is fully received
bool BluetoothReceiver::isComplete() {
  return complete;
}

// Get the complete message
String BluetoothReceiver::getResponse() {
  return response;
}

// Clear the response for the next message
void BluetoothReceiver::clearResponse() {
  response = "";
  complete = false;
}