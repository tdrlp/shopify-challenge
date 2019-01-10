//
//  ViewController.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UpdateViewProtocol {

	private let data = APIDataRequest()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		data.viewDelegate = self
		
		// get data to fill collections with
		data.requestData(url: data.collectionsURL)
	}

	func updateView(dictionary: [String : JSON]) {
		
		
		
	}

}

