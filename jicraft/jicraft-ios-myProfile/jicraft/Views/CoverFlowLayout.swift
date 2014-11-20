//
//   CoverFlowLayout.swift
//  jicraft
//
//  Created by impressly on 14-9-2.
//  Copyright (c) 2014年 com.jicraft. All rights reserved.
//

import Foundation

class CoverFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        // self.scrollDirection = UICollectionViewScrollDirectionHorizontal
        self.minimumLineSpacing = 10000.0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}