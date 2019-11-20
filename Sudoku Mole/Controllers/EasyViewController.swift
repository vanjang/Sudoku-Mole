//
//  EasyViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/14.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

class EasyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in views {
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.borderWidth = 0
        }
        let empty = [Record(record: "", recordInSecond: 0, isNew: false)]

        if let records = Record.loadRecord(forKey: "Easy") {
            self.records = records
        } else {
            self.records = empty
        }
        
        easyRecordsView.backgroundColor = .clear
        easyTableView.delegate = self
        easyTableView.dataSource = self
        gridView.clipsToBounds = true
        gridView.layer.borderColor = UIColor.clear.cgColor
        gridView.layer.borderWidth = 0
        gridView.layer.cornerRadius = 13.8
        views[0].layer.cornerRadius = 17
        views[1].layer.cornerRadius = 19
        shadow.layer.cornerRadius = 4
        self.view.bringSubviewToFront(gridView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordsTableViewCell
        cell.backgroundColor = .clear
        cell.cellUpdate(records: records!, indexPath: indexPath)
        return cell
    }
    
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var easyRecordsView: UIView!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var easyTableView: UITableView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var records: [Record]?
}
