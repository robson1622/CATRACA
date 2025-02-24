#ifndef BLUETOOTHRECEIVER_H
#define BLUETOOTHRECEIVER_H

#include <NimBLEDevice.h> // Use NimBLE instead of BLEDevice
#include <Arduino.h>

class BluetoothReceiver : public NimBLECharacteristicCallbacks {
  private:
    String response; // Stores received data
    bool complete;  // Indicates if the response is fully received
    NimBLECharacteristic *pCharacteristic;

  public:
    BluetoothReceiver();
    void setupBLE();
    void onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo &connInfo) override; // Override the onWrite method
    bool isComplete();
    String getResponse();
    void clearResponse();
};

#endif