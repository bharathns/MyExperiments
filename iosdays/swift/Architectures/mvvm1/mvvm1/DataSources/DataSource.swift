//
//  DataSource.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 20/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

let kDataSourceManagerMaximumItemsPerPage : Int = 20

class DataSource: NSObject, PagingSourceType {
    var dataObject: ResultType
    var lockLoading : Bool = false
    var conditionForAdding: Bool {
        return false
    }
    
    init<A: ResultType>(dataObject: A) {
        self.dataObject = dataObject
    }

    func addObjects( objects : [DataType]) {
        self.dataObject = self.dataObject.addObjects(objects: objects)
        
    }
    
    func addItemTo(tableView: UITableView){
        if conditionForAdding {
            //dataObject = dataObject.addNewItemAtIndex(0)
            insertTopRow(tableView: tableView)
        }
    }

    func insertTopRow(tableView: UITableView) {
        
    }
    
    func deleteRowAtIndexPath(indexPath: IndexPath, from tableView: UITableView) {
        
    }
    
    func loadNextPage(pagingType: PagingType) {
        fatalError("This method must be overwritten")
    }
    
    func didLoadPage() {
        fatalError("This method must be overwritten")
    }
    func willLoadPage() {
        fatalError("This method must be overwritten")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataObject.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("This method must be overwritten")

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataObject = dataObject.deleteItemAtIndex(index: indexPath.row)
            self.deleteRowAtIndexPath(indexPath: indexPath as IndexPath, from: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        dataObject = dataObject.moveItem(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row)
    }
    
}
