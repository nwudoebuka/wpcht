//
//  PostImageView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/17/21.
//

import UIKit

class PostImageView: UIView {

    private var images  : [UIImage] = []
    private let maxWidth = UIScreen.main.bounds.width - 80    
    private var maxHeight  : CGFloat =  180
    
    init(newImages : [UIImage]){
        self.images = newImages
        if images.count > 2{
            maxHeight = 280
        }
        super.init(frame: CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight))
        updateViews()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func addImage(image: UIImage){
        if images.count <= 4{
            images.append(image)
        }
    }
    
    func addImages(newImages : [UIImage]){
        self.images =  newImages 
        updateViews()
    }
    
    func updateViews(){
        switch images.count {
            case 1:
                createViewForSingleImage()
            case 2:
                createViewForDoubleImage()
            default:
                break
        }
    }
    
    func createViewForSingleImage(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight))
        imageView.layer.cornerRadius = 12
        imageView.image = images[0]
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    func createViewForDoubleImage(){
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: maxWidth/2 - 2, height: maxHeight))
        imageView1.layer.cornerRadius = 12
        imageView1.image = images[0]
        imageView1.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imageView1.clipsToBounds = true
        
        let imageView2 = UIImageView(frame: CGRect(x: maxWidth/2 + 4, y: 0, width: maxWidth/2 - 2, height: maxHeight))
        imageView2.layer.cornerRadius = 12
        imageView2.image = images[1]
        imageView2.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        imageView2.clipsToBounds = true

        
        addSubview(imageView1)
        addSubview(imageView2)
    }
    
}
