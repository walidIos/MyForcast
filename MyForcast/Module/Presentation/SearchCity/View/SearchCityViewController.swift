//
//  SearchCityViewController.swift
//  MyForcast
//
//  Created by walid on 25/9/2022.
//

import UIKit
protocol SearchCityViewControlerDelegate: AnyObject {
    func onSelectItemCity(city: ResultCity)
}
class SearchCityViewController: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mTextFieldSearch: UITextField!
    
    weak var delegate: SearchCityViewControlerDelegate?
    
    var viewModel : SearchCityViewModel?
    
    convenience init(viewModel: SearchCityViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    var timer: Timer?
    var searchValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTableView()
        self.initTextField()
    }
    
    /*
     This function will init tableView
    */
    func initTableView() {
        self.mTableView.register(CityItemCell.nib(), forCellReuseIdentifier: CityItemCell.nibName)
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
    }
    
    /*
     This function to initialize textField actions
     */
    func initTextField() {
        self.mTextFieldSearch.delegate = self
        self.mTextFieldSearch.addTarget(self,
                                           action: #selector(textFieldEditingDidChange(_:)),
                                           for: .editingChanged)
    }
}

/*
 This extension will handle tableView's rows
 */
extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.getListCitiesItems().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let mCell = tableView.dequeueReusableCell(withIdentifier: CityItemCell.nibName, for: indexPath) as? CityItemCell {
            if let model = self.viewModel?.getItemAtIndexOf(index: indexPath.row) {
                mCell.delegate = self
                mCell.initView(model: model)
            }
            return mCell
        }
        return UITableViewCell()
    }
}

/*
 This extension will handle the cell's actions
 */
extension SearchCityViewController: CityItemCellDelegate {
    func onClickItemCell(model: ResultCity?) {
        guard model != nil else {
            return
        }
        self.delegate?.onSelectItemCity(city: model!)
        self.dismiss(animated: true)
    }
}

/*
    This extension is to handle the TextField's changes
 */
extension SearchCityViewController: UITextFieldDelegate {

    /*
     This function is used to handle textChanging
     */
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        if let textField = sender as? UITextField {
            let value = textField.text ?? ""
            timer?.invalidate()
            self.searchValue = value
            timer = Timer.scheduledTimer(timeInterval: 0.5,
                                         target: self,
                                         selector: #selector(searchForKeyDelayed),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    /*
     This function will be executed after delay (0.5 seconds) of the last character written
     */
    @objc func searchForKeyDelayed() {
        self.viewModel?.searchForCityByName(value: self.searchValue, completion: {
            DispatchQueue.main.async {
                self.mTableView.reloadData()
            }
        })
    }
    
}
