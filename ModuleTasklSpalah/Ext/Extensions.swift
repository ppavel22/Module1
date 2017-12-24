//
//  Extensions.swift
//  ModuleTasklSpalah
//
//  Created by mac on 17.12.2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let ContactDeleted = Notification.Name("ContactDeleted")
    static let ContactChanged = Notification.Name("ContactChanged")
    static let ContactAdded = Notification.Name("ContactAdded")
}

extension UIView {
    func circleView() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
    }
}
