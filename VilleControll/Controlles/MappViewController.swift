//
//  MappViewController.swift
//  VilleControll
//
//  Created by hafca on 6/15/20.
//  Copyright © 2020 hafca. All rights reserved.
//

import UIKit
import MapKit

class MappViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var ville: VilleMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Personnalisation de la carte
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        
        // Convertir l'adresse en coordonnées et l'annoter sur la carte
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(ville.nom ?? "") { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Récupération du premier emplacement
                let placemark = placemarks[0]
                
                // Ajout de l'annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.ville.nom
                
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Affichage de l'annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    // MARK: - Personnalisation de l'annotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifiant = "MonMarqueur"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Réutiliser l'annotation si possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifiant) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifiant)
        }
        
        annotationView?.glyphText = "🚀"
        annotationView?.markerTintColor = .green
        
        return annotationView
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

