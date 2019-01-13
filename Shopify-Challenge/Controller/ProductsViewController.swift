//
//  ProductsViewController.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-12.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProductsViewController: UITableViewController, UpdateViewProtocol {
	
	var collectionTitle: String?
	var collectionImage: String?
	var collectionID: Int?
	
	private let cellIdentifier: String = "productCell"
	
	private let data = APIDataRequest()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Details"
		navigationController?.navigationBar.prefersLargeTitles = true
		self.title = "Details"
		
		data.viewDelegate = self
		tableView.delegate = self
		tableView.dataSource = self
		
		// request the collection product list
		if let id = collectionID {
			
			data.requestData(url: data.getCollectionURL(collectionID: id))
			
		}
		
		SVProgressHUD.show()
		
		print("title: \(collectionTitle!)")
		print("id: \(collectionID!)")
		print("img: \(collectionImage!)")
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return data.productIDs.count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductViewCell
		cell.cellProductName.text = String(data.productIDs[indexPath.row])
		
		guard let title = collectionTitle else { return cell }
		guard let image = collectionImage else { return cell }
		
		cell.cellCollectionName.text = title
		cell.cellProductInventory.text = "x100"
		
		if let image = LoadImage.load(imageName: title, imageSrc: image) {
			
			cell.cellImage.image = image
			
		}
		
		return cell
		
	}
	
	func updateView() {
		
		print("\(data.productIDs)")
		self.tableView.reloadData()
		SVProgressHUD.dismiss()
		
	}
	
	func productListUpdated() {
		
		data.requestData(url: data.getProductsURL())
		
	}
	
}
