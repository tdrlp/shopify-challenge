//
//  APICallFlags.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import Foundation

struct APICallFlags: OptionSet {
	
	let rawValue: Int
	
	static let allCollections = APICallFlags(rawValue: 1 << 0)
	static let collection = APICallFlags(rawValue: 1 << 1)
	static let products = APICallFlags(rawValue: 1 << 2)
	
}
