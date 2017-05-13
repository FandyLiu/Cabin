//
//  UIViewAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension UIView {
    func screenViewYValue() -> CGFloat {
        var y: CGFloat = 0.0
        var supView: UIView = self
        while let view = supView.superview {
            y += view.frame.origin.y
            if let scrollView = view as? UIScrollView {
                y -= scrollView.contentOffset.y
            }
            supView = view
        }
        return y
    }
    // 得出父 cell
    var superCell: UITableViewCell? {
        var superView: UIView? = self
        while (superView as? UITableViewCell) == nil {
            superView = superView?.superview
            if superView == nil {
                return nil
            }
        }
        return superView as? UITableViewCell
    }
    
}
