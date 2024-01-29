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

    let profileImageView = RoundImageView(image: nil)
    let cameraImageView = UIImageView()
    let nicknameTextField = UITextField()
    let lineView = UIView()
    let validationLabel = UILabel()
    let saveButton = MainButton(title: "완료")
    
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
        configureHierarchy()
        configureView()
        setupConstraints()
        setupActions()
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
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text!
        validateText(text)

        validationLabel.text = validationResult.rawValue
        validationLabel.textColor = validationResult.textColor
    }

    @objc func keyboardReturnTapped(_ sender: UITextField) {
        
    }

    @objc func imageViewTapped() {
        let vc = ProfileImageViewController()
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

extension ProfileViewController: VCProtocol {
    
    func configureNavigationItem() {
        navigationItem.title = type.rawValue
        navigationItem.backButtonTitle = ""
    }
    
    func configureHierarchy() {
        view.addSubview(profileImageView)
        view.addSubview(cameraImageView)
        view.addSubview(nicknameTextField)
        view.addSubview(lineView)
        view.addSubview(validationLabel)
        view.addSubview(saveButton)
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        
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
        
        profileImageView.drawBorder = true
        
        cameraImageView.image = .camera
        cameraImageView.isUserInteractionEnabled = true
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.font = .systemFont(ofSize: 16)
        nicknameTextField.borderStyle = .none
        
        lineView.backgroundColor = .placeholderText
        
        validationLabel.font = .systemFont(ofSize: 13)
        validationLabel.textColor = .systemGreen
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(view.snp.width).multipliedBy(0.23)
        }

        cameraImageView.snp.makeConstraints { make in
            make.size.equalTo(profileImageView.snp.width).multipliedBy(0.25)
            make.bottom.trailing.equalTo(profileImageView).multipliedBy(0.99)
        }

        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.height.equalTo(44)
        }

        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField)
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.height.equalTo(2)
        }

        validationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).inset(30)
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.height.equalTo(16)
        }

        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(validationLabel.snp.bottom).offset(32)
        }
    }
    
    func setupActions() {
        nicknameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        nicknameTextField.addTarget(self, action: #selector(keyboardReturnTapped), for: .editingDidEndOnExit)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
}

#Preview {
    ProfileViewController()
}
