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
	
	// table view header properties
	@IBOutlet weak var headerCellImage: UIImageView!
	@IBOutlet weak var headerCellTitle: UILabel!
	@IBOutlet weak var headerCellDescription: UILabel!
	@IBOutlet weak var headerCellView: UIView!
	
	var data: APIDataRequest = APIDataRequest()
	var selectedCollectionIndex: Int?
	
	private let cellIdentifier: String = "productCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set titles
		navigationItem.title = "Products"
		navigationController?.navigationBar.prefersLargeTitles = true
		self.title = "Products"
		
		// set delegates
		data.viewDelegate = self
		tableView.delegate = self
		tableView.dataSource = self
		
		// update the table view header information
		updateHeader()
		
		// request the collection product list
		if selectedCollectionIndex != nil {
			
			let id = data.collections[selectedCollectionIndex!].id
			data.requestData(url: data.getCollectionURL(collectionID: id))
			
		}
		
		SVProgressHUD.show()
		
	}
	
	/*
		Description: This method resized the collection details card in order to fit the
		entire description
	*/
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		guard let headerView = tableView.tableHeaderView else {
			return
		}
		
		let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		
		// check if the card is the right size
		if headerView.frame.size.height != size.height {
			
			headerView.frame.size.height = size.height
			tableView.tableHeaderView = headerView
			tableView.layoutIfNeeded()
			
		}
	}
	
	/*
		Description: This method updates the collection details card with the right
		information about the collection.
	*/
	func updateHeader() {
		
		guard let index = selectedCollectionIndex else {
			return
		}
		
		// get the properties
		let collectionTitle = data.collections[index].title
		let collectionImg = data.collections[index].image["url"]
		let collectionDescription = data.collections[index].body
		
		// set the properties
		headerCellTitle.text = collectionTitle
		headerCellTitle.font = UIFont.boldSystemFont(ofSize: 25.0)
		headerCellDescription.font = UIFont.systemFont(ofSize: 14)
		headerCellDescription.text = "\"\(collectionDescription)\""
		if collectionDescription.count == 0 {
			
			headerCellDescription.text = "*description unavailable*"
			
		}
		
		headerCellView.layer.borderWidth = 0.25
		
		// load and change the shape of the image to a circle
		if let image = LoadImage.load(imageName: collectionTitle, imageSrc: collectionImg as! String) {
		
			headerCellImage.image = image
			headerCellImage.layer.borderWidth = 0.5
			headerCellImage.layer.borderWidth = 1
			headerCellImage.layer.masksToBounds = false
			headerCellImage.layer.borderColor = UIColor.black.cgColor
			headerCellImage.layer.cornerRadius = headerCellImage.frame.height/2
			headerCellImage.clipsToBounds = true
		
		}
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return data.products.count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductViewCell
		
		// set the product information
		cell.cellProductName.text = data.products[indexPath.row].title
		cell.cellProductInventory.text = "x\(data.products[indexPath.row].inventory)"
		
		// load the image for the product
		if let image = LoadImage.load(imageName: cell.cellProductName.text!, imageSrc: data.products[indexPath.row].image["url"] as! String) {
			
			cell.cellProductImage.image = image
			cell.cellProductImage.layer.borderWidth = 0.5
			
		}
		
		// get the collection information
		let collectionTitle = data.collections[selectedCollectionIndex!].title
		let collectionImg = data.collections[selectedCollectionIndex!].image["url"]
		
		cell.cellCollectionName.text = collectionTitle
		
		// load the collection image and change its shape to a circle
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
	
	/*
		Description: This method is called once all the product information has been obtained
		and reloads the tableview with the new data.
	*/
	func updateView() {
		
		self.tableView.reloadData()
		SVProgressHUD.dismiss()
		
	}
	
	/*
		Description: This method is called once a list of all the products in a collection
		has been obtained in order to now request all the extra information on the products.
	*/
	func productListUpdated() {
		
		if let url = data.getProductsURL() {
			
			data.requestData(url: url)
			
		}
		
		
	}
	
}
