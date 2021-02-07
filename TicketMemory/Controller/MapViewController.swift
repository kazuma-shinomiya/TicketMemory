//
//  MapViewController.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/02/06.
//

import UIKit
import GoogleMaps
import MapKit
import RealmSwift


class MapViewController: UIViewController {
    
    
    var ticketData:Results<Ticket>!
    var addressArray:[String] = []
    
    
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //富士山が中央に来るようにする
        let camera = GMSCameraPosition.camera(withLatitude: 35.2145, longitude: 138.4350, zoom: 4.8)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

        
        //住所から緯度経度を求める
        let realm = try! Realm()
        ticketData = realm.objects(Ticket.self)
        //ジオコーディング
        for i in stride(from: 0, to: ticketData.count, by: 1){
            let address = ticketData[i].adress
            CLGeocoder().geocodeAddressString(address) { [self] placemarks, error in
                if let lat = placemarks?.first?.location?.coordinate.latitude, let log = placemarks?.first?.location?.coordinate.longitude{
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(lat,log)
                    marker.title = ticketData[i].name
                    marker.snippet = "訪問日:\(ticketData[i].selectedDate)"
                    marker.icon = UIImage(named: "marker3.png")
                    marker.map = mapView
                }else{
                    print("緯度経度を取得できませんでした")
                }
                
            }
            
        }
        
        
        
    }
    
    
    @IBAction func reload(_ sender: Any) {
        self.viewDidLoad()
    }
}
