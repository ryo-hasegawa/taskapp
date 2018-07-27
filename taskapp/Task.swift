//
//  Task.swift
//  taskapp
//
//  Created by HaseMac on 2018/07/25.
//  Copyright © 2018年 ryou.hasegawa. All rights reserved.
//
    import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    //カテゴリ 2018/07/26課題制作にて追加
    @objc dynamic var category = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
