#pragma once

#include <Arduino.h>
#include <SD.h>


#include "Touch_GT911.h"
#include "TAMC_GT911.h"


#include <LGFX_TFT_eSPI.hpp>

extern TFT_eSPI tft;
static const char* calibrationFile PROGMEM = "";
extern bool repeatCalib;

extern uint16_t TFT_WIDTH;
extern uint16_t TFT_HEIGHT;
extern bool waitScreenRefresh;                  // Wait for refresh screen (screenshot issues)

void tftOn(uint8_t brightness);
void tftOff();
void touchCalibrate();
void initTFT();

#endif
