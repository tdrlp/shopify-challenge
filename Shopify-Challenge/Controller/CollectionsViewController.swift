//
//  CollectionsViewController.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-10.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit
import SwiftyJSON

class CollectionsViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UpdateViewProtocol {
	
	private let data = APIDataRequest()
	private var dataDictionary: Dictionary = [String : JSON]()

	private let cellIdentifier = "collectionCell"
	
	private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0,
											 bottom: 50.0, right: 20.0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Collections"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		data.viewDelegate = self
		
		// get data to fill collections with
		data.requestData(url: data.collectionsURL)
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
		
		let paddingSpace = sectionInsets.left * (4)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / 3
		
		return CGSize(width: widthPerItem, height: widthPerItem)
		
	}
	
	// spacing all around
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		
		return sectionInsets
		
	}
	
	// spacing between lines in layout
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		
		return sectionInsets.left
		
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
		cell.backgroundColor = .white
		
		if indexPath.item < dataDictionary.count {
			
			if let text = dataDictionary["\(data.collectionIDs[indexPath.item])"] {
				
				let title: String = "\(text["title"])"
				
				// set the cell label
				cell.cellLabel.text = title.replacingOccurrences(of: " collection", with: "")
				
				// set the cell image
				if let url = URL(string: "\(text["image"]["src"])") {
					
					let urlData = try? Data(contentsOf: url)
					
					if let imgData = urlData {
						
						cell.cellImage.image = UIImage(data: imgData)
						
					}
				}
			}
		}
		
		
		return cell
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		let activityIndicator = UIActivityIndicatorView(style: .gray)
		textField.addSubview(activityIndicator)
		activityIndicator.frame = textField.bounds
		activityIndicator.startAnimating()
		
		textField.text = nil
		textField.resignFirstResponder()
		
		return true
		
	}
	
	func updateView(dictionary: [String : JSON]) {
		
		self.dataDictionary = dictionary
		self.collectionView.reloadData()
		
	}
	
}
