//
//  Indicator.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/02/07.
//

import Foundation
import NVActivityIndicatorView

class Indicator: UIViewController{
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    //インジケーターの追加
    func addIndicator(){
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: NVActivityIndicatorType.ballPulse, color: UIColor.lightGray, padding: 0)
        activityIndicatorView.center = self.view.center // 位置を中心に設定
        view.addSubview(activityIndicatorView)
    }
    
    //インジケータ開始(startメソッドは書かなくてもOKw)
    func startIndicator() {
        activityIndicatorView.startAnimating()
    }

    
}

