//
//  PostDetailViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/1/21.
//

protocol PostDetailView : BaseView {
    var navBack : (() -> Void)? { get set }
}

class PostDetailViewController: UIViewController, PostDetailView, UITextFieldDelegate {
    
    var navBack: (() -> Void)?

    var postViewCell = PostCollectionViewCell()
    var wayagramViewModel: WayagramViewModelImpl!
    
    var textCommentView : TextCommentView!
    
    var comments = [CommentResponse]()
    
    init(wayagramViewModel: WayagramViewModelImpl){
        self.wayagramViewModel = wayagramViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    private let commentTableView : UITableView = {
        let table = UITableView()
        table.register(PostCommentViewCell.self, forCellReuseIdentifier: PostCommentViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.backgroundColor = .red
        return table
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpTableView()
        fetchComments()
        //hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShownBottomView(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setUpTableView(){
        commentTableView.dataSource = self
        commentTableView.delegate = self
        view.addSubview(commentTableView)
        commentTableView.backgroundColor = .white
        commentTableView.separatorStyle = .none
        commentTableView.separatorColor = .clear
        commentTableView.rowHeight = UITableView.automaticDimension
        
        textCommentView = TextCommentView()
        
        view.addSubview(textCommentView)
        textCommentView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
        commentTableView.anchor(top: postViewCell.bottomAnchor, leading: view.leadingAnchor, bottom: textCommentView.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17))
        commentTableView.sectionIndexColor = .white
        textCommentView.sendButton.addTarget(self, action: #selector(didTapCreateComment), for: .touchUpInside)

        textCommentView.commentTextField.delegate = self
        textCommentView.commentTextField.returnKeyType = .done
    }
    
    private func setUpViews(){
        title = "Posts"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        
        postViewCell.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postViewCell)
        
        //For dynamic post length 
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 14)]
        let size = CGSize(width: view.frame.width - 34, height: 1000)
        
        let estimatedFrame = NSString(string:  wayagramViewModel.selectedPost.post!.postDescription ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        var otherHeight  : CGFloat = 158
        if  wayagramViewModel.selectedPost.post!.hasImage{
            otherHeight = 328
        }
        let postHeight = otherHeight + estimatedFrame.height
        postViewCell.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 21, left: 17, bottom: 0, right: 17))
        postViewCell.heightAnchor.constraint(equalToConstant: postHeight).isActive = true
        
        postViewCell.configureWithPost(post: wayagramViewModel.selectedPost.post!)
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        
        textCommentView.commentTextField.resignFirstResponder()
        return true
    }
    
    private func fetchComments(){
        print("the id is \(wayagramViewModel.selectedPost.post!.id!)")
        wayagramViewModel.getPostComment(postId: wayagramViewModel.selectedPost.post!.id!) {[weak self] (result) in
            switch result{
                case .success(let response):
                    if let response = response as? [CommentResponse] {
                        self?.comments = response
                        self?.commentTableView.reloadData()
                    }
                case .failure(.custom(let message)):
                    print("The message \(message)")
            }
        }
    }
    
    @objc  func didTapCreateComment(){
        if  textCommentView.commentTextField.text != nil && textCommentView.commentTextField.text != ""{
            createComment()
            textCommentView.commentTextField.text = ""
            view.endEditing(true)
        }
    }
    
    private func createComment(){
        let commentRequest = CreateCommentRequest(post_id: wayagramViewModel.selectedPost.post!.id!, profile_id: wayagramViewModel.selectedPost.profileId, parent_id: nil, comment: textCommentView.commentTextField.text!, type: "user")
        wayagramViewModel.createComment(createCommentRequest: commentRequest) { [weak self](result) in
            switch result{
                case .success(let response):
                    print("The response \(String(describing: response))")
                case .failure(.custom(let message)):
                    print("The message \(message)")
            }
        }
        
    }

}

extension PostDetailViewController  : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  commentTableView.dequeueReusableCell(withIdentifier: PostCommentViewCell.identifier) as! PostCommentViewCell
        cell.selectionStyle = .none
        cell.configureWithCommentResponse(commentResp : comments[indexPath.row])
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = CGSize(width: view.frame.width - 34, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16)]
        let comment = comments[indexPath.row].comment
        let estimatedFrame = NSString(string: comment).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        let height = estimatedFrame.height + 130
        return height
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
}

