//
//  LinkedList.swift
//  BookWay
//
//  Created by Dmitriy Lupych on 17.01.2024.
//

import Foundation

//MARK: - Doubly Linked List

class Node<T: Equatable> {
    var value: T
    var next: Node<T>?
    var prev: Node<T>? // should be weak, not retained in struct based SwiftUI properly

    init(_ value: T) {
        self.value = value
    }

    func push(_ element: T) {
        let _lastNode = lastNode
        let newNode = Node(element)
        _lastNode?.next = newNode
        newNode.prev = _lastNode
    }

    var lastNode: Node<T>? {
        var node: Node<T>? = self
        while node?.next != nil {
            node = node?.next
        }
        return node
    }

    func node(_ element: T) -> Node<T>? {
        var node: Node<T>? = self
        while node?.value != element || node?.next != nil {
            node = node?.next
        }
        return node
    }
}

extension Node: Equatable {
    static func == (lhs: Node<T>, rhs: Node<T>) -> Bool {
        lhs.value == rhs.value
    }
}

extension Node {
    static func create(from array: [T]) -> Node<T>? {
        guard !array.isEmpty else { return nil }

        let firstNode = array.first.map { Node($0) }
        array.dropFirst().forEach { firstNode?.push($0) }
        
        return firstNode
    }
}
