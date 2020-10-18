//
//  DetailsCafeViewController.swift
//  Cafegram2FR
//
//  Created by Farukh IQBAL on 31/05/2018.
//  Copyright © 2018 Farukh IQBAL. All rights reserved.
//

import UIKit

class DetailsCafeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: CafeDetailHeaderView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noterCafe(segue: UIStoryboardSegue) {
        
        dismiss(animated: true) {
            if let note = segue.identifier {
                self.cafe.note = note
                self.headerView.noteImageView.image = UIImage(named: note)
            }
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.saveContext()
            }
            
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.headerView.noteImageView.transform = scaleTransform
            self.headerView.noteImageView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.headerView.noteImageView.transform = .identity
                self.headerView.noteImageView.alpha = 1.0
            }, completion: nil)
        }
    }
    
    var cafe: CafeMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Configuration de l'en-tête (header view)
        headerView.nomLabel.text = cafe.nom
        headerView.typeLabel.text = cafe.type
        
        if let cafeImage = cafe.image {
            headerView.headerImageView.image = UIImage(data: cafeImage as Data)
        }
        
        // Configuration de la table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Personnalisation de la barre de navigation
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.hidesBarsOnSwipe = false
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        if let note = cafe.note {
            headerView.noteImageView.image = UIImage(named: note)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailIconTextCell.self), for: indexPath) as! CafeDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = cafe.telephone
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailIconTextCell.self), for: indexPath) as! CafeDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = cafe.location
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailTextCell.self), for: indexPath) as! CafeDetailTextCell
            cell.descriptionLabel.text = cafe.summary
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailSeparatorCell.self), for: indexPath) as! CafeDetailSeparatorCell
            cell.titreLabel.text = "COMMENT SE RENDRE ICI"
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailMapCell.self), for: indexPath) as! CafeDetailMapCell
            
            if let cafeLocation = cafe.location {
                cell.configure(location: cafeLocation)
            }
            
            return cell
        default:
            fatalError("Action a échoué")
        }
    }
    
    // MARK:- Personnalisation de la barre de statut
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.cafe = cafe
        }
        
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.cafe = cafe
        }
    }
    
    
}
