//
//  CommentViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/1/21.
//

protocol CommentView : BaseView {
    var navBack : (() -> Void)? { get set }
}

class CommentViewController: UIViewController, CommentView {
    var navBack: (() -> Void)?
    
    private let commentTableView : UITableView = {
        let table = UITableView()
        table.register(CommentViewCell.self, forCellReuseIdentifier: CommentViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.backgroundColor = .red
        return table
    }()
    
    var commentHeaderView : CommentViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    init(wayagramViewModel : WayagramViewModelImpl){
        
        super.init(nibName: nil, bundle: nil)
    }    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }

    private func initViews(){
        commentHeaderView = CommentViewCell()
        commentHeaderView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0))
    }


}

extension CommentViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  commentTableView.dequeueReusableCell(withIdentifier: CommentViewCell.identifier) as! CommentViewCell
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGSize(width: view.frame.width - 34, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16)]
        
        let estimatedFrame = NSString(string: "we strongly believe that social networking apps \n are primarily about being easy-to-navigate and \n engaging").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        let height = estimatedFrame.height + 130
        return height
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
}


