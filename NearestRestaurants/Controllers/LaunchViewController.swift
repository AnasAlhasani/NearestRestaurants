//
//  LaunchViewController.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/15/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    //MARK: Transitions
    fileprivate enum WelcomeTransition {
        case show
        case dismiss
    }
    
    //MARK: Properties
    private weak var welcomeView: WelcomeView?
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWelcomeView()
        animateWelcomeView(.show, onComplete: nil)
    }
    
    
}

//MARK: - Configuration
private extension LaunchViewController {
    
    func configureWelcomeView() {
        let nib = UINib(nibName: "WelcomeView", bundle: nil)
        let instantiatedView = nib.instantiate(withOwner: nil, options: nil)
        guard let welcomeView = instantiatedView.first as? WelcomeView else {
            return
        }
        
        self.welcomeView = welcomeView
        view.addSubview(welcomeView)
        
        welcomeView.frame = CGRect(
            x: 0,
            y: view.bounds.height,
            width: view.bounds.width,
            height: view.bounds.height/2
        )
        
        welcomeView.setPermession(
            title: "Location",
            message: "Restaurant app lets you the nearest restaurants to your current location"
        )
        
        welcomeView.onButtonTap = { [weak self] in
            guard let storngSelf = self else { return }
            storngSelf.startButtonTapped()
        }
    }
    
}

//MARK: - Interactions
private extension LaunchViewController {
    
    func startButtonTapped() {
        animateWelcomeView(.dismiss, onComplete: { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.welcomeView?.removeFromSuperview()
            strongSelf.welcomeView = nil
            let controller = RestaurantsListViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: controller)
            strongSelf.present(navigationController, animated: false, completion: nil)
        })
    }
    
    func animateWelcomeView(_ transition: WelcomeTransition, onComplete: (() -> Void)?) {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            guard let strongSelf = self else { return }
            guard let welcomeView = strongSelf.welcomeView else { return }
            if transition == .show {
                welcomeView.frame.origin.y = welcomeView.bounds.height
            }else {
                welcomeView.frame.origin.y = strongSelf.view.bounds.height
            }
        },
        completion: { _ in
            onComplete?()
        })
    }
}












