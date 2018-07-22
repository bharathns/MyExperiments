//
//  PagingSourceType.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 20/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

enum PagingType {
    case initial
    case nextPage
    case refresh

    
    init?(type: Int) {
        switch type {
        case 0:
            self = .initial
        case 1:
            self = .nextPage
        default:
            self = .refresh
        }
    }
}

protocol PagingSourceType: UITableViewDataSource {
    var dataObject: ResultType { get set }
    var conditionForAdding: Bool { get }
    
    func addObjects( objects : [DataType])
    func insertTopRow(tableView: UITableView)
    func deleteRowAtIndexPath(indexPath: IndexPath, from tableView: UITableView)
    func loadNextPage(pagingType: PagingType)
    func willLoadPage()
    func didLoadPage()
}

extension PagingSourceType {
    func insertTopRow(tableView: UITableView) {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    }
    
    func deleteRowAtIndexPath(indexPath: IndexPath, from tableView: UITableView){
        tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    }
    

}
