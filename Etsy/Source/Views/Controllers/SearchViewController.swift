//
//  SearchViewController.swift
//  Etsy
//
//  Created by Radislav Crechet on 4/7/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var keyworkTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!

    private var viewModel = SearchViewModel()

    private enum SearchRowType: Int {
        case keyword, category
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configurePickerView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productsViewController = segue.destination as? ProductsViewController {
            productsViewController.isSearching = true
            productsViewController.transfer(parameters: viewModel.parameters)
        }
    }
    
    // MARK: - Configuration
    
    private func bindViewModel() {
        viewModel.categoriesDidChange = { [unowned self] in
            self.categoryTextField.text = self.viewModel.categories.first
        }
    }
    
    private func configurePickerView() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        categoryTextField.inputView = pickerView
    }

    // MARK: - Actions
    
    @IBAction func submitButtonDidPressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        performSegue(withIdentifier: Constants.SegueIdentifiers.toProducts, sender: self)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.setKeyword(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryTextField.becomeFirstResponder()
        return true
    }

    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.categories[row]
    }

    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = viewModel.categories[row]
        viewModel.selectCategory(atIndex: row)
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == SearchRowType.keyword.rawValue {
            keyworkTextField.becomeFirstResponder()
        } else {
            categoryTextField.becomeFirstResponder()
        }
    }
}
