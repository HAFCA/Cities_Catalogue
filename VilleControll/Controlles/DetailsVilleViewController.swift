//
//  DetailsVilleViewController.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit
class DetailsVilleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: VilleDetailHeaderView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noterVille(segue: UIStoryboardSegue) {
        
        dismiss(animated: true) {
            if let note = segue.identifier {
                self.ville.note = note
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
    
    var ville: VilleMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        // Configuration de l'en-tête (header view)
        headerView.nomLabel.text = ville.nom
        
        
        if let villeImage = ville.photo {
            headerView.headerImageView.image = UIImage(data: villeImage as Data)
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
        
        if let note = ville.note {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
      
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VilleDetailTextCell.self), for: indexPath) as! VilleDetailTextCell
            cell.descriptionLabel.text = ville.descrip
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:  VilleDetailSeparatorCell.self), for: indexPath) as! VilleDetailSeparatorCell
            cell.titreLabel.text = "Où je peux trouver cette place?"
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VilleDetailMapCell.self), for: indexPath) as! VilleDetailMapCell
            
            if let villeLocation = ville.nom {
                cell.configure(location: villeLocation)
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
            let destinationController = segue.destination as! MappViewController
            destinationController.ville = ville
        }
        
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.ville = ville
        }
    }
    
    
}
