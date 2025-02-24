#include <Arduino.h>
#include <NimBLEDevice.h>

static NimBLEServer* pServer;

// Variáveis para armazenar os dados recebidos e o status do arquivo
std::string receivedData;       // Armazena todos os dados recebidos
bool isFileComplete = false;    // Indica se o arquivo foi completamente recebido

class CharacteristicCallbacks : public NimBLECharacteristicCallbacks {
    void onWrite(NimBLECharacteristic* pCharacteristic, NimBLEConnInfo& connInfo) override {
        // Adiciona os dados recebidos à variável receivedData
        std::string newData = pCharacteristic->getValue();
        receivedData += newData;

        // Verifica se o arquivo foi completamente recebido
        // (Aqui você pode implementar uma lógica para detectar o final do arquivo)
        // Exemplo: Se o último caractere for um '\0' (null), considera o arquivo completo
        if (!newData.empty() && newData.back() == '\0') {
            isFileComplete = true;
            Serial.println("Arquivo completamente recebido!");
        }

        Serial.printf("Dados recebidos parcialmente: %s\n", newData.c_str());
    }
} chrCallbacks;

void setup(void) {
    Serial.begin(115200);
    Serial.printf("Iniciando servidor NimBLE...\n");

    NimBLEDevice::init("NimBLE");

    pServer = NimBLEDevice::createServer();

    // Defina o UUID do serviço
    NimBLEService* pService = pServer->createService("4fafc201-1fb5-459e-8fcc-c5c9c331914b");

    // Defina o UUID da característica
    NimBLECharacteristic* pCharacteristic =
        pService->createCharacteristic("beb5483e-36e1-4688-b7f5-ea07361b26a8",
                                       NIMBLE_PROPERTY::WRITE);

    pCharacteristic->setCallbacks(&chrCallbacks);

    // Inicie o serviço
    pService->start();

    // Configure o advertising
    NimBLEAdvertising* pAdvertising = NimBLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(pService->getUUID());
    pAdvertising->setName("CATRACA");
    pAdvertising->start();

    Serial.printf("Advertising iniciado. Aguardando conexão...\n");
}

void loop() {
    // Verifica se o arquivo foi completamente recebido
    if (isFileComplete) {
        Serial.printf("Arquivo recebido completamente. Dados:\n%s\n", receivedData.c_str());

        // Limpa os dados e reseta a flag
        receivedData.clear();
        isFileComplete = false;
        Serial.println("Pronto para receber um novo arquivo.");
    }

    delay(1000); // Pequeno delay para evitar sobrecarga do loop
}