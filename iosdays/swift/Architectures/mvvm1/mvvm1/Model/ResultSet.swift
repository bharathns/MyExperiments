//
//  ResultSet.swift
//  mvvm1
//
//  Created by Bharath Nadampalli on 20/08/17.
//  Copyright © 2017 com.samples. All rights reserved.
//

import UIKit

protocol DataType {
    init()
}

protocol ResultType {
    init()
    var numberOfItems: Int{ get }
    var currentPage: Int { get }
    subscript(index: Int) -> DataType {get}
    func addObjects(objects: [DataType]) -> Self
    func addNewItemAtIndex(index: Int) -> Self
    func deleteItemAtIndex(index: Int) -> Self
    func moveItem(fromIndex: Int, toIndex: Int) -> Self
}

struct ResultSet<T> : ResultType where T : DataType {

    func addNewItemAtIndex(index: Int) -> ResultSet {
            return insertItem(item: T(), atIndex: index)
    }

    private var items: [DataType] = []
    
    var numberOfItems: Int {
        return items.count
    }
    
    var currentPage: Int  {
        return (items.count / kDataSourceManagerMaximumItemsPerPage) + 1
    }

    subscript(index: Int) -> DataType {
        get {
            return items[index]
        }
    }
    
    
    private func insertItem(item: T, atIndex index: Int) -> ResultSet {
        var mutableCards = items
        mutableCards.insert(item, at: index)
        return ResultSet<T>(items: mutableCards)
    }
    
    func addObjects(objects: [DataType]) -> ResultSet<T> {
        var mutableCards = items
        mutableCards.append(contentsOf: objects)
        return ResultSet<T>(items: mutableCards)
    }

    func deleteItemAtIndex(index: Int) -> ResultSet {
        var mutableCards = items
        mutableCards.remove(at: index)
        return ResultSet<T>(items: mutableCards)
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) -> ResultSet {
        return self
        //return deleteItemAtIndex(index: fromIndex)
         //   .insertItem(item: items[fromIndex], atIndex: toIndex)
    }
}
