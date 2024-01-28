//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var historyLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var emptyView: UIView!
    @IBOutlet var emptyImageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    
    let udManager = UserDefaultsManager.shared
    
    var isEmpty = true {
        didSet {
            emptyView.isHidden = !isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureUI()
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

extension MainViewController {
    
    func configureNavigationItem() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
    }
    
    func configureUI() {
        isEmpty = udManager.searchHistory.isEmpty
        
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        
        historyLabel.text = "최근 검색"
        historyLabel.font = .boldSystemFont(ofSize: 16)
        
        deleteButton.setTitle("모두 지우기", for: .normal)
        deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        emptyImageView.image = .empty
        
        emptyLabel.text = "최근 검색어가 없어요"
        emptyLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showResult(text: String) {
        let sb = UIStoryboard(name: "SearchResult", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as! SearchResultViewController
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
        showResult(text: udManager.searchHistory[indexPath.row])
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
