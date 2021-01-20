//
//  ViewController.swift
//  bluetoothdemo
//
//  Created by meiliangjun1_vendor on 2020/12/25.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centerManager: CBCentralManager!
    var peripherals: [CBPeripheral] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        centerManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(), options: [CBCentralManagerOptionRestoreIdentifierKey: "centralManagerIdentifier"])
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard event?.type == .remoteControl else {
            print("remote control received event type: \(String(describing: event?.subtype.rawValue))")
            return
        }
        
        print("remote control received event subtype: \(String(describing: event?.subtype.rawValue))")
    }
    
    // MARK: CBPeripheralDelegate
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("peripheral did discover services error:\(String(describing: error))")
            return
        }
        
        print("peripheral name: \(String(describing: peripheral.name)), state: \(peripheral.state))")
    }

    // MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("is scanning:\(central.isScanning) state: \(central.state.rawValue)")
        guard central.state == .poweredOn else {
            return
        }
        
        centerManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard (peripheral.name != nil) else {
            return
        }
        print("peripheral name: \(String(describing: peripheral.name)) state: \(peripheral.state.rawValue)")//, advertisement data: \(advertisementData), rssi: \(RSSI)")
        peripherals.append(peripheral)
        
//        peripheral.delegate = self
//        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        
    }
}

