//
//  OnboardingController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

class OnboardingController: UIViewController, OnboardingView, OnBoardingPageViewControllerDelegate {
   
    
    var currentIndex_ = 0
    let onBoardingPageController: OnBoardingPageViewController = OnBoardingPageViewController()

    func didUpdatePageIndex(currentIndex: Int) {
        currentIndex_ = currentIndex
        updateUI()
    }
    
    var pageControl  = RectPageControl(numberOfPages: 3)

    var button : UIButton = {
        let button = UI.button(title: "Next")
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    var skipButton : UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(named: "color-gray1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.addTarget(self, action: #selector(didFinishOnBoarding), for: .touchUpInside)
        return button
    }()
    
    var pageControl2  : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.frame.size = CGSize(width: 300, height: 30)
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2); 
        pageControl.pageIndicatorTintColor = UIColor(named: "color-gray4")
        pageControl.currentPageIndicatorTintColor =  UIColor(named: "color-gray2")
        return pageControl
    }()
    
    
    
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardingPageController.onBoardingDelegate = self
        onBoardingPageController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onBoardingPageController.view)
        view.addSubview(pageControl.stack!)

        view.addSubview(button)
        onBoardingPageController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        onBoardingPageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        onBoardingPageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        onBoardingPageController.view.heightAnchor.constraint(equalToConstant: view.frame.height * 0.8).isActive = true
        
        pageControl.stack!.translatesAutoresizingMaskIntoConstraints = false
        pageControl.stack!.heightAnchor.constraint(equalToConstant: 4).isActive = true
        pageControl.stack!.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24).isActive = true
        pageControl.stack!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.stack!.widthAnchor.constraint(equalToConstant: 93).isActive = true
        pageControl.selectIndex(0) 
                
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true
        button.topAnchor.constraint(equalTo:  pageControl.stack!.bottomAnchor  ).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56).isActive = true
        
        view.addSubview(skipButton)
        skipButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        skipButton.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
  }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
    }
    
    @objc func didTapButton(_ sender: Any){
       onBoardingPageController.forwardPage()
        currentIndex_ += 1 
        updateUI()
        print("The current index \(currentIndex_)")
        if currentIndex_ == 3{
            didFinishOnBoarding()
        }
    }
    
    func updateUI(){
        switch currentIndex_ {
            case 0...1:
                button.setTitle("Next", for: .normal)
            case 2:
                button.setTitle("Finish", for: .normal)

            default:
                break
        }
        pageControl.selectIndex(currentIndex_) 
        onBoardingPageController.currentIndex = currentIndex_
        onBoardingPageController.onBoardingDelegate = self
        
    }
    
    @objc func didFinishOnBoarding(){
        auth.data.onboardingShown = true
        auth.updateLocalPrefs()
        onFinish?()
    }
    
}
