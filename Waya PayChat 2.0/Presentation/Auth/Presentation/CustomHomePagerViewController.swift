//
//  CustomHomePagerViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/5/21.
//

protocol CustomHomePagerViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class CustomHomePagerViewController:UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var pageControl : UIPageControl!
    weak var onBoardingDelegate: CustomHomePagerViewControllerDelegate?
    
    var walkContent = [
        Walk(id: 1, title: "Wayapay", desc: "Free Internet  Banking & Bills Payment", image: "mob1"),
        Walk(id: 2, title: "Wayachat", desc: "Chat and call clients, friends and family", image: "mob2"),
        Walk(id: 3, title: "Wayagram", desc: "Discover beautiful places, people, \n conversarions, vendors and clients", image: "mob3")
    ]
    var currentIndex = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CustomHomeContentViewController).index
        index -= 1
        print("e dey choke")
        return contentViewController(at: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! CustomHomeContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func contentViewController(at index: Int) -> CustomHomeContentViewController?{
        if(index < 0 || index >= walkContent.count){
            return nil
        }
        
        let storyBoard = UIStoryboard(name: "Auth", bundle: nil)
        if let customContent = storyBoard.instantiateViewController(withIdentifier: "CustomHomeContentViewController") as? CustomHomeContentViewController{
            
            customContent.logo = UIImage(named: walkContent[index].image) ?? UIImage()
            customContent.heading = walkContent[index].title
            customContent.subHeading = walkContent[index].desc
            customContent.index = index
            
            return customContent
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
            if let  contentViewController = pageViewController.viewControllers?.first as? CustomHomeContentViewController{
                currentIndex = contentViewController.index
                onBoardingDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}

