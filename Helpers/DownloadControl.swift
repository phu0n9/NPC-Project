/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
    Nguyen Huynh Anh Phuong - s3695662
    Le Nguyen - s3777242
    Han Sangyeob - s3821179
    Nguyen Anh Minh - s3911237
  Created  date: 29/08/2022
  Last modified: 18/09/2022
  Acknowledgments: StackOverflow, Youtube, and Mr. Tom Huynh’s slides
*/

import Foundation
import AVKit

class DownloadControl: ObservableObject {
    @Published var isDownloading = false
    @Published var isDownloaded = false
    @Published var downloads = [Downloads]()
    
    // MARK: download file by url to file manager
    func downloadFile(urlString: String, fileLocalName: String) {
        isDownloading = true
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("episodes")
        let destinationUrl = docsUrl?.appendingPathComponent("episodes/"+fileLocalName)
        
        guard FileManager.default.fileExists(atPath: dataPath.path) else {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
            return
        }
        
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("File already exists")
                isDownloading = false
            } else {
                
                let urlRequest = URLRequest(url: URL(string: urlString)!)
                
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    
                    if let error = error {
                        print("Request error: ", error)
                        self.isDownloading = false
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else { return }
                    
                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading = false
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    self.isDownloading = false
                                    self.isDownloaded = true
                                }
                                
                            } catch let error {
                                print("Error decoding: ", error)
                                self.isDownloading = false
                            }
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    // MARK: delete file in local file manager
    func deleteFile(fileLocalName: String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent(fileLocalName)
        if let destinationUrl = destinationUrl {
            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("File deleted successfully")
                isDownloaded = false
            } catch let error {
                print("Error while deleting video file: ", error)
            }
        }
    }
    
    // MARK: check file exists in local file manager
    func checkFileExists(fileLocalName: String) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent("\(fileLocalName)")
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                isDownloaded = true
            } else {
                isDownloaded = false
            }
        } else {
            isDownloaded = false
        }
    }
    
    // MARK: get episode in local file manager
    func getVideoFileAsset(fileLocalName: String) -> AVPlayerItem? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent(fileLocalName)
        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                let avAssest = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAssest)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // MARK: load image
    func loadImage(fileName: String) -> UIImage? {
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsUrl.appendingPathComponent(fileName)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Not able to load image")
            }
        }
        return nil
    }
    
    // MARK: extract name url to local
    func getLocalFileName(fileName: String) -> String {
        var fileTitle = ""
        if let dotIndex = fileName.lastIndex(of: "."), let fileIndex = fileName.lastIndex(of: "/") {
            //            let pathExtension = String(fileName[index...])
            fileTitle = String(fileName[fileIndex..<dotIndex])
            fileTitle.remove(at: fileTitle.startIndex)
            return fileTitle + ".mp3"
        }
        
        return ""
    }
    
    // MARK: extract absolute path
    func getDirectoryPath(fileName: String) -> String {
        if let fileIndex = fileName.lastIndex(of: "/") {
            return String(fileName[fileName.startIndex..<fileIndex])
        }
        return ""
    }
    
    // MARK: fetch all downloads
    func fetchAllDownloads() {
        do {
            self.downloads.removeAll()
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = paths[0]
            let docURL = URL(string: documentsDirectory)!
            
            let dataPath = docURL.appendingPathComponent("episodes")
            guard FileManager.default.fileExists(atPath: dataPath.path) else {
                do {
                    try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
                    return
                } catch {
                    print(error.localizedDescription)
                }
                return
            }
            
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let path = documentURL.appendingPathComponent("episodes").absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
            for file in directoryContents where !file.relativePath.contains("DS_Store") {
                let currentItem = self.getLocalFileName(fileName: file.relativePath)
                //                let directoryPath = self.getDirectoryPath(fileName: file.relativePath)
                let download = Downloads(audio: file.relativePath, title: currentItem, isProcessing: false)
                self.downloads.append(download)
            }
                        
        } catch {
            print(error.localizedDescription)
        }
    }
}
