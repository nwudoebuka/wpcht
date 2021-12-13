//
//  DiscoverViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

import UIKit

class DiscoverViewController: UIViewController, DiscoverView {
    var onNavToogle: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    

    func initView(){
        checkChangeNaviagtionStyle()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Discover"
        
        //temporarily added to launch only Wayapay to be removed af 
        showComingSoonView()
    }
    

}
