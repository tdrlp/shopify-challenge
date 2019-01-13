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
	
	private var selectedCellTitle: String?
	private var selectedCellImage: String?
	private var selectedCellCollectionID: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Collections"
		self.title = "Collections"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		data.viewDelegate = self
		
		SVProgressHUD.show()
		
		// get data to fill collections with
		data.requestData(url: data.collectionsURL)
		
		// search button
		let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
		navigationItem.rightBarButtonItem = searchButton
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		print(data.collectionIDs.count)
		return data.collectionIDs.count
		
	}
	
	// return size of each square including padding
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let paddingSpace = sectionInsets.left * CGFloat(collectionsPerRow * 2)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / CGFloat(collectionsPerRow)
		let heightPerItem = view.frame.height / CGFloat(collectionsPerRow + (collectionsPerRow - 1))

		return CGSize(width: widthPerItem, height: heightPerItem)

	}
	
	// spacing all around
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		return sectionInsets

	}
	
	// spacing between lines in layout
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

		return sectionInsets.left * 2

	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
		cell.backgroundColor = .white
		cell.layer.borderColor = UIColor.lightGray.cgColor
		cell.layer.borderWidth = 0.5
		cell.layer.cornerRadius = 20.0
		cell.layer.masksToBounds = true
		cell.layer.shadowColor = UIColor.black.cgColor
		cell.layer.shadowOffset = CGSize(width: 0, height: 2)
		cell.layer.shadowRadius = 20.0
		cell.layer.shadowOpacity = 0.2
		cell.layer.masksToBounds = false
		cell.layer.shadowPath = UIBezierPath(roundedRect: cell.layer.bounds, cornerRadius: cell.layer.cornerRadius).cgPath
		
		if indexPath.item < data.collectionIDs.count {
				
			// set the cell label
			cell.cellLabel.text = data.collectionTitles[indexPath.item]
			
			if let image = LoadImage.load(imageName: data.collectionTitles[indexPath.item], imageSrc: data.collectionImages[indexPath.item]) {
				
				cell.cellImage.image = image
				
			}
		}		
		
		return cell
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		self.selectedCellTitle = data.collectionTitles[indexPath.item]
		self.selectedCellImage = data.collectionImages[indexPath.item]
		self.selectedCellCollectionID = data.collectionIDs[indexPath.item]
		
		performSegue(withIdentifier: "goToProductsPage", sender: self)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "goToProductsPage" {
			
			let destinationVC: ProductsViewController = segue.destination as! ProductsViewController
			destinationVC.collectionTitle = self.selectedCellTitle
			destinationVC.collectionImage = self.selectedCellImage
			destinationVC.collectionID = self.selectedCellCollectionID
			
		}
		
	}
	
	func updateView() {
		
		self.collectionView.reloadData()
		SVProgressHUD.dismiss()
		
	}
	
}
