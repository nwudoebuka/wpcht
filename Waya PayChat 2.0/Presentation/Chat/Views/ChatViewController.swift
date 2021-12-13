//
//  ChatViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//


class ChatViewController: UIViewController, ChatView {

    var onNavToogle: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chat"
        checkChangeNaviagtionStyle()
        
        //temporarily added to launch only Wayapay to be removed af 
        showComingSoonView()
    }
      
}
