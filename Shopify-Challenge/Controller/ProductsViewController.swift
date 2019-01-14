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
	
	var data: APIDataRequest = APIDataRequest()
	var selectedCollectionIndex: Int?
	
	private let cellIdentifier: String = "productCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Products"
		navigationController?.navigationBar.prefersLargeTitles = true
		self.title = "Products"
		
		data.viewDelegate = self
		tableView.delegate = self
		tableView.dataSource = self
		
		// request the collection product list
		if selectedCollectionIndex != nil {
			
			let id = data.collections[selectedCollectionIndex!].id
			data.requestData(url: data.getCollectionURL(collectionID: id))
			
			print(data.products)
		}
		
		SVProgressHUD.show()
		
		// filter button
		let filterButton = UIBarButtonItem(title: "Filter", style: .done, target: self, action: nil)
		navigationItem.rightBarButtonItem = filterButton
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		print("THERE ARE: \(data.products.count) PRODUCTS")
		return data.products.count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductViewCell
		cell.cellProductName.text = data.products[indexPath.row].title
		cell.cellProductInventory.text = "x\(data.products[indexPath.row].inventory)"
		
		if let image = LoadImage.load(imageName: cell.cellProductName.text!, imageSrc: data.products[indexPath.row].image["url"] as! String) {
			
			cell.cellProductImage.image = image
			cell.cellProductImage.layer.borderWidth = 0.5
			
		}
		
		let collectionTitle = data.collections[selectedCollectionIndex!].title
		let collectionImg = data.collections[selectedCollectionIndex!].image["url"]
		
		cell.cellCollectionName.text = collectionTitle
		
		if let image = LoadImage.load(imageName: collectionTitle, imageSrc: collectionImg as! String) {
			
			cell.cellCollectionImage.image = image
			cell.cellCollectionImage.layer.borderWidth = 1
			cell.cellCollectionImage.layer.masksToBounds = false
			cell.cellCollectionImage.layer.borderColor = UIColor.black.cgColor
			cell.cellCollectionImage.layer.cornerRadius = cell.cellCollectionImage.frame.height/2
			cell.cellCollectionImage.clipsToBounds = true
			
		}
		
		return cell
		
	}
	
	func updateView() {
		
		print("\(data.products)")
		self.tableView.reloadData()
		SVProgressHUD.dismiss()
		
	}
	
	func productListUpdated() {
		
		if let url = data.getProductsURL() {
			
			data.requestData(url: url)
			
		}
		
		
	}
	
}
