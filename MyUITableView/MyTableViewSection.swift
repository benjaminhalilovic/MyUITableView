//
//  MyTableViewSection.swift
//  MyUITableView
//
//  Created by mac on 27/02/2018.
//  Copyright © 2018 Benjamin Halilovic. All rights reserved.
//

import UIKit

class MyTableViewSection: NSObject {
    
    //Total amoun of rows
    var rowsHeight: CGFloat = 0
    
    
    var headerHeight: CGFloat = 0
    var footerHeight: CGFloat = 0
    var numberOfRows: NSInteger = 0
    
    //Custom row heights
    var rowHeights: [CGFloat] = []
    var headerView: UIView?
    var footerView: UIView?
    var headerTitle: NSString = ""
    var footerTitle: NSString = ""
    
    var sectionHeight: CGFloat {
        return self.rowsHeight + self.headerHeight + self.footerHeight
    }
    
    func setNumberOfRows(rows: NSInteger, withHeights newRowHeights: [CGFloat]) {
        self.rowHeights = newRowHeights
        self.numberOfRows = rows
    }
    
}
