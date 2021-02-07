//
//  GeminiViewController.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/02/07.
//

import UIKit
import Gemini
import RealmSwift


class GeminiViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var geminiCollectionView: GeminiCollectionView!{
        didSet{
            //アニメーション
            geminiCollectionView.gemini
                .circleRotationAnimation()
                .radius(450) // The radius of the circle
                .rotateDirection(.clockwise) // Direction of rotation.
                .itemRotationEnabled(true) 
        }
        
    }
    
    
    
    
    var ticketData:Results<Ticket>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geminiCollectionView.dataSource = self
        geminiCollectionView.delegate = self
        
        let realm = try! Realm()
        ticketData = realm.objects(Ticket.self)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ticketData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = geminiCollectionView.dequeueReusableCell(withReuseIdentifier: "geminiCell", for: indexPath)
        let ImageView = cell.contentView.viewWithTag(1) as! UIImageView
        //URL型に変換しファイルパスにする
        let fileURL = URL(string: ticketData[indexPath.row].imageURL)
        let filePath = fileURL?.path
        //画像の処理
        ImageView.image = UIImage(contentsOfFile: filePath!)
        
        //アニメーション
        geminiCollectionView.animateCell(cell as! GeminiCell)
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       geminiCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell{
            geminiCollectionView.animateCell(cell)
        }
    }
    
    

}

