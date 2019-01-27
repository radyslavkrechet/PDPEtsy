//
//  ProductViewController.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class ProductViewController: UITableViewController {
    @IBOutlet var headerView: ImageHeaderView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    let estimatedRowHeight = CGFloat(44.0)
    
    var isSearching = false
    
    private var viewModel = ProductViewModel()
    private var rightBarButtonItem: UIBarButtonItem?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isSearching && !viewModel.isAddedProduct {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    // MARK: - Configuration
    
    func transfer(product: Any) {
        viewModel.receive(product)
    }
    
    private func configureNavigationBar() {
        if isSearching {
            rightBarButtonItem = navigationItem.rightBarButtonItem
            
            if viewModel.isAddedProduct {
                navigationItem.rightBarButtonItem = nil
            }
        } else {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Delete", comment: "")
        }
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        
        headerView.imageView.setImage(withUrlString: viewModel.product.imageUrlString)
        nameLabel.text = viewModel.product.name
        priceLabel.text = viewModel.product.price
        detailLabel.text = viewModel.product.detail
    }
    
    private func presentDeleteAlert() {
        let deleteActionHandler: (UIAlertAction) -> Void = { _ in
            self.viewModel.deleteProduct()
            
            self.navigationController?.popViewController(animated: true)
        }
        
        let deleteAlerController = AlertService.deleteAlert(withNumberOfProducts: 0,
                                                            deleteActionHandler: deleteActionHandler)
        
        present(deleteAlerController, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func editingButtonDidPressed(_ sender: UIBarButtonItem) {
        if isSearching {
            viewModel.addProduct()
            
            navigationItem.rightBarButtonItem = nil
        } else {
            presentDeleteAlert()
        }
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
