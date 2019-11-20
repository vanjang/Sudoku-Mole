//
//  GameSolvedTableViewCell.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/17.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class GameSolvedTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var numberLabel: InsetLabel!
    @IBOutlet weak var recordsLabel: InsetLabel!
    
    func cellUpdate(records: [Record], indexPath: IndexPath) {
        
        var number = 1
        var numbers = [String]()
        
        for _ in records {
            numbers.append("\(number).")
            number += 1
        }
        
        var size = CGFloat()
        
        if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 7" {
            size = 28
        } else {
            size = 30
        }
        
        let font = UIFont(name: "LuckiestGuy-Regular", size: size)
        
        numberLabel.font = font
        recordsLabel.font = font
        
        numberLabel.backgroundColor = .clear
        recordsLabel.backgroundColor = .clear
        numberLabel.adjustsFontSizeToFitWidth = true
        recordsLabel.adjustsFontSizeToFitWidth = true
        numberLabel.sizeToFit()
        recordsLabel.sizeToFit()
        
        numberLabel.text = numbers[indexPath.row]
        recordsLabel.text = records[indexPath.row].record
        
        if records[indexPath.row].isNew {
            numberLabel.textColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
            recordsLabel.textColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
        } else {
            numberLabel.textColor = #colorLiteral(red: 1, green: 0.7889312506, blue: 0.7353969216, alpha: 1)
            recordsLabel.textColor = #colorLiteral(red: 1, green: 0.7889312506, blue: 0.7353969216, alpha: 1)
        }
    }
    
}
