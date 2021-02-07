//
//  AddTicketViewController.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/01/31.
//

import UIKit
import RealmSwift
import WeScan
import GooglePlaces




class AddTicketViewController: UIViewController {
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var dateTextFiled: UITextField!
    @IBOutlet weak var ticketImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
 
    
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    let realm = try! Realm()
    
    let directory = saveToDirectory()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //日付選択
        datePicker = makeDatePicker()
        dateTextFiled.inputView = datePicker
        let toolbar = makeToolBar()
        dateTextFiled.inputAccessoryView = toolbar
        //ボタンの装飾
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.cornerRadius = 5
        albumButton.layer.borderWidth = 1
        albumButton.layer.cornerRadius = 5
        
        
    }
    
    @IBAction func addTicket(_ sender: UITextField) {
        
        directory.saveImage(ImageView:ticketImageView)
        let ticket = Ticket()
        ticket.name = placeNameTextField.text!
        ticket.adress = adressTextField.text!
        ticket.selectedDate = dateTextFiled.text!
        do{
            try ticket.imageURL = directory.documentDirectoryFileURL.absoluteString
        }catch{
            print("画像の保存に失敗しました")
        }
        try! realm.write{realm.add(ticket)}
    
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCamera(_ sender: Any) {
        startCamera()
    }
    
    @IBAction func onAlbum(_ sender: Any) {
        openLibrary()
    }
    
    @IBAction func placeAutoComplete(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // オートコンプリート用のViewの表示
        present(autocompleteController, animated: true, completion: nil)
    }

    
    //カメラの起動
    func startCamera() {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
    }
    //アルバムの起動
    func openLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


}

extension AddTicketViewController{
    //戻るときに画面更新
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
    
    func makeDatePicker() -> UIDatePicker {
        //datePickerの設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        
        return datePicker
    }
    
    func makeToolBar() -> UIToolbar{
        //決定バーの作成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem,doneItem], animated: true)
        
        return toolbar
    }
    
    // UIDatePickerのDoneを押したら
    @objc func done() {
        dateTextFiled.endEditing(true)
        // 日付のフォーマット
        let formatter = DateFormatter()
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
        formatter.dateFormat = "yyyy年MM月dd日"
        //(from: datePicker.date))を指定してあげることで
        //datePickerで指定した日付が表示される
        dateTextFiled.text = "\(formatter.string(from: datePicker.date))"
    }
    
}
//WeScan
extension AddTicketViewController:ImageScannerControllerDelegate {
    //撮り終えた後の処理
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        //結果をcroppedImageに代入
        let croppedImage = results.croppedScan.image // UIImage
        ticketImageView.image = croppedImage
        scanner.dismiss(animated: true)
    }
    //キャンセルされたとき
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    

}
//ライブラリからWeScanに
extension AddTicketViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)

            guard let image = info[.originalImage] as? UIImage else { return }
            //選んだ画像をWeScanに渡す
            let scannerViewController = ImageScannerController(image: image, delegate: self)
            present(scannerViewController, animated: true)
    }
    
}

//PlaceAPI
extension AddTicketViewController: GMSAutocompleteViewControllerDelegate {

    // オートコンプリートで場所が選択した時に呼ばれる関数
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
         // 名前をoutletに設定
        placeNameTextField.text = place.name
        adressTextField.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }

    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}

