//
//  SerialController.swift
//  swiftSerialConnection
//
//  Created by Peter Rogers on 24/01/2024.
//

import Foundation
import ORSSerial

class SerialController:NSObject, ORSSerialPortDelegate{
	
	weak var delegate: SerialUpdateDelegate?
	
	var serialPort: ORSSerialPort? {
		didSet {
			oldValue?.close()
			oldValue?.delegate = nil
			serialPort?.delegate = self
		}
	}
	
	override init(){
		super.init()
		openOrClosePort()
	}
	
	func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
		self.serialPort = nil
	}
		
	func openOrClosePort() {
		print("port closed")
		let availablePorts = ORSSerialPortManager.shared().availablePorts
		print(availablePorts)
		self.serialPort = ORSSerialPort(path: availablePorts[0].path)
		// self.serialPort = availablePorts[0]
		self.serialPort?.baudRate = 9600
		self.serialPort?.open()
		print("port opened")
		let inc = [0,0,10]
		delegate?.serialResponse(newValue: inc)
	}
	
	func serialPortWasOpened(_ serialPort: ORSSerialPort) {
		//self.openCloseButton.title = "Close"
		let descriptor = ORSSerialPacketDescriptor(prefixString: "<", suffixString: ">", maximumPacketLength: 8, userInfo: nil)
		serialPort.startListeningForPackets(matching: descriptor)
	}
	
	func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
		
		if let dataAsString = NSString(data: packetData, encoding: String.Encoding.ascii.rawValue) {
			let valueString = dataAsString.substring(with: NSRange(location: 1, length: dataAsString.length-2))
			
			let inArray = valueString.components(separatedBy: ",")
			let arrayInt = inArray.compactMap { Int($0) }
			delegate?.serialResponse(newValue: arrayInt)
			
			
		}
		
	}
	
	func serialPortWasClosed(_ serialPort: ORSSerialPort) {
		//self.openCloseButton.title = "Open"
	}
	
   
 
	
	func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
		self.serialPort = nil
		// self.openCloseButton.title = "Open"
	}
	
	func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
		print("SerialPort \(serialPort) encountered an error: \(error)")
	}
	
	func sendData(string:String) {
		
		if let data = string.data(using: String.Encoding.utf8) {
			self.serialPort?.send(data)
		}
	}

}

protocol SerialUpdateDelegate: AnyObject {
	func serialResponse(newValue: [Int])
}
