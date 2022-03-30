//
//  NavigationController.swift
//  WorkList
//
//  Created by Максим Горячкин on 24.03.2022.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNC()
    }
    
    private func setupNC() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .systemCyan
        navigationAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationBar.standardAppearance = navigationAppearance
        navigationBar.tintColor = .white
    }
}
