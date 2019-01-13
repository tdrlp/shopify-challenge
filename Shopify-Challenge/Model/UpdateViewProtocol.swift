//
//  UpdateViewProtocol.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import Foundation
import SwiftyJSON

@objc protocol UpdateViewProtocol {
	
	func updateView()
	@objc optional func productListUpdated()
	
}
