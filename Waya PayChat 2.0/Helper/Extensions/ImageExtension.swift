//
//  ImageExtension.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/15/21.
//



extension UIImage{
    

    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero, 
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
    func scaleImageLength(width: CGFloat) -> UIImage {
        // Determine the scale factor that preserves aspect ratio

        let scaledFactor = size.width / size.height
        
        
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: width,
            height: width / scaledFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero, 
                size: scaledImageSize
            ))
        }
        
        
        
        return scaledImage
    }
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func loadImageData(urlString: String, _ completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: urlString) else { 
            completion(nil)
            return  
            
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let data = data else { 
                completion(nil)
                return
                
            }
            DispatchQueue.main.async {
                print("The uiImage completed \(UIImage(data: data)?.pngData())")
                 completion(UIImage(data: data))
            }
        }
        task.resume()
    }
}

extension UIImageView{
    
    func circularImage(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func loadImage(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

class ImageLoader {
    
    static func loadImageData(urlString: String, _ completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: urlString) else { 
            completion(nil)
            return  
            
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { 
                completion(nil)
                return
                
            }
            DispatchQueue.main.async {
                print("The uiImage completed \(UIImage(data: data)?.pngData())")
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
    
}
