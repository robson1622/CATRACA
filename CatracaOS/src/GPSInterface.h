#ifndef GPSINTERFACE_H
#define GPSINTERFACE_H

#include <TinyGPS++.h>
#include <HardwareSerial.h>

class GPS {
public:
    GPS(HardwareSerial &serial);
    void begin(int baudRate);
    void loop();
    String getParsedData() const;
    float getLatitude() const;
    float getLongitude() const;
    float getAltitude() const;
    float getSpeed() const;
    int getSatellites() const;

private:
    void parseGPSData();
    HardwareSerial &gpsSerial;
    TinyGPSPlus gps;
    String gpsParsed;
    float latitude;
    float longitude;
    float altitude;
    float speed;
    int satellites;
};

#endif // GPSINTERFACE_H