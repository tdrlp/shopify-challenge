//
//  LoadImage.swift
//  Shopify-Challenge
//
//  Created by Tudor Lupu on 2019-01-11.
//  Copyright © 2019 Tudor Lupu. All rights reserved.
//

import UIKit

class LoadImage {
	
	static func load(imageName: String, imageSrc: String) -> UIImage? {
		
		let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
		let imageUrl: URL = URL(fileURLWithPath: imagePath)
		
		if FileManager.default.fileExists(atPath: imagePath) {
			
			if let imageData = try? Data(contentsOf: imageUrl) {
				
				if let image = UIImage(data: imageData, scale: UIScreen.main.scale) { return image }
				
			}
			
		}
		
		if let imageData = try? Data(contentsOf: URL(string: imageSrc)!) {
			
			if let newImage = UIImage(data: imageData) {
				
				try? newImage.pngData()?.write(to: imageUrl)
				return newImage
				
			}
			
		}
		
		return nil
		
	}
	
}
