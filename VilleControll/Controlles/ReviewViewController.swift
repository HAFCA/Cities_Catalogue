//
//  ReviewViewController.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var noteBoutons: [UIButton]!
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    var ville: VilleMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let villeImage = ville.photo{
            backgroundImageView.image = UIImage(data: villeImage as Data)
        }
        
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        
        
        for noteBouton in noteBoutons {
            noteBouton.transform = moveScaleTransform
            noteBouton.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Rendre les boutons visibles (partie 2)
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
            self.noteBoutons[0].alpha = 1.0
            self.noteBoutons[0].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
            self.noteBoutons[1].alpha = 1.0
            self.noteBoutons[1].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.20, options: [], animations: {
            self.noteBoutons[2].alpha = 1.0
            self.noteBoutons[2].transform = .identity
        }, completion: nil)
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
