//
//  ViewController.swift
//  tabledemo
//
//  Created by Андрей М on 04.10.2020.
//

import UIKit

enum ServicesTableType {
    case header
    case row
}

protocol ServiceDelegate: class {
    func onServiceSelected()
}

struct ServicesDataSource {
    var type: ServicesTableType
    var isOpen: Bool
    var category: String
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: [ServicesDataSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createTestDataSource()
    }
    
    private func createTestDataSource() {
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 1"))
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 2"))
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 3"))
        tableView.reloadData()
    }
    
    private func addCellTo(index: Int) {
        let serviceSource = dataSource[index]
        let categoryServices = ServicesDataSource(type: .row, isOpen: true, category: serviceSource.category)
        dataSource.insert(categoryServices, at: index + 1)
        let indexPath = IndexPath(row: index + 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
    }
    
    private func removeCellFrom(index: Int) {
        tableView.beginUpdates()
        if index < dataSource.count - 1 && dataSource[index + 1].type == .row {
            dataSource.remove(at: index + 1)
            tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .top)
        }
        tableView.endUpdates()
    }
}

// MARK: - UITableView delegate and data source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell: UITableViewCell
        switch item.type {
        case .header:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.className) as! CategoryTableViewCell
            headerCell.configure(delegate: self, data: item)
            cell = headerCell
        case .row:
            cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


// MARK: - CategoryHeaderChangeStateDelegate
extension ViewController: CategoryChangeStateDelegate {
    func shouldChangeState(isOpen: Bool, category: String) {
        if let index = dataSource.firstIndex(where: {$0.category == category && $0.type == .header}) {
            dataSource[index].isOpen = isOpen
            if isOpen {
                addCellTo(index: index)
            } else {
                removeCellFrom(index: index)
            }
        }
    }
}
