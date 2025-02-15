//
//  BluetoothManager.swift
//  Ctraca
//
//  Created by Robson Borges on 10/11/24.
//


import SwiftUI
import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var centralManager: CBCentralManager?
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var targetPeripheral: CBPeripheral?
    @Published var dataToSend: Data?
    @Published var writeCharacteristic: CBCharacteristic?
    
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
    // Método para iniciar o escaneamento
    func startScanning() {
        discoveredDevices.removeAll()
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        print("Buscando dispositivos...")
    }
    
    // Método para parar o escaneamento
    func stopScanning() {
        centralManager?.stopScan()
        print("Escaneamento encerrado")
    }
    
    // Método para conectar ao dispositivo selecionado
    func connectToDevice(_ peripheral: CBPeripheral) {
        targetPeripheral = peripheral
        targetPeripheral?.delegate = self
        centralManager?.stopScan()
        centralManager?.connect(peripheral, options: nil)
        print("Conectando ao dispositivo: \(peripheral.name ?? "Desconhecido")")
    }
    // Delegate para descoberta de periféricos
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Dispositivo descoberto: \(peripheral.identifier.uuidString)")
        if let name = peripheral.name {
            print("Nome do dispositivo: \(name)")
        } else {
            print("Nome do dispositivo não disponível. Exibindo o UUID: \(peripheral.identifier.uuidString)")
        }
        
        if !discoveredDevices.contains(peripheral) {
            discoveredDevices.append(peripheral)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Conectado ao dispositivo: \(peripheral.name ?? "Desconhecido")")
        
        // Após a conexão, descubra os serviços
        peripheral.discoverServices(nil)
    }
    
    // Delegate para descoberta de serviços
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                // Descobre as características do serviço
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // Delegate para descoberta de características
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // Aqui você pode verificar se a característica é do tipo que você deseja ler ou escrever
                // Exemplo de leitura de valor:
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
                if characteristic.properties.contains(.write) {
                    writeCharacteristic = characteristic
                }
            }
        }
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
}

struct BluetoothDeviceListView: View {
    @Binding var connected : Bool
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack {
            List(bluetoothManager.discoveredDevices, id: \.identifier) { peripheral in
                Button(action: {
                    bluetoothManager.connectToDevice(peripheral)
                    if bluetoothManager.targetPeripheral == peripheral {
                        connected = true
                    }
                }) {
                    HStack {
                        Text(peripheral.name ?? "Desconhecido - \(peripheral.identifier.uuidString)") // Exibe o UUID se não houver nome
                            .lineLimit(1)
                            .truncationMode(.tail) // Garante que o texto se ajuste na tela
                        
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
        .background(Color.white)
    }
}

