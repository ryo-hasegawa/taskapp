//
//  InputViewController.swift
//  taskapp
//
//  Created by HaseMac on 2018/07/24.
//  Copyright © 2018年 ryou.hasegawa. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    var task: Task!   // 追加する
    
    let realm = try! Realm()
    //カテゴリー配列の読み込み
    let arrays = try! Realm().objects(Category.self).sorted(byKeyPath: "id")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        
        
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //categoryPickerdatasourceのプロトコル
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //行数の指定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //空白を表示させるために行数を１増やしておく
        return arrays.count + 1
    }
    //表示する文字列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {return ""}
        
        return arrays[row - 1].category
    }
    //選択された時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    // 入力画面から戻ってきた時に categorypicker を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryPicker.selectRow(task.categoryId, inComponent: 0, animated: false)
        categoryPicker.reloadAllComponents()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //Taskへのデータ渡し部分
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            if arrays.count != 0 {
                let row = categoryPicker.selectedRow(inComponent: 0)
                self.task.categoryId = arrays[row].id
            }
            self.realm.add(self.task, update: true)
            
            setNotification(task: task)   // 追加
        }
        
        super.viewWillDisappear(animated)
    }
    // タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
