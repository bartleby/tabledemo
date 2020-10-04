//
//  CategoryTableViewCell.swift
//  tabledemo
//
//  Created by Андрей М on 04.10.2020.
//

import UIKit

protocol CategoryChangeStateDelegate: class {
    func shouldChangeState(isOpen: Bool, category: String)
}

class CategoryTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    private var mainImageUrl: URL?
    private var isOpen: Bool = false
    private var category: String!
    
    private weak var delegate: CategoryChangeStateDelegate?
    
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(delegate: CategoryChangeStateDelegate, data model: ServicesDataSource) {
        titleLabel.text = model.category
        isOpen = model.isOpen
        self.delegate = delegate
        self.category = model.category
        arrowImageView.transform = isOpen ? CGAffineTransform(rotationAngle: .pi / 2) : CGAffineTransform.identity
    }
    
    //MARK: - IBAction
    @IBAction func changeStateButtonAction() {
        isOpen = !isOpen
        UIView.animate(withDuration: 0.2, animations: {
            self.arrowImageView.transform = self.isOpen ? CGAffineTransform(rotationAngle: .pi / 2) : CGAffineTransform.identity
        })
        delegate?.shouldChangeState(isOpen: isOpen,
                                    category: category)
    }
}

