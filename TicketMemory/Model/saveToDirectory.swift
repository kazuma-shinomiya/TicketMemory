//
//  saveToDirectory.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/02/07.
//

import Foundation
import UIKit

class saveToDirectory : UIViewController{
    // ドキュメントディレクトリの「ファイルURL」（URL型）定義
    var documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    // ドキュメントディレクトリの「パス」（String型）定義
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    //保存するためのパスを作成する
    func createLocalDataFile() {
        // 作成するテキストファイルの名前
        let fileName = "\(NSUUID().uuidString).png"

        // DocumentディレクトリのfileURLを取得
        if documentDirectoryFileURL != nil {
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let path = documentDirectoryFileURL.appendingPathComponent(fileName)
            documentDirectoryFileURL = path
        }
    }
    
    //画像を保存する関数の部分
    func saveImage(ImageView:UIImageView) {
        createLocalDataFile()
        //pngで保存する場合
        let pngImageData = ImageView.image?.pngData()
        do {
            try pngImageData!.write(to: documentDirectoryFileURL)
        } catch {
            //エラー処理
            print("エラー")
        }
    }
}
