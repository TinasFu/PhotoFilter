// Playground - noun: a place where people can play

import UIKit


func doSomething<T> (a : T, b : T) {
    println("good")
}

doSomething ("oh", "no")

class Stack <T> {
    var items = [T]()
    
    func push(item : T) {
        self.items.append(item)
    }
    func pop() -> T {
        var itemToPop = self.items.last
        self.items.removeLast()
        return itemToPop!
    }
}

var myStack = Stack<String>()

myStack.push("Chicken")
myStack.push("Pig")
myStack.pop()
myStack.pop()
myStack


class Node<T> {
    var value: T?
    var next : Node?
}

class LinkedList <T : Equatable> {
    var head: Node<T>?
    
    // insert node with given value from the back of the list
    func insertBack(value:T) -> LinkedList<T> {
        if head == nil {
            var node = Node<T>()
            node.value = value
            node.next = nil
            head = node
            
            //return breaks the function
            return self;
        }

        var currentNode = head
        while currentNode?.next != nil {
            currentNode = currentNode?.next
        }
        
        var node = Node<T>()
        node.value = value
        node.next = nil
        currentNode?.next = node
        
        return self;
    }
    
    // insert node with given value from the front of the list
    func insertFront(value: T) {
        if head == nil {
            var node = Node<T>()
            node.value = value
           // node.next = nil
            head = node
            //return
        }
        else {
            var node = Node<T>()
            node.value = value
            node.next = head
            head = node
        }
    }
    
    
    // Delete nodes with given value, return an integer showing how many nodes have been deleted
    func delete(value : T) -> Int {
        if head == nil {
            return 0
        }
        
        var deleteCount = 0
        var prev = head
        var next : Node<T>? = prev?.next
        
        while prev != nil {
            if head?.value == value {
                head = next
                prev = head
                next = prev?.next
                deleteCount += 1
            }
            else if next?.value == value {
                prev?.next = next?.next
                next = prev?.next
                deleteCount += 1
            }
            else {
                prev = next
                next = prev?.next
            }
        }
        
        return deleteCount
    }
    
    func printAll() {
        var curr = head;
        while (curr != nil) {
            print("\(curr?.value)")
            curr = curr?.next
        }
    }
    
}

var list: LinkedList<Int> = LinkedList<Int>()
list.insertBack(4)
    .insertBack(4)
    .insertBack(3)
    .insertBack(4)
    .insertBack(3)
    .insertBack(2)

list.delete(2)

list.printAll()

 






