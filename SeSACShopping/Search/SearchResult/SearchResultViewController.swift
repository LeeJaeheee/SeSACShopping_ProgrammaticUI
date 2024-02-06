//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit

enum Sort: String, CaseIterable {
    case sim
    case date
    case dsc
    case asc
    
    var value: String {
        switch self {
        case .sim:
            "정확도순"
        case .date:
            "날짜순"
        case .dsc:
            "가격높은순"
        case .asc:
            "가격낮은순"
        }
    }
}

enum CollectionViewType: Int, CaseIterable {
    case tagCollectionView
    case resultCollectionView
    
    var cellIdentifier: String {
        switch self {
        case .tagCollectionView:
            TagCollectionViewCell.identifier
        case .resultCollectionView:
            ResultCollectionViewCell.identifier
        }
    }
    
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        switch self {
        case .tagCollectionView:
            let spacing: CGFloat = 16
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
            layout.minimumInteritemSpacing = spacing
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        case .resultCollectionView:
            let spacing: CGFloat = 16
            let width = (UIScreen.main.bounds.width - spacing * 3) / 2
            layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
            layout.itemSize = CGSize(width: width, height: width * 1.5)
        }
        return layout
    }
}

enum APIRequestType {
    case setup
    case changeSort
    case prefetch
}

class SearchResultViewController: UIViewController {
    
    let countLabel = UILabel()
    let tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewType.tagCollectionView.layout)
    let resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewType.resultCollectionView.layout)
    
    let emptyView = EmptyView(text: "찾으시는 상품이 없어요")
    var isEmpty = false {
        didSet {
            emptyView.isHidden = !isEmpty
            tagCollectionView.isHidden = isEmpty
            resultCollectionView.isHidden = isEmpty
        }
    }
    
    let apiManager = APIManager()
    
    var navTitle = ""
    var sort = Sort.sim {
        didSet {
            queryString.sort = sort.rawValue
        }
    }
    
    var total: Int = 0
    var resultList: [ResultItem] = []
    var selectedIndex: IndexPath?
    
    lazy var queryString = QueryString(query: navTitle, start: 1, sort: sort.rawValue)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        configureHierarchy()
        configureView()
        setupConstraints()

        configureCollectionView(collectionView: tagCollectionView, type: .tagCollectionView)
        configureCollectionView(collectionView: resultCollectionView, type: .resultCollectionView)
        
        apiRequest(type: .setup)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let index = selectedIndex {
            resultCollectionView.reloadItems(at: [index])
        }
    }
    
    func apiRequest(type: APIRequestType) {
        //queryString = QueryString(query: "", start: 1, sort: sort.rawValue) //에러핸들링 테스트
        
        apiManager.callRequest(queryString: queryString) { value, error  in
            
            if let error = error {
                self.showAlert(title: "오류 발생", message: error.errorMessage) {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            guard let value else { return }
            
            if value.total == 0 {
                self.isEmpty = true
                return
            } else {
                self.isEmpty = false
            }
            
            switch type {
                
            case .setup, .changeSort:
                self.total = value.total
                self.countLabel.text = "\(value.total.formatted()) 개의 검색 결과"
                self.resultList = value.items
                
                if type == .changeSort {
                    if !self.resultList.isEmpty {
                        self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                }
                
            case .prefetch:
                if self.queryString.start == 1 {
                    self.resultList = value.items
                } else {
                    self.resultList.append(contentsOf: value.items)
                }
                
            }
            
            self.resultCollectionView.reloadData()
        }
    }
    
}

extension SearchResultViewController: VCProtocol {
    
    func configureHierarchy() {
        view.addSubview(countLabel)
        view.addSubview(tagCollectionView)
        view.addSubview(resultCollectionView)
        view.addSubview(emptyView)
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        emptyView.isHidden = true
        tagCollectionView.isHidden = true
        resultCollectionView.isHidden = true
        
        countLabel.font = .boldSystemFont(ofSize: 14)
        countLabel.textColor = .accent
        
        tagCollectionView.tag = CollectionViewType.tagCollectionView.rawValue
        resultCollectionView.tag = CollectionViewType.resultCollectionView.rawValue
    }
    
    func setupConstraints() {
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.height.equalTo(22)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(52)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func configureNavigationItem() {
        navigationItem.title = navTitle
        navigationItem.backButtonTitle = ""
    }
    
    func configureCollectionView(collectionView: UICollectionView, type: CollectionViewType) {
        collectionView.delegate = self
        collectionView.dataSource = self
  
        switch type {
        case .tagCollectionView:
            collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        case .resultCollectionView:
            collectionView.prefetchDataSource = self
            collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        }
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.type {
        case .tagCollectionView:
            return Sort.allCases.count
        case .resultCollectionView:
            return resultList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView.type {
        case .tagCollectionView:
            let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
            cell.tagLabel.text = Sort.allCases[indexPath.row].value
            if sort == Sort.allCases[indexPath.row] {
                cell.backgroundColor = .white
                cell.tagLabel.textColor = .black
            } else {
                cell.backgroundColor = .clear
                cell.tagLabel.textColor = .white
            }
            return cell
        case .resultCollectionView:
            let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
            cell.configureCell(data: resultList[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.type {
        case .tagCollectionView:
            sort = Sort.allCases[indexPath.row]
            queryString.start = 1
            tagCollectionView.reloadData()
            apiRequest(type: .changeSort)

        case .resultCollectionView:
            selectedIndex = indexPath
            let vc = ProductDetailViewController()
            vc.data = resultList[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if resultList.count - 3 == item.item && resultList.count < total {
                queryString.start += queryString.display
                apiRequest(type: .prefetch)
            }
        }
    }
}
