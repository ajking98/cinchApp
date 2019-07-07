//
//  SecondProfileHeader.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/24/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class SecondProfileHeader: UIView {

    @IBOutlet weak var secondTopView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SecondProfileHeader", owner: self, options: nil)
        addSubview(secondTopView)
        secondTopView.frame = self.bounds
        secondTopView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
