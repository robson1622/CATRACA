#include <TinyGPS++.h>
#include <HardwareSerial.h>

class GPS {
public:
    GPS(HardwareSerial &serial);
    void begin(int baudRate, int rxPin, int txPin);
    void loop();
    String getParsedData() const;
    float getLatitude() const;
    float getLongitude() const;
    float getAltitude() const;
    float getSpeed() const;
    int getSatellites() const;

    String getFix();
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