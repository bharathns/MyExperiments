//
//  CabinetDataSource.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 21/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

let kActivityIndicatorCellIdentifier  = "ActivityIndicatorTableViewCellID"
class DriverDataSource: DataSource {

    var drivers : [Driver?] = [Driver] ()
    var tableView : UITableView? = nil
    var currentPagingType : PagingType = .initial
    init(tv: UITableView) {
        super.init(dataObject: ResultSet<Driver>())
        self.tableView = tv
    }
    
    func loadPage(page: Int, limit: Int) {
        self.drivers.removeAll()
        //self.tableView.reloadData()
        print("loading.. limit: \(limit) : offset : \((page-1)*limit) ")
        Formula1Service.drivers(page: page, limit: limit) { [weak self](response, error) in
            if let urlContent: Data = response as? Data, let _ = String.init(data: urlContent, encoding: .utf8) {
                do {
                    self?.lockLoading = false
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:
                        JSONSerialization.ReadingOptions.mutableContainers)
                    
                    //print(jsonResult) //this part works fine
                    if let jsonResult  =  jsonResult as? [String: Any],let mrData  = jsonResult["MRData"] as? [String: Any], let driverTable  =  mrData["DriverTable"] as? [String: Any], let drivers: JSONArray = driverTable["Drivers"] as? JSONArray {
                        for driver in drivers {
                            print("\(String(describing: driver["givenName"]))")
                            if let givenName : String  = driver["givenName"] as? String, let familyName: String =  driver["familyName"] as? String {
                                self?.drivers.append(Driver(name: givenName, familyName: familyName))
                            }
                        }
                        if let objects : [DataType] = self?.drivers as? [DataType] {
                            self?.addObjects(objects: objects)
                        }
                    }
                } catch {
                    print("JSON Processing Failed")
                }
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            }
        }
    }
    
    override func loadNextPage(pagingType: PagingType) {
        guard lockLoading == false  else { return }
        currentPagingType = pagingType
        let page : Int  = self.dataObject.currentPage
        
        self.loadPage(page: page, limit: kDataSourceManagerMaximumItemsPerPage)
        

    }
    
    override func willLoadPage() {
        self.lockLoading = false
        self.tableView?.isUserInteractionEnabled = false
    }
    
    override func didLoadPage() {
        self.lockLoading = true
        self.tableView?.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= self.dataObject.numberOfItems-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kActivityIndicatorCellIdentifier, for: indexPath)
            cell.separatorInset = UIEdgeInsetsMake(0, CGFloat.greatestFiniteMagnitude, 0, 0)
            
            if let cell = cell as? ActivityTableViewCell {
                cell.activityIndicator.stopAnimating()
            }
            loadNextPage(pagingType: .nextPage)
            
            return cell
        }
        guard let model : DataType = self.dataObject[indexPath.row] as? DataType , let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellView") as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.fillCell(driver: model)
        return cell
    }
}
