//
//  LoadImage.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-11.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit

class LoadImage {
	
	/*
		Description: This method loads an image either from an url or from storage.
	*/
	static func load(imageName: String, imageSrc: String) -> UIImage? {
		
		let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
		let imageUrl: URL = URL(fileURLWithPath: imagePath)
		
		// check if the image has already been used before therefore it should be saved
		if FileManager.default.fileExists(atPath: imagePath) {
			
			if let imageData = try? Data(contentsOf: imageUrl) {
				
				// return the image loaded from storage
				if let image = UIImage(data: imageData, scale: UIScreen.main.scale) { return image }
				
			}
			
		}
		
		// load the image from its url
		if let imageData = try? Data(contentsOf: URL(string: imageSrc)!) {
			
			if let newImage = UIImage(data: imageData) {
				
				// save the image to the document directory
				try? newImage.pngData()?.write(to: imageUrl)
				
				return newImage
				
			}
			
		}
		
		return nil
		
	}
	
}
