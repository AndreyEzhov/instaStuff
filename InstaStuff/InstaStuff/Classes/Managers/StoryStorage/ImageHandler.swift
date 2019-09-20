//
//  ImageHandler.swift
//  InstaStuff
//
//  Created by aezhov on 14/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class ImageHandler {
    
    // MARK: - Properties
    
    private let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    // MARK: - Functions
    
    func saveImage(_ image: UIImage, name fileName: String) {
        guard let documentsURL = documentsURL else { return }
        do {
            let fileURL = documentsURL.appendingPathComponent("\(fileName).png")
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            
        }
    }
    
    func loadImage(named fileName: String?) -> UIImage? {
        guard let documentsURL = documentsURL, let fileName = fileName else { return nil }
        let filePath = documentsURL.appendingPathComponent("\(fileName).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return UIImage(named: fileName)
    }
    
    func deleteImage(named fileName: String?) {
        guard let documentsURL = documentsURL, let fileName = fileName else { return }
        let filePath = documentsURL.appendingPathComponent("\(fileName).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    private func removeImage(named fileName: String) {
        guard let documentsURL = documentsURL else { return }
        let filePath = documentsURL.appendingPathComponent("\(fileName).png").path
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    private func removeAllImages() {
        guard let documentsURL = documentsURL else { return }
        try? FileManager.default.contentsOfDirectory(atPath: documentsURL.path).forEach {
            removeImage(named: $0)
        }
    }
    
}
