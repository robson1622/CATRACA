#include <TinyGPS++.h>
#include <HardwareSerial.h>

class GPS {
public:
    // Constructor
    GPS(HardwareSerial &serial);

    // Initialize the GPS module
    void begin(int baudRate, int rxPin, int txPin);

    // Main loop to process GPS data
    void loop();

    // Get parsed GPS data as a string
    String getParsedData() const;

    // Get latitude
    float getLatitude() const;

    // Get longitude
    float getLongitude() const;

    // Get altitude
    float getAltitude() const;

    // Get speed
    float getSpeed() const;

    // Get number of satellites
    int getSatellites() const;

    String getFix();

private:
    // Parse incoming GPS data
    void parseGPSData();

    // Reference to the HardwareSerial object
    HardwareSerial &gpsSerial;

    // TinyGPS++ object for parsing GPS data
    TinyGPSPlus gps;

    // Variables to store parsed GPS data
    String gpsParsed;
    float latitude;
    float longitude;
    float altitude;
    float speed;
    int satellites;
};