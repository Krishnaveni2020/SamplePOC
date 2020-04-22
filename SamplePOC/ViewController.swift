//
//  ViewController.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/19/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var listTableView = UITableView() // view
    var mainData : [MainData] = []
    var dataModelArr : [DataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        httpRequest()
        configureTableView()
        
    }
    
    func configureTableView() {
        
        self.listTableView = UITableView(frame: .zero)
        self.view.addSubview(listTableView)
        listTableView.register(DisplayDataCell.self, forCellReuseIdentifier: "displayDataCell")
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "displayDataCell", for: indexPath) as! DisplayDataCell
        
         cell.contact = self.dataModelArr[indexPath.row]
        return cell
    }
    
   
    private func httpRequest() {
        
        // Create URL
        let url = URL(string: "http://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                let responseStrInISOLatin = String(data: data!, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                   // let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                    //  print("json\(responseJSONDict)")
                    
                    let decoder = JSONDecoder()
                    self.mainData = [try decoder.decode(MainData.self, from: modifiedDataInUTF8Format)] //
                    
                    // print(self.mainData)
                    self.dataModelArr = self.mainData[0].datamodel!
                    
                    print("data\(self.dataModelArr.count)")
                    DispatchQueue.main.async {
                        self.listTableView.reloadData()
                    }
                } catch {
                    print(error)
                }
                
            }
        }).resume()
    }
    
    
}

