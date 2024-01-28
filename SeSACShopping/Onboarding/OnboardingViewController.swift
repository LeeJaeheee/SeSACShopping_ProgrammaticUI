//
//  OnboardingViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/28/24.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {

    let logoImageView = UIImageView()
    let onboardingImageView = UIImageView()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        configureHierarchy()
        configureView()
        setupConstraints()
    }
    
    @objc func startButtonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }

}

extension OnboardingViewController: VCProtocol {
    func configureNavigationItem() {
        navigationItem.backButtonTitle = ""
    }
    
    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(onboardingImageView)
        view.addSubview(startButton)
    }
    
    func configureView() {
        logoImageView.image = .sesacShopping
        onboardingImageView.image = .onboarding
        
        startButton.setDefaultStyle(title: "시작하기")
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        onboardingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.95)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(onboardingImageView.snp.width)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.35)
            make.width.equalToSuperview().multipliedBy(0.54)
            make.height.equalTo(logoImageView.snp.width).multipliedBy(47.0/105.0)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
    }
    
}

#Preview {
    OnboardingViewController()
}
