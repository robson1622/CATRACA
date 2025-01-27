#ifndef SDINTERFACE_H
#define SDINTERFACE_H

#include <Arduino.h>
#include "SPI.h"
#include "SD.h"
#include "FS.h"

#define SD_CS         5
#define SPI_MOSI      23
#define SPI_MISO      19
#define SPI_SCK       18

class SDInterface {
public:
    SDInterface(uint8_t csPin);
    bool begin();
    File openFile(const char* path, const char* mode);
    String listDir(const char* dirname, uint8_t levels);
    bool removeFile(const char* path);
    void listAllFiles(const char* dirname);
    String listDirToString(const char* dirname, uint8_t levels);
    void getCardInfo(uint64_t &totalBytes, uint64_t &usedBytes);
    String readFileToString(const char* path); // Add this declaration

private:
    uint8_t _csPin;
};

#endif // SDINTERFACE_H