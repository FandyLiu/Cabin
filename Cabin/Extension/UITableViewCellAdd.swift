//
//  UITableViewCellAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

// cell 扩展两个属性 一个是 当前indexpath 另一个是高度(高度好像是)
extension UITableViewCell {
    
    private static var currentIndexPath = "currentIndexPath"
    private static var cellHeight = "cellHeight"
    
    
    var currentIndexPath: IndexPath? {
        set {
            objc_setAssociatedObject(self, &UITableViewCell.currentIndexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
        
        get {
            return objc_getAssociatedObject(self, &UITableViewCell.currentIndexPath) as? IndexPath
        }
    }
    
    var cellHeight: CGFloat? {
        set {
            objc_setAssociatedObject(self, &UITableViewCell.cellHeight, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
        }
        
        get {
            return objc_getAssociatedObject(self, &UITableViewCell.cellHeight) as? CGFloat
        }
    }
    
}

