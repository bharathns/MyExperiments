import Foundation



public struct Heap<T> {
    var nodes = [T]()
    
    
    private var orderCriteria: (T, T) -> Bool
    
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    public mutating func configureHeap(from: [T]) {
        nodes = from
        for i in stride(from: (nodes.count/2-1), to: 0, by: -1) {
            shiftDown (i)
        }
    }
    
    public var isEmpty: Bool {
       return nodes.isEmpty
     }
     
    public var count: Int {
       return nodes.count
    }
    
    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 1
    }
    
    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 2
    }
    
    public func peek() -> T? {
       return nodes.first
    }
    
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
          insert(value)
        }
    }
    
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else { return }
        
        remove(at: i)
        insert(value)
    }
    
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        // Figure out which comes first if we order them by the sort function:
        // the parent, the left child, or the right child. If the parent comes
        // first, we're done. If not, that element is out-of-place and we make
        // it "float down" the tree until the heap property is restored.
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
          first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
          first = rightChildIndex
        }
        if first == index { return }
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
      
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
          nodes[childIndex] = nodes[parentIndex]
          childIndex = parentIndex
          parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        nodes[childIndex] = child
    }
    
    @discardableResult public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        
        if nodes.count == 1 {
          return nodes.removeLast()
        } else {
          // Use the last node to replace the first one, then fix the heap by
          // shifting this new first node into its proper position.
          let value = nodes[0]
          nodes[0] = nodes.removeLast()
          shiftDown(0)
          return value
        }
    }
    
    @discardableResult public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        
        let size = nodes.count - 1
        if index != size {
          nodes.swapAt(index, size)
          shiftDown(from: index, until: size)
          shiftUp(index)
        }
        return nodes.removeLast()
    }
}

extension Heap where T: Equatable {
  
  /** Get the index of a node in the heap. Performance: O(n). */
  public func index(of node: T) -> Int? {
    return nodes.index(where: { $0 == node })
  }
  
  /** Removes the first occurrence of a node from the heap. Performance: O(n). */
  @discardableResult public mutating func remove(node: T) -> T? {
    if let index = index(of: node) {
      return remove(at: index)
    }
    return nil
  }
  
}

public struct PriorityQueue<T> {
  fileprivate var heap: Heap<T>

  /*
    To create a max-priority queue, supply a > sort function. For a min-priority
    queue, use <.
  */
  public init(sort: @escaping (T, T) -> Bool) {
    heap = Heap(sort: sort)
  }

  public var isEmpty: Bool {
    return heap.isEmpty
  }

  public var count: Int {
    return heap.count
  }

  public func peek() -> T? {
    return heap.peek()
  }

  public mutating func enqueue(_ element: T) {
    heap.insert(element)
  }

  public mutating func dequeue() -> T? {
    return heap.remove()
  }

  /*
    Allows you to change the priority of an element. In a max-priority queue,
    the new priority should be larger than the old one; in a min-priority queue
    it should be smaller.
  */
  public mutating func changePriority(index i: Int, value: T) {
    return heap.replace(index: i, value: value)
  }
}

extension PriorityQueue where T: Equatable {
  public func index(of element: T) -> Int? {
    return heap.index(of: element)
  }
}

let array = [1,5,6,8,9,7,3]
let maxheap = Heap<Int>(array: array, sort: >)
print(maxheap.nodes)

let heap = Heap<Int>(array: array, sort: <)
print(heap.nodes)


