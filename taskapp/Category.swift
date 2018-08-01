//
//  Category.swift
//  taskapp
//
//  Created by HaseMac on 2018/07/30.
//  Copyright © 2018年 ryou.hasegawa. All rights reserved.
//

import Foundation
import RealmSwift
//カテゴリークラスの作成
class Category: Object {
    //idを持たせる
    @objc dynamic var id = 0
    @objc dynamic var category: String = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
}
}
