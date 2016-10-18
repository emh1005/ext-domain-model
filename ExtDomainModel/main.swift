//
//  main.swift
//  ExtDomainModel
//
//  Created by studentuser on 10/16/16.
//  Copyright © 2016 emh. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//


protocol Mathematics {
        static func +(lhs: Self, rhs: Self) -> Self
        static func -(lhs: Self, rhs: Self) -> Self
}

extension Double {
    var CAN : Money {
        return Money(amount: Int(self), currency: "CAN")
    }
    var EUR : Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP : Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var USD : Money {
        return Money(amount: Int(self), currency: "USD")
    }
}

public struct Money : CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    private let exchangeRate : [String : Double] = ["USD" : 1, "EUR" : 1.5, "CAN" : 1.25, "GBP" : 0.5]
    
    public func convert(_ to: String) -> Money {
        let new = Double(self.amount) / exchangeRate[self.currency]! * exchangeRate[to]!
        return Money(amount: Int(new), currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        let new = Double(self.amount) / exchangeRate[self.currency]! * exchangeRate[to.currency]!
        return Money(amount: Int(new) + to.amount, currency: to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        let new = Double(self.amount) / exchangeRate[self.currency]! * exchangeRate[from.currency]!
        return Money(amount: Int(new) - from.amount, currency: from.currency)
    }
    
    public var description : String {
        return "\(currency)\(amount)"
    }
    
    static func +(lhs: Money, rhs: Money) -> Money {
        return rhs.add(lhs)
    }
    
    static func -(lhs: Money, rhs: Money) -> Money {
        return rhs.subtract(lhs)
    }

}

////////////////////////////////////
// Job
//
open class Job : CustomStringConvertible {
    static let NONE = Job(title: "(NONE)", type: Job.JobType.Salary(0))
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case let .Salary(value):
            return value
        case let .Hourly(value):
            return Int(value * Double(hours))
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case let .Salary(value):
            self.type = .Salary(value + Int(amt))
        case let .Hourly(value):
            self.type = .Hourly(value + amt)
        }
    }
    public var description : String {
        return "\(title)"
    }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible {
    static let NONE = Person(firstName: "(NONE)", lastName: "(NONE)", age: 0)
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            if age >= 16 && _job != nil {
                return _job!
            } else {
                return nil
            }
        }
        set(value) {
            _job = value
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            if age >= 18 && _spouse != nil {
                return _spouse!
            } else {
                return nil
            }
        }
        set(value) {
            _spouse = value
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
    
    public var description : String {
        return "\(firstName) \(lastName)"
    }
}

////////////////////////////////////
// Family
//

open class Family : CustomStringConvertible {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        } else {
            print ("no")
        }
        
    }
    
    open func haveChild(_ child: Person) -> Bool {
        members.append(child)
        return true
    }
    
    open func householdIncome() -> Int {
        var income = 0
        for i in members {
            if i.job != nil {
                income += i.job!.calculateIncome(2000)
            }
        }
        return income
    }

    public var description : String {
        return "\(members)"
    }
}
