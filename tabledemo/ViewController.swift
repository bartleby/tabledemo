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
    var isCategory: Bool
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: [ServicesDataSource] = []
    private var expandedCellIndeces: [IndexPath] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createTestDataSource()
    }
    
    private func createTestDataSource() {
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 1", isCategory: true))
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 2", isCategory: true))
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 3", isCategory: true))
        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 4", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 5", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 6", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 7", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 8", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 9", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 10", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 11", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 12", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 13", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 14", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 15", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 16", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 17", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 18", isCategory: true))
//        dataSource.append(ServicesDataSource(type: .header, isOpen: false, category: "Category 19", isCategory: true))
        
        tableView.reloadData()
    }
    
    private func addCellTo(index: Int) {
        let serviceSource = dataSource[index]
        let categoryServices = ServicesDataSource(type: .row, isOpen: true, category: serviceSource.category, isCategory: false)
        dataSource.insert(categoryServices, at: index + 1)
        let indexPath = IndexPath(row: index + 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        expandedCellIndeces.append(indexPath)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func removeCellFrom(index: Int) {
        if index < dataSource.count - 1 && dataSource[index + 1].type == .row {
            let indexPath = IndexPath(row: index + 1, section: 0)
            tableView.performBatchUpdates {
                expandedCellIndeces.removeAll(where: {$0 == indexPath})
            } completion: { [weak self] _ in
                self?.dataSource.remove(at: index + 1)
                self?.tableView.deleteRows(at: [indexPath], with: .top)
            }
        }
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
        if dataSource[indexPath.row].isCategory {
            return 50
        }
        
        if expandedCellIndeces.contains(indexPath) {
            return 300
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
