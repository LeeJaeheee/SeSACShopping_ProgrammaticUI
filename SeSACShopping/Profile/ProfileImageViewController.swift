//
//  ProfileImageViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class ProfileImageViewController: UIViewController {

    let profileImageView = RoundImageView(image: nil)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    
    let udManager = UserDefaultsManager.shared
    
    var selectedImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureView()
        setupConstraints()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        udManager.selectedImage = selectedImageName
    }

}

extension ProfileViewController {
    
}

extension ProfileImageViewController: CollectionViewProtocol {
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(collectionView)
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        
        profileImageView.image = UIImage(named: selectedImageName)
        profileImageView.drawBorder = true
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(view.snp.width).multipliedBy(0.4)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing: CGFloat = 16
        let width = (UIScreen.main.bounds.width - (spacing * 3 + 40)) / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
    
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ProfileImage.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        let imageName = ProfileImage.imageList[indexPath.row]
        cell.imageView.image = UIImage(named: imageName)
        
        if imageName == selectedImageName {
            cell.imageView.drawBorder = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedImageName = ProfileImage.imageList[indexPath.item]
        profileImageView.image = UIImage(named: selectedImageName)
        collectionView.reloadData()
        
    }
    
}

#Preview {
    ProfileImageViewController()
}
