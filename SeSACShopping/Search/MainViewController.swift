//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class MainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let historyLabel = UILabel()
    let deleteButton = UIButton()
    let tableView = UITableView()
    
    let emptyView = EmptyView(text: "최근 검색어가 없어요")
    
    let udManager = UserDefaultsManager.shared
    
    var isEmpty = true {
        didSet {
            emptyView.isHidden = !isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureHierarchy()
        configureView()
        setupConstraints()
        configureTableView()
        
        deleteButton.addTarget(self, action: #selector(deleteHistory), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "\(udManager.nickname!)님의 새싹쇼핑"
    }
    
    @objc func deleteHistory() {
        udManager.searchHistory = []
        isEmpty = true
    }

}

extension MainViewController: VCProtocol {
    func configureNavigationItem() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
    }

    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(historyLabel)
        view.addSubview(deleteButton)
        view.addSubview(tableView)
        view.addSubview(emptyView)
    }
    
    func configureView() {
        isEmpty = udManager.searchHistory.isEmpty
        
        searchBar.delegate = self
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        
        historyLabel.text = "최근 검색"
        historyLabel.font = .boldSystemFont(ofSize: 16)
        
        deleteButton.setTitle("모두 지우기", for: .normal)
        deleteButton.setTitleColor(.accent, for: .normal)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        historyLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalTo(8)
            make.height.equalTo(44)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.equalTo(-8)
            make.height.equalTo(44)
            
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(historyLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
    func showResult(text: String) {
        let vc = SearchResultViewController()
        vc.navTitle = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return udManager.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")!
        
        cell.selectionStyle = .none
        cell.imageView?.image = UIImage(systemName: "magnifyingglass")
        cell.imageView?.tintColor = .white
        
        cell.accessoryType = .none
        let accessoryImageView = UIImageView(image: UIImage(systemName: "xmark"))
        accessoryImageView.tintColor = .darkGray
        accessoryImageView.isUserInteractionEnabled = true
        cell.accessoryView = accessoryImageView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(accessoryTapped))
        accessoryImageView.addGestureRecognizer(tapGesture)
        
        cell.textLabel?.text = udManager.searchHistory[indexPath.row]
        
        return cell
    }
    
    @objc func accessoryTapped(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            udManager.searchHistory.remove(at: indexPath.row)
            isEmpty = udManager.searchHistory.isEmpty
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = udManager.searchHistory[indexPath.row]
        udManager.addSearchHistory(text, index: indexPath.row)
        tableView.reloadData()
        showResult(text: text)
    }
    
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        udManager.addSearchHistory(text)
        isEmpty = false
        
        view.endEditing(true)
        tableView.reloadData()
        
        showResult(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

#Preview {
    MainViewController()
}
