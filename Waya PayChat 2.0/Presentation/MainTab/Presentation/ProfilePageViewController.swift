//
//  ProfilePageViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/19/21.
//

protocol ProfilePagerDelegate: class {
    
    func didUpdatePageIndex(currentIndex: Int)
}

class ProfilePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    weak var pagerDelegate: ProfilePagerDelegate?
    let storyBoard = UIStoryboard(name: "DashBoard", bundle: nil)

    var currentIndex = 0
    var identifiers: NSArray = ["TimeLineViewController", "FollowersViewController",
                                "GroupViewController", "UserPagesViewController"]
    
    var wayagramViewModel: WayagramViewModelImpl!
    
    init(wayagramViewModel: WayagramViewModelImpl) {
        self.wayagramViewModel = wayagramViewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let identifier = viewController.restorationIdentifier else {
            print("indenitifer before is is nil")
            return nil
        }
        
        var index = self.identifiers.index(of: identifier)
        
        index -= 1        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("The vc \(String(describing: viewController.restorationIdentifier))")
        guard let identifier = viewController.restorationIdentifier else {
            print("indenitifer after is is nil")
            
            return nil
        }
        
        var index = self.identifiers.index(of: identifier)
        
        print("index after is \(identifier)")
        
        print("index after is \(index)")
        index += 1
        
        print("default after  index \(index)")
        return contentViewController(at: index)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0){
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    func contentViewController(at index: Int) -> UIViewController?{
        if(index < 0 || index >= 4){
            return nil
        }
        
        switch index {
            case 0:
                return presentTimeLine()
            case 1:
                return presentFollowers()
            case 2:
                return presentGroups()
            case 3:
                return presentPages()
            default:
                return presentTimeLine()

        }
            
    }
    
    func presentFollowers() -> UIViewController?{
        if let vc = storyBoard.instantiateViewController(withIdentifier: "FollowersViewController") as? FollowersViewController{
            vc.viewType = FollowerViewType.follower        
            return vc
        }
        return nil
    }
    
    func presentPages() -> UIViewController?{
        if let vc = storyBoard.instantiateViewController(withIdentifier: "UserPagesViewController") as? UserPagesViewController{
            
            return vc
        }
        return nil
    }
    
    func presentGroups() -> UIViewController?{
        if let vc = storyBoard.instantiateViewController(withIdentifier: "GroupViewController") as? GroupViewController{
            
            return vc
        }
        return nil
    }
    
    func presentTimeLine() -> UIViewController?{
        if let vc = storyBoard.instantiateViewController(withIdentifier: "TimeLineViewController") as? TimeLineViewController{
            vc.wayagramViewModel = wayagramViewModel
            return vc
        }
        return nil
    }
    
    func forwardPage(){
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }
    func setCurrentController(index: Int){
        if index > -1 && index < identifiers.count{
            if let startingViewController = contentViewController(at: index){
                setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            
            if let  contentViewController = pageViewController.viewControllers?.first{
                
                guard let identifier = contentViewController.restorationIdentifier else {
                    return 
                }
                print("The index after did finish animated identifier \(identifier)")
                currentIndex = self.identifiers.index(of: identifier)
                print("The current index at the did finish \(currentIndex)")
                pagerDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
                
            }
        }
    }
}

