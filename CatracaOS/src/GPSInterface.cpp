#include "GPSInterface.h"

GPS::GPS(HardwareSerial &serial) : gpsSerial(serial), latitude(0), longitude(0), altitude(0), speed(0), satellites(0) {}

void GPS::begin(int baudRate) {
    gpsSerial.begin(baudRate);
}

void GPS::loop() {
    parseGPSData();
}

String GPS::getParsedData() const {
    return gpsParsed;
}

float GPS::getLatitude() const {
    return latitude;
}

float GPS::getLongitude() const {
    return longitude;
}

float GPS::getAltitude() const {
    return altitude;
}

float GPS::getSpeed() const {
    return speed;
}

int GPS::getSatellites() const {
    return satellites;
}

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
            gpsParsed = "Lat: " + String(latitude, 6) + "\n" +
                        "Lon: " + String(longitude, 6) + "\n" +
                        "Alt: " + String(altitude) + " m\n" +
                        "Speed: " + String(speed) + " km/h\n" +
                        "Sat: " + String(satellites);
        } else {
            gpsParsed = "No GPS Fix";
        }
    }
}