//
//  ProfileImageViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class ProfileImageViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    let udManager = UserDefaultsManager.shared
    
    var selectedImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureCollectionView()
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        udManager.selectedImage = selectedImageName
    }

}

extension ProfileImageViewController {
    
    func configureUI() {
        profileImageView.image = UIImage(named: selectedImageName)
        profileImageView.setRound()
        profileImageView.setDefaultBorder()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let xib = UINib(nibName: ProfileImageCollectionViewCell.identifier, bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    func configureLayout() {
        let spacing: CGFloat = 16
        let width = (UIScreen.main.bounds.width - (spacing * 3 + 40)) / 4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
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
            cell.imageView.setDefaultBorder()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedImageName = ProfileImage.imageList[indexPath.item]
        profileImageView.image = UIImage(named: selectedImageName)
        collectionView.reloadData()
        
    }
    
}
