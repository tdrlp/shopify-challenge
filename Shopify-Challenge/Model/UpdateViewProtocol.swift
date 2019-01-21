//
//  UpdateViewProtocol.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
	Description: This protocol is used by the asynchronous API calls  in
	order to update the view controller on what is going on
*/
@objc protocol UpdateViewProtocol {
	
	func updateView()
	@objc optional func productListUpdated()
	
}
