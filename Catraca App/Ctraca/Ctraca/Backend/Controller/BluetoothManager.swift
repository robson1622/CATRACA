//
//  BluetoothManager.swift
//  Ctraca
//
//  Created by Robson Borges on 10/11/24.
//


import SwiftUI
import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate{
    @Published var centralManager: CBCentralManager?
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var targetPeripheral: CBPeripheral?
    @Published var writeCharacteristic: CBCharacteristic?
    let serviceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    let characteristicUUID = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    // Verifique a autorização dentro de centralManagerDidUpdateState
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth está habilitado.")
        case .poweredOff:
            print("Bluetooth desabilitado.")
        case .unauthorized:
            print("Acesso ao Bluetooth não autorizado.")
        case .unsupported:
            print("Bluetooth não é suportado nesse dispositivo.")
        case .resetting:
            print("Bluetooth está sendo reiniciado.")
        case .unknown:
            print("Status desconhecido.")
        @unknown default:
            print("Estado desconhecido do Bluetooth.")
        }
    }
    func startScanning() {
            discoveredDevices.removeAll()
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            print("Buscando dispositivos BLE...")
        }
        
    func stopScanning() {
        centralManager?.stopScan()
        print("Escaneamento encerrado")
    }
    
    
    // Método para conectar ao dispositivo selecionado
    func connectToDevice(_ peripheral: CBPeripheral) {
        targetPeripheral = peripheral
        targetPeripheral?.delegate = self // Defina o delegate aqui
        centralManager?.stopScan()
        centralManager?.connect(peripheral, options: nil)
        print("Conectando ao dispositivo: \(peripheral.name ?? "Desconhecido")")
    }
    // Delegate para descoberta de periféricos
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
            if !discoveredDevices.contains(peripheral) {
                discoveredDevices.append(peripheral)
            }
        }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Conectado ao dispositivo: \(peripheral.name ?? "Desconhecido")")
        
        // Após a conexão, descubra os serviços
        peripheral.discoverServices(nil)
    }
    // Método para enviar dados (com dados recebidos em `dataToSend`)
    func sendData(data: Data) {
        guard let writeCharacteristic = writeCharacteristic, let peripheral = targetPeripheral else {
            print("Dados ou característica não estão disponíveis")
            return
        }
        
        var offset = 0
        let mtu = 20
        while offset < data.count {
            let chunkSize = min(mtu, data.count - offset)
            let chunk = data.subdata(in: offset..<(offset + chunkSize))
            peripheral.writeValue(chunk, for: writeCharacteristic, type: .withResponse)
            offset += chunkSize
        }
        print("Dados enviados com sucesso.")
    }
    //função de envio do json
    func sendFile<T: Encodable>(_ object: T) {
        guard let writeCharacteristic = writeCharacteristic, let peripheral = targetPeripheral else {
            print("Característica de escrita não disponível")
            return
        }
        var jsonObject : [String: Any]
        print("Convertendo para JSON...")
        do {
            let jsonData = try JSONEncoder().encode(object)
            jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
        } catch {
            print("Erro ao converter para JSON: \(error.localizedDescription)")
            return
        }
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            print("Não foi possível converter em JSON")
            return
        }
        

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            
            // Divide os dados em pacotes de 20 bytes (limite do BLE)
            let chunkSize = 20
            var offset = 0
            let totalChunks = Int(ceil(Double(jsonData.count) / Double(chunkSize)))

            print("Enviando JSON em \(totalChunks) partes...")

            while offset < jsonData.count {
                let length = min(chunkSize, jsonData.count - offset)
                let chunk = jsonData.subdata(in: offset..<offset + length)

                peripheral.writeValue(chunk, for: writeCharacteristic, type: .withResponse)

                // Adiciona um pequeno delay para evitar sobrecarga no ESP32
                usleep(50_000) // 50ms
                
                offset += chunkSize
            }

            print("JSON enviado com sucesso!")
        } catch {
            print("Erro ao serializar JSON: \(error.localizedDescription)")
        }
    }


}

extension BluetoothManager: CBPeripheralDelegate {
    // Método chamado quando os serviços são descobertos
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Erro ao descobrir serviços: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                print("Serviço encontrado: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // Método chamado quando as características são descobertas
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Erro ao descobrir características: \(error.localizedDescription)")
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Característica encontrada: \(characteristic.uuid)")
                if characteristic.uuid == characteristicUUID {
                    writeCharacteristic = characteristic
                    print("Característica de escrita encontrada!")
                }
            }
        }
    }
}

struct BluetoothDeviceListView: View {
    @Binding var connected: Bool
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack {
            List(bluetoothManager.discoveredDevices.filter { $0.name?.contains("CATRACA") == true }, id: \.identifier) { peripheral in
                Button(action: {
                    bluetoothManager.connectToDevice(peripheral)
                    if bluetoothManager.targetPeripheral == peripheral {
                        connected = true
                    }
                }) {
                    HStack {
                        Text(peripheral.name ?? "Desconhecido - \(peripheral.identifier.uuidString)") // Show UUID if no name
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        if bluetoothManager.targetPeripheral == peripheral {
                            Text("Conectado")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .onAppear {
                bluetoothManager.startScanning()
            }
            .onDisappear {
                bluetoothManager.stopScanning()
            }
        }
        .background(Color.black)
    }
}

