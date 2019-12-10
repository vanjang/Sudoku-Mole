//
//  ExpertViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/14.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class ExpertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in views {
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.borderWidth = 0
        }
        let empty = [Record(record: "", recordInSecond: 0, isNew: false)]
        
        if let records = Record.loadRecord(forKey: "Expert") {
            self.records = records
        } else {
            self.records = empty
        }
        loadRecords()
        expertRecordsView.backgroundColor = .clear
        expertTableView.delegate = self
        expertTableView.dataSource = self
        gridView.clipsToBounds = true
        gridView.layer.borderColor = UIColor.clear.cgColor
        gridView.layer.borderWidth = 0
        gridView.layer.cornerRadius = 13.8
        views[0].layer.cornerRadius = 17
        views[1].layer.cornerRadius = 19
        shadow.layer.cornerRadius = 4
        self.view.bringSubviewToFront(gridView)
    }
    
    override func viewDidLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadRecords),name:NSNotification.Name(rawValue: "recordsRefresher"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
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
    
    @objc func loadRecords() {
        let empty = [Record(record: "", recordInSecond: 0, isNew: false)]
        if let records = Record.loadRecord(forKey: "Expert") {
            self.records = records
        } else {
            self.records = empty
        }
        
        if records![0].record == "" {
            noRecordImageView.image = noRecordImage
            noRecordImageView.contentMode = .scaleAspectFit
        } else {
            noRecordImageView.isHidden = true
        }
        
        expertTableView.reloadData()
    }
    
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var expertRecordsView: UIView!
    @IBOutlet var views: [UIView]!
    @IBOutlet weak var expertTableView: UITableView!
    @IBOutlet weak var noRecordImageView: UIImageView!
    
    let noRecordImage = UIImage(named: "boardNoRecord.png")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var records: [Record]?
}
