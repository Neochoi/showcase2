//
//  materialButton.swift
//  showCase
//
//  Created by 蔡智斌 on 16/5/20.
//  Copyright © 2016年 NeoChoi. All rights reserved.
//

import UIKit

class materialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
