#include "GPSInterface.h"
#include <lvgl.h>

// Constructor
GPS::GPS(HardwareSerial &serial) : gpsSerial(serial) {
    // Initialize member variables
    gpsParsed = "";
    latitude = 0.0;
    longitude = 0.0;
    altitude = 0.0;
    speed = 0.0;
    satellites = 0;
}

// Initialize the GPS module with RX and TX pins
void GPS::begin(int baudRate, int rxPin, int txPin) {
    gpsSerial.begin(baudRate, SERIAL_8N1, rxPin, txPin);
    Serial.println("GPS module initialized.");
}

// Main loop to process GPS data
void GPS::loop() {
    parseGPSData();
}

// Parse incoming GPS data
void GPS::parseGPSData() {
    while (gpsSerial.available() > 0) {
        char incomingByte = gpsSerial.read();
        gps.encode(incomingByte);

        if (gps.location.isValid()) {
            latitude = gps.location.lat();
            longitude = gps.location.lng();
            altitude = gps.altitude.meters();
            speed = gps.speed.kmph();
            satellites = gps.satellites.value();

            gpsParsed = "Lat: " + String(latitude, 6) + 
                        " | Lon: " + String(longitude, 6) + 
                        " | Alt: " + String(altitude) + " m" +
                        " | Speed: " + String(speed) + " km/h" +
                        " | Sats: " + String(satellites);
        } else {
            gpsParsed = "No GPS Fix";
            latitude = 0.0;
            longitude = 0.0;
            altitude = 0.0;
            speed = 0.0;
            satellites = 0;
        }
    }
    Serial.flush();
    Serial.print("###############################");
    Serial.println(gpsParsed);
    LV_LOG_USER(gpsParsed.c_str());
}

// Get parsed GPS data as a string
String GPS::getParsedData() const {
    return gpsParsed;
}

// Get latitude
float GPS::getLatitude() const {
    return latitude;
}

// Get longitude
float GPS::getLongitude() const {
    return longitude;
}

// Get altitude
float GPS::getAltitude() const {
    return altitude;
}

// Get speed
float GPS::getSpeed() const {
    return speed;
}

// Get number of satellites
int GPS::getSatellites() const {
    return satellites;
}

String GPS::getFix() {
    return gps.location.isValid() ? "Fix" : "No Fix";
}