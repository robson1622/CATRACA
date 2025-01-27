#include "SDInterface.h"

SDInterface::SDInterface(uint8_t csPin) : _csPin(csPin) {}

bool SDInterface::begin() {
    pinMode(_csPin, OUTPUT);
    digitalWrite(_csPin, HIGH);
    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    SPI.setFrequency(1000000);
    return SD.begin(_csPin);
}

File SDInterface::openFile(const char* path, const char* mode) {
    return SD.open(path, mode);
}

String SDInterface::listDir(const char* dirname, uint8_t levels) {
    String result = "";
    File root = SD.open(dirname);
    if (!root) {
        return "Failed to open directory";
    }
    if (!root.isDirectory()) {
        return "Not a directory";
    }

    File file = root.openNextFile();
    while (file) {
        if (file.isDirectory()) {
            result += "DIR : ";
            result += file.name();
            result += "\n";
            if (levels) {
                result += listDir(file.name(), levels - 1);
            }
        } else {
            result += file.name();
            result += "\t- ";
            result += String(file.size());
            result += " B\n";
        }
        file = root.openNextFile();
    }
    return result;
}

bool SDInterface::removeFile(const char* path) {
    return SD.remove(path);
}

void SDInterface::listAllFiles(const char* dirname) {
    File root = SD.open(dirname);
    if (!root) {
        Serial.println("Failed to open directory");
        return;
    }
    if (!root.isDirectory()) {
        Serial.println("Not a directory");
        return;
    }

    File file = root.openNextFile();
    while (file) {
        if (file.isDirectory()) {
            listAllFiles(file.name());
        } else {
            Serial.print("FILE: ");
            Serial.print(file.name());
            Serial.print("\tSIZE: ");
            Serial.println(file.size());
        }
        file = root.openNextFile();
    }
}

String SDInterface::listDirToString(const char* dirname, uint8_t levels) {
    String result = "";
    File root = SD.open(dirname);
    if (!root) {
        return "Failed to open directory";
    }
    if (!root.isDirectory()) {
        return "Not a directory";
    }

    File file = root.openNextFile();
    while (file) {
        if (file.isDirectory()) {
            result += "DIR : ";
            result += file.name();
            result += "\n";
            if (levels) {
                result += listDirToString(file.name(), levels - 1);
            }
        } else {
            result += "FILE: ";
            result += file.name();
            result += "\tSIZE: ";
            result += String(file.size());
            result += "\n";
        }
        file = root.openNextFile();
    }
    return result;
}

void SDInterface::getCardInfo(uint64_t &totalBytes, uint64_t &usedBytes) {
    totalBytes = SD.cardSize();
    usedBytes = SD.usedBytes();
}

String SDInterface::readFileToString(const char* path) {
    File file = SD.open(path, FILE_READ);
    if (!file) {
        return "Failed to open file";
    }

    String content = "";
    while (file.available()) {
        content += (char)file.read();
    }
    file.close();
    return content;
}