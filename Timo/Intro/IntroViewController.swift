//
//  IntroViewController.swift
//  Timo
//
//  Created by Prince Alvin Yusuf on 30/03/20.
//  Copyright © 2020 sambalpete. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    @IBOutlet weak var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: Asset.tradein_image.image,
                           title: "Are you sad ?",
                           description: "Tell us your story today, 'Memo' is here for you.",
                           pageIcon: Asset.indicator_sad_icon.image,
                           color: UIColor(red: 0.49, green: 0.66, blue: 1.00, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.rebound_image.image,
                           title: "Relieve it!",
                           description: "With 'Chat', express your emotion.",
                           pageIcon: Asset.indicator_smile_icon.image,
                           color: UIColor(red: 0.44, green: 0.82, blue: 1.00, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.curhat_image.image,
                           title: "Interact!",
                           description: "Engage with shared 'Chat' from everybody around the world.",
                           pageIcon: Asset.indicator_opinion_icon.image,
                           color: #colorLiteral(red: 0.4431372549, green: 0.8862745098, blue: 0.8156862745, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.isHidden = true
        
        setupPaperOnboardingView()
        
        view.bringSubviewToFront(skipButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension IntroViewController {
    @IBAction func skipButtonTapped(_: UIButton) {
        print(#function)
        print("button skip")
        
        //Pergi ke menu utama
        performSegue(withIdentifier: "gotomainmenu", sender: nil)
    }
}

// MARK: PaperOnboardingDelegate

extension IntroViewController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
}

// MARK: PaperOnboardingDataSource

extension IntroViewController: PaperOnboardingDataSource {
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
}


//MARK: Constants
extension IntroViewController {
    private static let titleFont = UIFont(name: "NuniSto-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}
