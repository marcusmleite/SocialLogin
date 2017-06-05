//
//  FancyLGBtn.swift
//  omaLogin
//
//  Created by Rodrigo Vianna on 05/06/17.
//  Copyright © 2017 Rodrigo Vianna. All rights reserved.
//

import UIKit

class FancyLGBtn: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.init(red: SHADOW_GRAY , green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
}
