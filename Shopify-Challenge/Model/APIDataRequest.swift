//
//  APIDataRequest.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class APIDataRequest {
	
	// URLs used for the API calls
	let collectionsURL: String
	private var specificCollectionURL: String
	private var specificProductsURL: String
	
	// JSON containing the data from the last request
	private var JsonData: JSON?
	private var formattedDictionary: Dictionary = [String : JSON]()
	
	// arrays of item IDs
	var collectionIDs: [Int]
	var productIDs: [Int]
	
	// delegates
	var viewDelegate: UpdateViewProtocol?
	
	init() {
		
		collectionsURL = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
		specificCollectionURL = ""
		specificProductsURL = ""
		
		JsonData = nil
		
		collectionIDs = []
		productIDs = []
		
	}
	
	//
	func requestData(url: String) {
		print("requesting data")
		
		Alamofire.request(url).responseJSON { (response) in
			
			print("REQUEST: \(String(describing: response.request))")
			//print("RESPONSE: \(String(describing: response.response))")
			
			if let json = response.result.value {
				
				// save the returned json
				self.JsonData = JSON(json)
				
				// determine which json was requested
				if let flag: APICallFlags = self.getUrlType(url: url) {
					
					self.extractIDs(json: self.JsonData!, flag: flag)
					
					// update the UI
					self.jsonToDictionary(json: self.JsonData!, flag: flag)
					self.viewDelegate?.updateView(dictionary: self.formattedDictionary)
					
				}
			}
		}
	}
	
	private func jsonToDictionary(json: JSON, flag: APICallFlags) {
		
		var retDictionary: Dictionary = [String : JSON]()
		
		if let collection: (name: String, id: String) = getCollectionQueryVals(flag: flag) {
			
			let collectionName: String = collection.name
			let collectionId: String = collection.id
			
			for collection in json[collectionName] {
				
				retDictionary["\(collection.1[collectionId])"] = collection.1
				
			}
		}
		
		self.formattedDictionary = retDictionary
		
	}
	
	private func getUrlType(url: String) -> APICallFlags? {
		
		if url.contains("custom_collections.json") {
			return APICallFlags.allCollections
		}
		else if url.contains("collects.json") {
			return APICallFlags.collection
		}
		else if url.contains("products.json") {
			return APICallFlags.products
		}
		
		return nil
		
	}
	
	private func extractIDs(json: JSON, flag: APICallFlags) {
		
		// get the strings of elements to access
		if let collection: (name: String, id: String) = getCollectionQueryVals(flag: flag) {
			
			var temp: [Int] = []
			
			let collectionName: String = collection.name
			let collectionId: String = collection.id
			
			// fill the array with the IDs
			for id in json[collectionName] {
				
				temp.append(id.1[collectionId].intValue)
				
			}
			
			// update the list of IDs
			if flag == APICallFlags.allCollections {
				
				self.collectionIDs = temp
				
			}
			else if flag == APICallFlags.collection {
				
				self.productIDs = temp
				
			}
			
			
		}
	}
	
	private func getCollectionQueryVals(flag: APICallFlags) -> (String, String)? {
		
		// check which flag is set
		if flag == APICallFlags.allCollections {
			
			return ("custom_collections", "id")
			
		}
		else if flag == APICallFlags.collection {
			
			return ("collects", "product_id")
			
		}
		
		return nil
		
	}
	
	func getCollectionURL(collectionID: Int) -> String {
		
		return "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collectionID)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
		
	}
	
	func getProductsURL() -> String {
		
		// the product IDs added together and separated by a comma
		var idStringList: String = ""
		
		for (index, id) in self.productIDs.enumerated() {
			
			idStringList += "\(id)"
			
			// add comma if not the last id in list of ids
			if index != self.productIDs.endIndex-1 {
				idStringList += ","
			}
			
		}
		
		return "https://shopicruit.myshopify.com/admin/products.json?ids=\(idStringList)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
		
	}
	
}
