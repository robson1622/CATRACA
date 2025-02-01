#include "RenderMap.h"
#include <SD.h>

LVVectorMap::LVVectorMap(lv_obj_t *parent) {
    buffer = (lv_color_t *)ps_malloc(TILE_WIDTH * TILE_HEIGHT * sizeof(lv_color_t));
    canvas = lv_canvas_create(parent);
    lv_canvas_set_buffer(canvas, buffer, TILE_WIDTH, TILE_HEIGHT, LV_IMG_CF_TRUE_COLOR);
    lv_obj_center(canvas);
}

LVVectorMap::~LVVectorMap() {s
    if(buffer) free(buffer);
    lv_obj_del(canvas);
}

void LVVectorMap::setPosition(double lat, double lon) {
    current_lat = lat;
    current_lon = lon;
    loadMapData();
}

void LVVectorMap::setZoom(uint8_t zoom) {
    current_zoom = (zoom > MAX_ZOOM) ? MAX_ZOOM : zoom;
    redraw();
}

void LVVectorMap::redraw() {
    lv_canvas_fill_bg(canvas, lv_color_hex(0xEF5D), LV_OPA_COVER);
    drawPolylines();
    drawPolygons();
    lv_obj_invalidate(canvas);
}

void LVVectorMap::loadMapData() {
    // Convert GPS to tile coordinates
    uint32_t x = lon2tilex(current_lon, current_zoom);
    uint32_t y = lat2tiley(current_lat, current_zoom);
    
    char path[40];
    snprintf(path, sizeof(path), "/VECTMAP/%d/%d/%d.fmp", current_zoom, x, y);
    
    File file = SD.open(path);
    if(file) {
        ReadBufferingStream bufferedFile(file, 2048);
        parseBlockFile(bufferedFile);
        file.close();
    } else {
        lv_canvas_fill_bg(canvas, lv_color_hex(0x0000), LV_OPA_COVER);
    }
}

// Original parsing functions from your code adapted for LVGL
int16_t LVVectorMap::parseInt16(Stream &file) {
    String numStr;
    char c;
    while(file.available()) {
        c = file.read();
        if(c == ';' || c == ',' || c == '\n') break;
        numStr += c;
    }
    return numStr.toInt();
}

void LVVectorMap::parseStrUntil(Stream &file, char terminator, String &str) {
    str = "";
    char c;
    while(file.available()) {
        c = file.read();
        if(c == terminator || c == '\n') break;
        str += c;
    }
}

void LVVectorMap::parseCoords(Stream &file, std::vector<lv_point16_t> &points) {
    String str;
    while(file.available()) {
        lv_point16_t point;
        parseStrUntil(file, ',', str);
        if(str.length() == 0) break;
        point.x = str.toInt();
        
        parseStrUntil(file, ';', str);
        point.y = str.toInt();
        
        points.push_back(point);
    }
}

void LVVectorMap::parseBlockFile(Stream &file) {
    polygons.clear();
    polylines.clear();
    
    String line;
    while(file.available()) {
        parseStrUntil(file, ':', line);
        
        if(line == "Polygons") {
            int16_t count = parseInt16(file);
            while(count-- > 0) {
                lv_polygon_t polygon;
                
                // Color
                parseStrUntil(file, '\n', line);
                polygon.color = strtol(line.c_str() + 2, NULL, 16);
                
                // Max zoom
                parseStrUntil(file, '\n', line);
                polygon.max_zoom = line.toInt();
                
                // BBox
                parseStrUntil(file, ':', line); // "bbox"
                polygon.bbox.x1 = parseInt16(file);
                polygon.bbox.y1 = parseInt16(file);
                polygon.bbox.x2 = parseInt16(file);
                polygon.bbox.y2 = parseInt16(file);
                
                // Coords
                parseStrUntil(file, ':', line); // "coords"
                parseCoords(file, polygon.points);
                
                polygons.push_back(polygon);
            }
        }
        else if(line == "Polylines") {
            int16_t count = parseInt16(file);
            while(count-- > 0) {
                lv_polyline_t polyline;
                
                // Color
                parseStrUntil(file, '\n', line);
                polyline.color = strtol(line.c_str() + 2, NULL, 16);
                
                // Width
                parseStrUntil(file, '\n', line);
                polyline.width = line.toInt();
                
                // Max zoom
                parseStrUntil(file, '\n', line);
                polyline.max_zoom = line.toInt();
                
                // BBox
                parseStrUntil(file, ':', line); // "bbox"
                polyline.bbox.x1 = parseInt16(file);
                polyline.bbox.y1 = parseInt16(file);
                polyline.bbox.x2 = parseInt16(file);
                polyline.bbox.y2 = parseInt16(file);
                
                // Coords
                parseStrUntil(file, ':', line); // "coords"
                parseCoords(file, polyline.points);
                
                polylines.push_back(polyline);
            }
        }
    }
}

void LVVectorMap::drawPolylines() {
    for(auto &line : polylines) {
        if(current_zoom > line.max_zoom) continue;
        
        for(size_t i = 0; i < line.points.size() - 1; i++) {
            lv_point_t points[2] = {
                {line.points[i].x, TILE_HEIGHT - line.points[i].y},
                {line.points[i+1].x, TILE_HEIGHT - line.points[i+1].y}
            };
            lv_canvas_draw_line(canvas, points, 2, line.color);
        }
    }
}

void LVVectorMap::drawPolygons() {
    for(auto &poly : polygons) {
        if(current_zoom > poly.max_zoom) continue;
        
        lv_point_t points[poly.points.size()];
        for(size_t i = 0; i < poly.points.size(); i++) {
            points[i] = {poly.points[i].x, TILE_HEIGHT - poly.points[i].y};
        }
        lv_canvas_draw_polygon(canvas, points, poly.points.size(), poly.color);
    }
}