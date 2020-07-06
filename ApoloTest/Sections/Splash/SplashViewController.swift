//
//  SplashViewController.swift
//  ApoloTest
//
//  Created by wilnin on 5/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    fileprivate struct Segues {
        static let homeViewController = "homeSegueViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        goToHomeView()
    }
    
    func goToHomeView() {
       perform(#selector(goBussinesView), with: nil, afterDelay: 2)
    }
    
    func startAnimation() {
        let animationView = AnimationView()
        animationView.animation = Animation.named("rocketFast")
        animationView.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        animationView.center = view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        animationView.play()
    }

    @objc func goBussinesView() {
        self.performSegue(withIdentifier: Segues.homeViewController, sender: self)
    }
}
