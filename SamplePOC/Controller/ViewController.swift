//
//  ViewController.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/19/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    var listTableView = UITableView()
    // MARK: - Class Varibles
    var viewModel = ViewModel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
    }
    
    // MARK: - Initial page settings
    func pageSetup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.configureTableView()
            // API calling from viewmodel class
           self.viewModel.getServicecall()
            self.closureSetUp()
        }
    }
    // MARK: - Configure tableview
    func configureTableView() {
        
        self.listTableView = UITableView(frame: .zero)
        self.view.addSubview(listTableView)
        listTableView.register(DisplayDataCell.self, forCellReuseIdentifier: "displayDataCell")
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.bottom.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    // MARK: - Closure initialize
    func closureSetUp() {
        viewModel.reloadList = { [weak self] ()  in
            ///UI chnages in main tread
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
        viewModel.errorMessage = { [weak self] (message)  in
            DispatchQueue.main.async {
                // display error ?
                let controller = UIAlertController(title: "An error occured", message: message, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }
    
}
// MARK: - TableView Delegate Datasource Methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "displayDataCell") as? DisplayDataCell)!
        
        cell.list = viewModel.dataModelArr[indexPath.row]
        
        return cell
    }
}
