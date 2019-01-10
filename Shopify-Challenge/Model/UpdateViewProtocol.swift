//
//  UpdateViewProtocol.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol UpdateViewProtocol {
	
	func updateView(dictionary: [String : JSON])
	
}
