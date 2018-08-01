//
//  CategoryViewController.swift
//  taskapp
//
//  Created by HaseMac on 2018/07/29.
//  Copyright © 2018年 ryou.hasegawa. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift


    class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
        
        @IBOutlet weak var categoryField: UITextField!
        @IBOutlet weak var categoryTable: UITableView!
        //カテゴリークラスを取得しておく
        var category = Category()
        let realm = try! Realm()
        // DB内のカテゴリが格納されるリスト。
        var categoryarray = try! Realm().objects(Category.self).sorted(byKeyPath: "id",ascending: false)
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            //テーブルビューのデリゲート
            categoryTable.delegate = self
            categoryTable.dataSource = self
            // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
            self.view.addGestureRecognizer(tapGesture)
        }
        @objc func dismissKeyboard(){
            // キーボードを閉じる
            view.endEditing(true)}
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        //tableviewdatasourceプロトコルのメソッド
        // データの数（＝セルの数）を返すメソッド
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoryarray.count  // ←追加する
        }
        //各セルの内容を返すメソッド
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // 再利用可能な cell を得る
            let cell = tableView.dequeueReusableCell(withIdentifier: "Categorycell", for: indexPath)
            // Cellに値を設定する.
            let category = categoryarray[indexPath.row]
            cell.textLabel?.text = category.category
            self.realm.add(self.category, update: true)
            
            return cell
        }
        
        // MARK: UITableViewDelegateプロトコルのメソッド
    
        // セルが削除が可能なことを伝えるメソッド
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
            return.delete // ←以降追加する
            
        }
    
        //保存が押された時のアクション
        @IBAction func saveButton(_ sender: Any) {
           //テキストフィールドの内容をCategory.swiftに渡す
            try! realm.write {
                self.category.category = categoryField.text!
                self.category.id += 1
                self.realm.add(self.category, update: true)
            }
            //データ渡しテスト
            print(" \(self.category.category)")
          //画面遷移
            
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

