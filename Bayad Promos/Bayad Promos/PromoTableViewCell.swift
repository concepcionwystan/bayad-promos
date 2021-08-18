//
//  PromoTableViewCell.swift
//  Bayad Promos
//
//  Created by Application Developer 9 on 8/18/21.
//

import UIKit

class PromoTableViewCell: UITableViewCell {

    // MARK:Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // MARK:Images
    @IBOutlet weak var unreadImage: UIImageView!
    
    // MARK:Views
    @IBOutlet weak var bgView: UIView!
    
    // MARK:Update Layout
    func setPromo(promo: Promo){
        nameLabel.text = promo.name
        detailsLabel.text = promo.details
        if(promo.read == 1){
            unreadImage.isHidden = true
            bgView.backgroundColor = UIColor.white
        } else {
            unreadImage.isHidden = false
            bgView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.7333333333, blue: 0.768627451, alpha: 0.17)
        }
    }

}
