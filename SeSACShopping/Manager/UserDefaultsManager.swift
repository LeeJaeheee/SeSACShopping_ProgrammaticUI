//
//  UserDefaultsManager.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class UserDefaultsManager {
    
    private init() { }
    
    enum UDKey: String {
        case UserState
        case nickname
        case profileImage
        case selectedImage
        case searchHistory
        case likeList
    }
    
    static let shared = UserDefaultsManager()
    
    let ud = UserDefaults.standard
    
    var UserState: Bool {
        get { ud.bool(forKey: UDKey.UserState.rawValue) }
        set { ud.set(newValue, forKey: UDKey.UserState.rawValue) }
    }
    
    var nickname: String? {
        get { ud.string(forKey: UDKey.nickname.rawValue) }
        set { ud.set(newValue, forKey: UDKey.nickname.rawValue) }
    }
    
    var profileImage: String? {
        get { ud.string(forKey: UDKey.profileImage.rawValue) }
        set { ud.set(newValue, forKey: UDKey.profileImage.rawValue) }
    }
    
    var selectedImage: String? {
        get { ud.string(forKey: UDKey.selectedImage.rawValue) }
        set { ud.set(newValue, forKey: UDKey.selectedImage.rawValue) }
    }
    
    var searchHistory: [String] {
        get { ud.array(forKey: UDKey.searchHistory.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.searchHistory.rawValue) }
    }
    
    var likeList: [String] {
        get { ud.array(forKey: UDKey.likeList.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.likeList.rawValue) }
    }
    
    func addSearchHistory(_ newHistory: String, index: Int? = nil) {
        if let index = index ?? searchHistory.firstIndex(of: newHistory) {
            searchHistory.remove(at: index)
        }
        searchHistory.insert(newHistory, at: 0)
    }
    
    func updateLike(productId: String) -> Bool {
        if let index = likeList.firstIndex(of: productId) {
            likeList.remove(at: index)
            return false
        } else {
            likeList.append(productId)
            return true
        }
    }
    
    func isLiked(productId: String) -> Bool {
        return likeList.contains(productId)
    }
    
    func setWindow() {
        switch UserState {
        case true:
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            sceneDelegate?.window?.rootViewController = MainTabBarController()
            sceneDelegate?.window?.makeKeyAndVisible()
        case false:
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate

            sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
}
