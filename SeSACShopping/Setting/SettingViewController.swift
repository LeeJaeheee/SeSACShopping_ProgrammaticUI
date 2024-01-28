//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

enum Setting: String, CaseIterable {
    case 공지사항
    case 자주묻는질문 = "자주 묻는 질문"
    case 문의 = "1:1 문의"
    case 알림설정 = "알림 설정"
    case 처음부터시작하기 = "처음부터 시작하기"
}

class SettingViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    let list = Setting.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureHierarchy()
        configureView()
        setupConstraints()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

}

extension SettingViewController: VCProtocol {
    
    func configureNavigationItem() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "설정"
        navigationItem.backButtonTitle = ""
    }
    
    func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        
        tableView.sectionHeaderHeight = 0
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
            
            cell.configureCell()
            cell.selectionStyle = .none
        
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell")!
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.textLabel?.text = list[indexPath.row].rawValue
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = ProfileViewController()
            vc.type = .edit
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.item == Setting.allCases.firstIndex(of: .처음부터시작하기) {
            let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                if let bundleIdentifier = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                }
                UserDefaultsManager.shared.setWindow()
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(alert, animated: true)
        }
    }
    
}
