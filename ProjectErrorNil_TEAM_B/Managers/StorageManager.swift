//
//  FileManager.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 09.04.2024.
//

import Foundation

class StorageManager {
    
    private func fileManagerPath() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(imageName: String, imageData: Data) {
        var path = fileManagerPath()
        path.append(path: imageName)
        
        do {
            try imageData.write(to: path)
        } catch {
            print(error.localizedDescription)
        }
    }
            func loadImage(imageName: String) -> Data {
        var path = fileManagerPath()
        path.append(path: imageName)
        
        guard let imageData = try? Data (contentsOf: path) else { return Data()}
        return imageData
    }
    
}
