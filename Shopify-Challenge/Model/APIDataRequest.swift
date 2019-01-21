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
	static let collectionsURL: String = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
	
	// JSON containing the data from the last request
	private var JsonData: JSON?
	private var selectedCollectionID: Int?
	
	var collections: [Collection] = []
	var products: [Product] = []
	
	// delegates
	var viewDelegate: UpdateViewProtocol?
	
	init() {
		
		JsonData = nil
		
	}
	
	/*
		Description: This method makes the API request and handles the response
	*/
	func requestData(url: String) {
		
		Alamofire.request(url).responseJSON { (response) in
			
			//print("REQUEST: \(String(describing: response.request))")
			//print("RESPONSE: \(String(describing: response.response))")
			
			if let json = response.result.value {
				
				self.JsonData = JSON(json)
				
				guard let flag: APICallFlags = self.getUrlType(url: url) else {	return }
				
				// the collections json was requested
				if flag == APICallFlags.allCollections {
					
					self.extractCollectionDetails(json: self.JsonData!)
					
					self.viewDelegate?.updateView()
					
				}
				// the collection product list json was requested
				else if flag == APICallFlags.collection {
					
					// pull the collection id from the url
					guard let id = self.extractCollectionIDFromURL(url: url) else { return }
					self.selectedCollectionID = id
					self.extractCollectionProductIDs(json: self.JsonData!, collectionID: id)
					
					// let the controller know that the product list was updated
					self.viewDelegate?.productListUpdated!()
					
				}
				// the products information json was requested
				else if flag == APICallFlags.products {
					
					self.extractProductsInformation(json: self.JsonData!)
					
					self.viewDelegate?.updateView()
					
				}
			}
		}
	}
	
	/*
		Description: This method identifies which of the 3 urls was passed in
	*/
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
	
	/*
		Description: This method extracts the information about the products and puts them
		in a products list for easy access
	*/
	private func extractProductsInformation(json: JSON) {

		var newProductList: [Product] = []
		
		for product in json["products"] {
			
			let tempProduct = Product()
			
			guard let collectionID = selectedCollectionID else { return }
			
			// get the index of the requested collection
			guard let collectionIndex: Int = collections.firstIndex(where: { $0.id == collectionID }) else { return }
			
			tempProduct.id = product.1["id"].intValue
			tempProduct.title = product.1["title"].stringValue.replacingOccurrences(of: collections[collectionIndex].title + " ", with: "")
			tempProduct.tags = product.1["tags"].stringValue.components(separatedBy: ", ")
			tempProduct.image["url"] = product.1["image"]["src"].stringValue
			tempProduct.image["name"] = tempProduct.title
			
			// calculate inventory total
			for variant in product.1["variants"] {
				
				tempProduct.inventory = tempProduct.inventory + variant.1["inventory_quantity"].intValue
				
			}
			
			// add product to list of products
			newProductList.append(tempProduct)
			
		}
		
		products = newProductList
		
	}
	
	/*
		Description: This method extracts the information about a collection and appends this collection
		to the list of collections
	*/
	private func extractCollectionDetails(json: JSON) {
		
		for collection in json["custom_collections"] {
			
			let tempCollection = Collection()
			
			tempCollection.id = collection.1["id"].intValue
			tempCollection.title = collection.1["title"].stringValue.replacingOccurrences(of: " collection", with: "")
			tempCollection.body = collection.1["body_html"].stringValue
			tempCollection.image["url"] = collection.1["image"]["src"].stringValue
			tempCollection.image["name"] = tempCollection.title
			
			collections.append(tempCollection)
			
		}
		
	}
	
	/*
		Description: This method extracts all the product IDs associated with a specific collection
	*/
	private func extractCollectionProductIDs(json: JSON, collectionID: Int) {
		
		// check if the index of the requested collection exists
		if collections.contains(where: { $0.id == collectionID }) {
			
			// get the index of the requested collection
			guard let collectionIndex: Int = collections.firstIndex(where: { $0.id == collectionID }) else { return }
			
			var products: [Int] = []
			
			// get all product IDs
			for product in json["collects"] {
				
				let productID = product.1["product_id"].intValue
				
				// check if the collection already contains this product
				if !products.contains(productID) {
					
					products.append(productID)
					
				}
			}
			
			collections[collectionIndex].products = products
			
		}
		
	}
	
	/*
		Description: This method extracts the collection ID from a url
	*/
	private func extractCollectionIDFromURL(url: String) -> Int? {
		
		if url.contains("collection_id=") {
			
			let firstSplit = url.components(separatedBy: "=")
			if firstSplit.count > 1 {
				
				let secondSplit = firstSplit[1].components(separatedBy: "&")
				if secondSplit.count > 0 {
					
					return Int(secondSplit[0])

				}
			}
		}
		
		return nil
		
	}
	
	/*
		Description: This method constructs the url to request the product list for a specific collection
	*/
	func getCollectionURL(collectionID: Int) -> String {
		
		return "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collectionID)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
		
	}
	
	/*
		Description: This method constructs the url to request the products information for a list
		of products
	*/
	func getProductsURL() -> String? {
		
		guard let collectionID = selectedCollectionID else { return nil }
		
		// get the index of the requested collection
		guard let collectionIndex: Int = collections.firstIndex(where: { $0.id == collectionID }) else { return nil }
		
		// the product IDs added together and separated by a comma
		var idStringList: String = ""
		
		for (index, product) in self.collections[collectionIndex].products.enumerated() {
			
			idStringList += "\(product)"
			
			// add comma if not the last id in list of ids
			if index != self.collections[collectionIndex].products.endIndex-1 {
				idStringList += ","
			}
			
		}
		
		return "https://shopicruit.myshopify.com/admin/products.json?ids=\(idStringList)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
		
	}
	
}
