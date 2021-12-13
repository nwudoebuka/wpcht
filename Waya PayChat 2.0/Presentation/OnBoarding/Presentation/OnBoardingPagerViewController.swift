//
//  OnBoardingPagerViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/3/21.
//

protocol OnBoardingPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class OnBoardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pageControl : UIPageControl!
    weak var onBoardingDelegate: OnBoardingPageViewControllerDelegate?
    
    var walkContent = [
        Walk(id: 1, title: "Connect", desc: "Connect with friends, clients and \n customers", image: "walk1"),
        Walk(id: 2, title: "Discover", desc: "Discover, rate and review some of the \n best vendors in your city", image: "walk2"),
        Walk(id: 3, title: "Transact", desc: "Manage and monitor all your \n transaction from one location", image: "walk3")
    ]
    var pageImages = ["walk1", "walk2", "walk3"]
    var currentIndex = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnBoardingContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnBoardingContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
    
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    

    
    func contentViewController(at index: Int) -> OnBoardingContentViewController?{
        if(index < 0 || index >= walkContent.count){
            return nil
        }
        
        let storyBoard = UIStoryboard(name: "OnBoarding", bundle: nil)
        if let pageContentViewController = storyBoard.instantiateViewController(withIdentifier: "OnBoardingContentViewController") as? OnBoardingContentViewController{
            
            pageContentViewController.logo = UIImage(named: walkContent[index].image) ?? UIImage()
            pageContentViewController.heading = walkContent[index].title
            pageContentViewController.subHeading = walkContent[index].desc
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    
    func forwardPage(){
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if let  contentViewController = pageViewController.viewControllers?.first as? OnBoardingContentViewController{
                currentIndex = contentViewController.index
                onBoardingDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}

