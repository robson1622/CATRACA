#ifndef TRIPDATA_H
#define TRIPDATA_H

#include <Arduino.h>

class TripData {
private:
  String startPoint;
  String endPoint;
  float distance;       // Distance in kilometers
  String date;          // Date in DD/MM/YYYY format
  int time;             // Time in seconds
  float maxSpeed;       // Maximum speed in km/h
  float averageSpeed;   // Average speed in km/h

public:
  // Constructor
  TripData();

  // Getters
  String getStartPoint() const;
  String getEndPoint() const;
  float getDistance() const;
  String getDate() const;
  int getTime() const;
  float getMaxSpeed() const;
  float getAverageSpeed() const;

  // Setters
  void setStartPoint(const String &start);
  void setEndPoint(const String &end);
  void setDistance(float dist);
  void setDate(const String &dt);
  void setTime(int t);
  void setMaxSpeed(float max);
  void setAverageSpeed(float avg);

  // Parse a CSV line into the TripData object
  void parseCSVLine(const String &line);

  // Display trip data as a formatted string
  String toString() const;
};

#endif