//
//  Product.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-13.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product {
	
	var id: Int = 0
	var title: String = ""
	var tags: [String] = []
	var inventory: Int = 0
	var image: [String : Any] = [
		"name" : "",
		"url" : "",
		"loaded" : UIImage(named: "") as Any
	]
	
}
