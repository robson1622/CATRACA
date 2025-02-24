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
    func disconectDevice() {
        centralManager?.cancelPeripheralConnection(targetPeripheral!)
        targetPeripheral = nil
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
    func sendFile<T: Encodable>(_ object: T,percent : Binding<Int>) async -> String {
        guard let writeCharacteristic = writeCharacteristic, let peripheral = targetPeripheral else {
            print("Característica de escrita não disponível")
            return "Error"
        }
        var jsonObject : [String: Any]
        do {
            let jsonData = try JSONEncoder().encode(object)
            jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
        } catch {
            print("Erro ao converter para JSON: \(error.localizedDescription)")
            return  "Error"
        }
        guard JSONSerialization.isValidJSONObject(jsonObject) else {
            print("Não foi possível converter em JSON")
            return  "Error"
        }
        

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            
            // Divide os dados em pacotes de 20 bytes (limite do BLE)
            let chunkSize = 20
            var offset = 0
            
            while offset < jsonData.count {
                let length = min(chunkSize, jsonData.count - offset)
                let chunk = jsonData.subdata(in: offset..<offset + length)

                peripheral.writeValue(chunk, for: writeCharacteristic, type: .withResponse)

                // Adiciona um pequeno delay para evitar sobrecarga no ESP32
                try await Task.sleep(nanoseconds: 500_000_00)  // 50ms
                
                await MainActor.run {
                    percent.wrappedValue = Int((Double(offset + 1) * 100.0) / Double(jsonData.count))
                }
                offset += chunkSize
            }
            return "Succses"
        } catch {
            print("Erro ao serializar JSON: \(error.localizedDescription)")
        }
        return "Succses"
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
            
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(bluetoothManager.discoveredDevices.filter { $0.name != nil }, id: \.identifier) { peripheral in
                        Button(action: {
                            bluetoothManager.connectToDevice(peripheral)
                            if bluetoothManager.targetPeripheral == peripheral {
                                connected = true
                            }
                        }) {
                            HStack {
                                if peripheral.name != nil {
                                    Text(peripheral.name!) // Mostra o nome do dispositivo
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .foregroundColor(.black) // Cor fixa para o texto
                                }
                                
                                Spacer()
                                
                                if bluetoothManager.targetPeripheral == peripheral {
                                    Text("Conectado")
                                        .foregroundColor(.green) // Cor fixa para o texto "Conectado"
                                }
                            }
                            .padding() // Adiciona padding para melhorar o espaçamento
                            .frame(maxWidth: .infinity, alignment: .leading) // Alinha o conteúdo à esquerda
                            .background(Color.white) // Cor fixa para o fundo de cada item
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove o estilo padrão do botão
                        Divider()
                    }
                }
                .background(Color.white) // Cor fixa para o fundo da lista
            }
            .onAppear {
                bluetoothManager.startScanning()
            }
            .onDisappear {
                bluetoothManager.stopScanning()
            }
            .background(Color.white) // Cor fixa para o fundo da ScrollView
        }
    }
}

