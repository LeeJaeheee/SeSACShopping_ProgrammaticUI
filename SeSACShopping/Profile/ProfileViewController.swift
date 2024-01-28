//
//  ProfileViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/18/24.
//

import UIKit

enum ProfilePageType: String {
    case set = "프로필 설정"
    case edit = "프로필 수정"
}

enum ProfileImage {
    static let imageList = (1...14).map { "profile\($0)" }
}

enum ValidationResult: String {
    case validate = "사용할 수 있는 닉네임이에요"
    case countError = "2글자 이상 10글자 미만으로 설정해주세요"
    case symbolError = "닉네임에 @,#,$,% 는 포함할 수 없어요"
    case numberError = "닉네임에 숫자는 포함할 수 없어요"
    
    var textColor: UIColor {
        switch self {
        case .validate:
            UIColor.systemGreen
        case .countError, .symbolError, .numberError:
            UIColor.systemRed
        }
    }
}

class ProfileViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var cameraImageView: UIImageView!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var lineView: UIView!
    @IBOutlet var validationLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    
    let udManager = UserDefaultsManager.shared
    
    var type = ProfilePageType.set
    
    var profileImageName = ""
    
    var validationResult = ValidationResult.countError {
        didSet {
            switch validationResult {
            case .validate:
                saveButton.setEnable()
            default:
                saveButton.setDisable()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let imageName = udManager.selectedImage {
            profileImageView.image = UIImage(named: imageName)
            profileImageName = imageName
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        udManager.selectedImage = nil
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text!
        validateText(text)
        
        validationLabel.text = validationResult.rawValue
        validationLabel.textColor = validationResult.textColor
    }
    
    @IBAction func keyboardReturnTapped(_ sender: UITextField) {
    }
    
    // TODO: 카메라 버튼도 연결하기
    @IBAction func imageViewTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ProfileImageViewController.identifier) as! ProfileImageViewController
        vc.navigationItem.title = navigationItem.title
        vc.selectedImageName = profileImageName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveButtonTapped() {
        udManager.nickname = nicknameTextField.text
        udManager.profileImage = profileImageName
        
        switch type {
        case .set:
            udManager.UserState = true
            udManager.setWindow()
        case .edit:
            navigationController?.popViewController(animated: true)
        }

    }
    
    func validateText(_ text: String) {
        if !((2...9) ~= text.count) {
            validationResult = .countError
        } else if text.filter({ Array("@#$%").contains($0) }).count > 0 {
            validationResult = .symbolError
        } else if text.filter({ $0.isNumber }).count > 0 {
            validationResult = .numberError
        } else {
            validationResult = .validate
        }
    }
    
}

extension ProfileViewController {
    
    func configureNavigationItem() {
        navigationItem.title = type.rawValue
        navigationItem.backButtonTitle = ""
    }
    
    func configureUI() {
        
        switch type {
        case .set:
            if let imageName = ProfileImage.imageList.randomElement() {
                profileImageView.image = UIImage(named: imageName)
                profileImageName = imageName
            }
            saveButton.setDisable()
        case .edit:
            if let imageName = udManager.profileImage {
                profileImageView.image = UIImage(named: imageName)
                profileImageName = imageName
            }
            if let nickname = udManager.nickname {
                nicknameTextField.text = nickname
            }
        }
                
        profileImageView.setRound()
        profileImageView.setDefaultBorder()
        profileImageView.isUserInteractionEnabled = true
        
        cameraImageView.image = .camera
        cameraImageView.isUserInteractionEnabled = true
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        
        lineView.backgroundColor = .placeholderText
        
        validationLabel.font = .systemFont(ofSize: 13)
        validationLabel.textColor = .systemGreen
        
        saveButton.setDefaultStyle(title: "완료")
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
}
