//
//  VilleTableViewController.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit
import CoreData

class VilleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,UISearchResultsUpdating{
    var rechercheController : UISearchController!
    var fetchResultController: NSFetchedResultsController<VilleMO>!
    var rechercheResultas:[VilleMO] = []
    
    var villes: [VilleMO] = []
    
    // MARK:- Cycle de vie de la vue controller

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Personnalisation de la barre de navigation
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            // Pour les utilisateurs de Xcode 9, NSAttributedString.Key équivaut à NSAttributedStringKey
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 153.0/255.0, alpha: 1.0), NSAttributedString.Key.font: customFont]
        }
        
        navigationController?.hidesBarsOnSwipe = true
        
        // Préparation de la vue secondaire
        tableView.backgroundView = vueSecondaire
        tableView.backgroundView?.isHidden = true
        
        
        // Récupération des données dans la base de données
        let fetchRequest: NSFetchRequest<VilleMO> = VilleMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nom", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    villes = fetchedObjects // Objets trouvés
                }
            } catch {
                print(error)
            }
        }
        rechercheController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = rechercheController
        rechercheController.searchResultsUpdater = self
        rechercheController.dimsBackgroundDuringPresentation = false
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if rechercheController.isActive{
            return false
        }else{
            return true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource Protocol

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if villes.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rechercheController.isActive{
            return rechercheResultas.count
        }else{
            return villes.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifiant = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiant, for: indexPath) as! VilleTableViewCell

        let ville = (rechercheController.isActive) ? rechercheResultas[indexPath.row] : villes[indexPath.row]
        cell.labelNom.text = ville.nom
        
        if let villeImage = ville.photo {
            cell.imageViewPhoto.image = UIImage(data: villeImage as Data)
        }
        
      

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    // MARK: - UITableViewDelegate Protocol
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let supprimerAction = UIContextualAction(style: .destructive, title: "Supprimer") { (action, sourceView, completionHandler) in
            // Suppression de la cellule sélectionnée
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context =  appDelegate.persistentContainer.viewContext
                let cafeASupprimer = self.fetchResultController.object(at: indexPath)
                context.delete(cafeASupprimer)
                
                appDelegate.saveContext()
            }
            
            // Appel le completion handler pour quitter l'action
            completionHandler(true)
        }
        
        let partagerAction = UIContextualAction(style: .normal, title: "Partager") { (action, sourceView, completionHandler) in
            let texteParDefaut = "Allez visiter cette ville : " + self.villes[indexPath.row].nom!
            
            let activityController: UIActivityViewController
            
            if let villeImage = self.villes[indexPath.row].photo, let imageAPartager = UIImage(data: villeImage as Data) {
                activityController = UIActivityViewController(activityItems: [texteParDefaut, imageAPartager], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [texteParDefaut], applicationActivities: nil)
            }
            
            self.present(activityController, animated: true, completion: nil)
            
            completionHandler(true)
        }
        
        supprimerAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        supprimerAction.image = UIImage(named: "delete")
        
       
        partagerAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [supprimerAction, partagerAction])
        
        return swipeConfiguration
    }
 


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "affichageDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailsVilleViewController
                destinationController.ville = (rechercheController.isActive) ? rechercheResultas[indexPath.row] : villes[indexPath.row]
            }
        }
    }
    
    @IBAction func retourPagePrincipale(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Vue secondaire
    
    @IBOutlet var vueSecondaire: UIView!
    
    // Méthodes protocols requête
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            villes = fetchedObjects as! [VilleMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func filtrerContents(for seartchText: String){
        rechercheResultas = villes.filter({(ville) ->Bool in
            if let nom = ville.nom{
                let isMatch = nom.localizedCaseInsensitiveContains(seartchText)
                return isMatch
                
            }
            return false
            
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let seartchText = rechercheController.searchBar.text{
            filtrerContents(for: seartchText)
            tableView.reloadData()
        }
    }
}
