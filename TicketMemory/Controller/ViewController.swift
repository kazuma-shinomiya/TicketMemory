//
//  ViewController.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/01/31.
//

import UIKit
import RealmSwift



extension ViewController :UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            
        ticketListTableView.reloadData()
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var ticketListTableView: UITableView!
    
    
    var ticketData:Results<Ticket>!

    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ticketListTableView.delegate = self
        ticketListTableView.dataSource = self
        //xibの読み込み
        ticketListTableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")
        

        let realm = try! Realm()
        ticketData = realm.objects(Ticket.self)
        // 画面の幅を取得
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height
        
        //plusボタンの生成
        let addButton = UIButton()
        addButton.frame = CGRect(x: screenWidth * 0.75, y: screenHeight * 0.75,  width: screenWidth/6, height: screenWidth/6)
        addButton.setImage(UIImage(named: "plus5"), for: .normal)
        // ViewにButtonを追加
        self.view.addSubview(addButton)
        // タップされたときのactionをセット
        addButton.addTarget(self, action: #selector(ViewController.buttonTapped(_sender:)),for: .touchUpInside)
        
    
        
    }
    
    @objc func buttonTapped(_sender : Any){
        let addTicketVC = storyboard?.instantiateViewController(identifier: "AddTicketVC") as! AddTicketViewController
        addTicketVC.presentationController?.delegate = self
        present(addTicketVC, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketData.count
    }
    
    //セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell",for: indexPath) as! TicketTableViewCell
        cell.placeNameLabel.text = ticketData[indexPath.row].name
        cell.dateLabel.text = ticketData[indexPath.row].selectedDate
        //URL型に変換しファイルパスにする
        let fileURL = URL(string: ticketData[indexPath.row].imageURL)
        let filePath = fileURL?.path
        //画像の処理
        cell.ticketImageView.image = UIImage(contentsOfFile: filePath!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
    
    //編集の許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //スワイプアクションについて
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //編集のアクション
        let editAction = UIContextualAction(style:.normal , title: "edit"){
            (ctxAction, view, completionHandler) in
            //画面遷移
            let editTicketVC = self.storyboard?.instantiateViewController(identifier: "EditTicketVC") as! EditTicketViewController
            //値を渡す
            editTicketVC.selectedId = indexPath.row
            editTicketVC.presentationController?.delegate = self
            self.present(editTicketVC, animated: true, completion: nil)
            
            
            completionHandler(true)
        }
        
        // 編集ボタンのデザインを設定する
        let editImage = UIImage(systemName: "pencil")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
        editAction.image = editImage
        editAction.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1)
        
        //削除のアクション
        let deleteAction = UIContextualAction(style:.destructive,title: "delete"){ [self]
            (ctxAction,view,completionHandler) in
            let realm = try! Realm()
            try! realm.write{
                realm.delete(self.ticketData[indexPath.row])
            }
            ticketListTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            completionHandler(true)
        }
        //削除ボタンのデザイン
        let trashImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.white,renderingMode: .alwaysTemplate)
        deleteAction.image = trashImage
        
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        //スワイプの削除を無効化
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
    
    
    


}

