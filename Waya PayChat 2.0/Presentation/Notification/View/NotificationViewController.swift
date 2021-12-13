//
//  NotificationViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

import UIKit

class NotificationViewController: UIViewController, NotificationView, Alertable {
    
    var onNavToogle: (() -> Void)?
    
    var dashBoardDelegate : DashBoardCoordinator?
    let viewModel = NotificationViewModel()
    var notifications = [Notification]()
    
    lazy var table: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView(){
        title = "Notification"
        checkChangeNaviagtionStyle()
        table.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        table.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        table.reloadData()
        
        viewModel.notifications.subscribe(with: self) { (notifications, error) in
            if let notifications = notifications {
                self.notifications = notifications
                self.table.reloadData()
            }
            
            if let errorMsg = error {
                self.showAlert(message: errorMsg)
            }
        }
        viewModel.getAllNotifications()
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath)  as? NotificationCell else {
            return UITableViewCell()
        }
        let notification = self.notifications[indexPath.row]
        if let senderImage = notification.initiatorImage {
            ImageLoader.loadImageData(urlString: senderImage) { (image) in
                cell.profileImage.image = image
            }
        }
        cell.textDescription.text = notification.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}


class NotificationCell: UITableViewCell  {
    
    static let identifier = "notificationCell"
    
    lazy var profileImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 21
        return view
    }()
    
    lazy var textDescription: UILabel = {
        let text =  UI.text(string: "")
        text.numberOfLines = 0
        return text
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: NotificationCell.identifier)
        setupView()
    }
    
    func setupView() {
        let coverView = UIView()
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(coverView)
        coverView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        coverView.addSubviews([profileImage, textDescription])
        
        NSLayoutConstraint.activate([
            profileImage.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            profileImage.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 27),
            profileImage.heightAnchor.constraint(equalToConstant: 42),
            profileImage.widthAnchor.constraint(equalToConstant: 42),
            
            textDescription.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            textDescription.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 16),
            textDescription.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -16)
        ])
    }
    
}
