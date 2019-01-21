//
//  CollectionsViewController.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CollectionsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UpdateViewProtocol {
	
	private let data = APIDataRequest()

	private let cellIdentifier = "collectionCell"
	private let sectionInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	private let collectionsPerRow: Int = 2
	
	private var selectedCollectionIndex: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set the appropriate titles for the view
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Collections"
		self.title = "Collections"
		
		data.viewDelegate = self
		
		// show the loading circle
		SVProgressHUD.show()
		
		// get data to fill collections with
		data.requestData(url: APIDataRequest.collectionsURL)
		
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return data.collections.count
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		// determine the sizing and how each collection should fit in the grid
		let paddingSpace = sectionInsets.left * CGFloat(collectionsPerRow * 2)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / CGFloat(collectionsPerRow)
		let heightPerItem = CGFloat(180.0)

		return CGSize(width: widthPerItem, height: heightPerItem)

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		return sectionInsets

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

		return sectionInsets.left * 2

	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
		
		// set the cell properties in order to give it the rounded corners with a shadow shape
		cell.backgroundColor = .white
		cell.layer.borderColor = UIColor.lightGray.cgColor
		cell.layer.borderWidth = 0.5
		cell.layer.cornerRadius = 20.0
		cell.layer.masksToBounds = true
		cell.layer.shadowColor = UIColor.black.cgColor
		cell.layer.shadowOffset = CGSize(width: 0, height: 2)
		cell.layer.shadowRadius = 20.0
		cell.layer.shadowOpacity = 0.1
		cell.layer.masksToBounds = false
		cell.layer.shadowPath = UIBezierPath(roundedRect: cell.layer.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
		
		if indexPath.item < data.collections.count {
				
			// set the cell label
			cell.cellLabel.text = data.collections[indexPath.item].title
			
			// load the collection image
			if let image = LoadImage.load(imageName: data.collections[indexPath.item].title, imageSrc: data.collections[indexPath.item].image["url"] as! String) {
				
				cell.cellImage.image = image
				
			}
		}		
		
		return cell
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// save the index of the selected collection
		self.selectedCollectionIndex = indexPath.item
		
		performSegue(withIdentifier: "goToProductsPage", sender: self)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "goToProductsPage" {
			
			let destinationVC: ProductsViewController = segue.destination as! ProductsViewController
			destinationVC.data = self.data
			destinationVC.selectedCollectionIndex = self.selectedCollectionIndex
			
		}
		
	}
	
	/*
		Description: This method is called once all the product information has been obtained
		and reloads the tableview with the new data.
	*/
	func updateView() {
		
		self.collectionView.reloadData()
		SVProgressHUD.dismiss()
		
	}
	
}
