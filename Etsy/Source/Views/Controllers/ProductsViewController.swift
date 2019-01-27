//
//  ProductsViewController.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class ProductsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let numberOfColumnsInPortrait = 2
    let numberOfColumnsInLandscape = 3
    let spacing = CGFloat(10.0)
    
    var isSearching = false
    
    fileprivate var viewModel = ProductsViewModel()
    
    private var leftBarButtonItem: UIBarButtonItem?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        loadProductsIfNeeded()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isSearching {
            viewModel.fetchProducts()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productViewController = segue.destination as? ProductViewController {
            productViewController.isSearching = isSearching
            productViewController.transfer(product: viewModel.selectedProduct)
        }
    }
    
    // MARK: - Configuration
    
    func transfer(parameters: Any) {
        viewModel.receive(parameters)
    }
    
    private func bindViewModel() {
        viewModel.productsDidFetch = { [unowned self] in
            self.navigationItem.rightBarButtonItem?.isEnabled = !self.viewModel.products.isEmpty
            self.collectionView?.reloadData()
        }
        
        viewModel.productsDidLoad = { [unowned self] insertingIndexPaths in
            self.collectionView?.refreshControl = UIRefreshControl()
            self.collectionView?.refreshControl?.addTarget(self,
                                                           action: #selector(self.reloadProducts),
                                                           for: .valueChanged)
            
            self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: insertingIndexPaths)
            }, completion: nil)
            
        }
        
        viewModel.nextProductsDidLoad = { [unowned self] insertingIndexPaths in
            self.collectionView?.performBatchUpdates({
                self.collectionView?.insertItems(at: insertingIndexPaths)
            }, completion: nil)
            
        }
        
        viewModel.productsDidReload = { [unowned self] (insertingIndexPaths, deletingIndexPaths) in
            self.collectionView?.refreshControl?.endRefreshing()
            
            self.collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: deletingIndexPaths)
                self.collectionView?.insertItems(at: insertingIndexPaths)
            }, completion: nil)
        }
        
        viewModel.productsDidDelete = { [unowned self] deletingIndexPaths in
            if self.collectionView?.allowsMultipleSelection == true {
                self.collectionView?.allowsMultipleSelection = false
            } else {
                self.collectionView?.allowsMultipleSelection = true
            }
            
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem?.title = NSLocalizedString("Select", comment: "")
            self.navigationItem.rightBarButtonItem?.style = .plain
            self.navigationItem.rightBarButtonItem?.isEnabled = self.viewModel.products.count > 0
            
             self.collectionView?.performBatchUpdates({
                self.collectionView?.deleteItems(at: deletingIndexPaths)
             }, completion: nil)
        }
    }
    
    private func loadProductsIfNeeded() {
        if isSearching {
            viewModel.loadProducts()
        }
    }
    
    private func configureNavigationBar() {
        if isSearching {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        } else {
            leftBarButtonItem = navigationItem.leftBarButtonItem
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    private func configureEditing() {
        collectionView?.allowsMultipleSelection = collectionView?.allowsMultipleSelection == true ? false : true
        
        if collectionView?.allowsMultipleSelection == true {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Cancel", comment: "")
            navigationItem.rightBarButtonItem?.style = .done
            navigationItem.leftBarButtonItem = leftBarButtonItem
        } else {
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Select", comment: "")
            navigationItem.rightBarButtonItem?.style = .plain
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem = nil
            
            viewModel.deselectAllProducts()
            
            collectionView?.reloadData()
        }
    }
    
    private func presentDeleteAlert() {
        let deleteActionHandler: (UIAlertAction) -> Void = { _ in
            self.viewModel.deleteSelectedProducts()
        }
        
        let deleteAlerController = AlertService.deleteAlert(withNumberOfProducts: viewModel.numberOfSelectedProducts,
                                                            deleteActionHandler: deleteActionHandler)
        
        present(deleteAlerController, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func deleteButtonDidPressed(_ sender: UIBarButtonItem) {
        presentDeleteAlert()
    }
    
    @IBAction func editingButtonDidPressed(_ sender: UIBarButtonItem) {
        configureEditing()
    }
    
    @objc func reloadProducts() {
        viewModel.reloadProducts()
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.productCell,
                                                      for: indexPath)
        
        if let cell = cell as? ImageCollectionViewCell {
            let product = viewModel.products[indexPath.row]

            cell.imageView.setImage(withUrlString: product.imageUrlString)
            cell.textLabel.text = product.title
            cell.selectedView.isHidden = !viewModel.isSelectedProduct(atIndex: indexPath.row)
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectProduct(atIndex: indexPath.row)
        
        if collectionView.allowsMultipleSelection {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                cell.selectedView.isHidden = false
            }
            
            navigationItem.leftBarButtonItem?.isEnabled = viewModel.numberOfSelectedProducts > 0
        } else {
            performSegue(withIdentifier: Constants.SegueIdentifiers.toProduct, sender: self)
            
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            viewModel.deselectProduct(atIndex: indexPath.row)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
                cell.selectedView.isHidden = true
            }
            
            navigationItem.leftBarButtonItem?.isEnabled = viewModel.numberOfSelectedProducts > 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
    
        if isSearching && indexPath.row == viewModel.products.count - SearchParameters.pageLimit {
            viewModel.loadNextProductsIfCan()
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let orientation = UIDevice.current.orientation
        var numberOfColumns: CGFloat!
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            numberOfColumns = CGFloat(numberOfColumnsInLandscape)
        } else {
            numberOfColumns = CGFloat(numberOfColumnsInPortrait)
        }
        
        let spacing = (numberOfColumns + 1) * self.spacing
        let side = (view.bounds.size.width - spacing)  / numberOfColumns
        return CGSize(width: side, height: side)
    }
}
