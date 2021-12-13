//
//  MenuViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
   
        // Do any additional setup after loading the view.
    }
    
    private func createTheView() {
        
        let xCoord = self.view.bounds.width / 2 - 50
        let yCoord = self.view.bounds.height / 2 - 50
        
        let centeredView = UIView(frame: CGRect(x: xCoord, y: yCoord, width: 100, height: 100))
        centeredView.backgroundColor = .blue
        self.view.addSubview(centeredView)
    }

}
