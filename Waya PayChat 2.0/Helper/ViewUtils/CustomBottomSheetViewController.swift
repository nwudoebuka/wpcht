//
//  CustomBottomSheetViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/5/21.
//

import UIKit

class CustomBottomSheetViewController<content: UIView>: UIViewController {
    
    var home: UIView!
    var contentView: content
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        contentView = content()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupCustomView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomView(){
        
        //contentView.roundCorners(UIRectCorner.topLeft.union(UIRectCorner.topRight), radius: 12)
        contentView.roundTopCorners(22)
        contentView.backgroundColor = .white
        view.addSubview(contentView)

        contentView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    func navToView(view: NavView) {
        view.onBack = { [weak self] in
            view.removeFromSuperview()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
