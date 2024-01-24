//
//  ViewController.swift
//  swiftSerialConnection
//
//  Created by Peter Rogers on 24/01/2024.
//

import UIKit

class ViewController: UIViewController, SerialUpdateDelegate{
	
	@IBOutlet weak var slider1: UISlider!
	
	
	var serialPort:SerialController?
	
	
	
	func serialResponse(newValue: [Int]) {
		print(newValue)
		slider1.value = Float(newValue[0])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		serialPort = SerialController()
		serialPort?.delegate = self
		
		// Do any additional setup after loading the view.
	}


}

