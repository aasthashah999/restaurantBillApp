//
//  File.swift
//  RestaurantApp
//
//  Created by Aastha Shah on 6/30/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import Foundation

protocol RestaurantModelListenerProtocol{
    func itemsChanged() -> Void
}

enum serviceLevel3:Double{
    case poor = 0.05
    case good = 0.07
    case excellent = 0.10
}

enum FoodOrDrink {
    case Food
    case Drink
}

var arrayOfItemsTotal = [Double]()
class RestaurantBill {
    /* var allItems:[String:Items] = ["Rambutan": Items.init(quantity: 2.0, price: 100.0), "Oranges": Items.init(quantity: 3.0, price: 200.0), "Melons": Items.init(quantity: 1.0, price: 300.0)] */
    var delegate: RestaurantModelListenerProtocol?
    
    var menu = [
        MenuItem(price: 500, name: "Rambutan", description: "Hairy Lychees", foodOrDrink: .Food),
        MenuItem(price: 300, name: "Oranges", description: "Tart, Sweet", foodOrDrink: .Food),
        MenuItem(price: 200, name: "Mango Lassi", description: "Yogurt Drink", foodOrDrink: .Drink),
        MenuItem(price: 300, name: "Chai", description: "Spicy, Milky Black Tea Drink", foodOrDrink: .Drink)
    ]
    
    
    struct MenuItem {
        var price: Int
        var name: String
        var description: String
        var foodOrDrink: FoodOrDrink
    }
    
    struct OrderItem {
        var quantity: Int // 4
        var item: MenuItem // Hamburgers
    }
    
    var order: [String: OrderItem] = [:] // Hamburger: <4 Hamburgers>, Coke: <2 Cokes>
    
    func addItem(foodName: String, quantity: Int) {
        // look up OrderItem by foodName in the order, see if item already exists in some quantity
        // if so, just increment existing quantity by passed in quantity
        // if not, create a new order item with passed in quantity and looked up MenuItem
        
        
        if let valueAllItems = order[foodName]{
            order[foodName] = OrderItem(quantity: valueAllItems.quantity+quantity, item: valueAllItems.item)
            let totalPricePerItem = (valueAllItems.quantity+quantity*(valueAllItems.item.price))
            arrayOfItemsTotal.append(Double(totalPricePerItem))
        
        }
        else {
            guard let searchItemIndex = menu.index(where: { $0.name == foodName }) else {
                return
            }
            order[foodName]=OrderItem(quantity:quantity, item: menu[searchItemIndex])
            let totalPricePerItem = (quantity+quantity*(order[foodName]?.item.price)!)
            arrayOfItemsTotal.append(Double(totalPricePerItem))
        }
    }
    
    
    
    var baseTotal : Double {
        let total =  arrayOfItemsTotal.reduce(0, { x, y in
            x + y
        })
        
        return total/100
    }
    
    var finalTotal: Double {
            return baseTotal*0.07 + baseTotal*0.1 + baseTotal
    }
    
    //SOURCE: https://stackoverflow.com/questions/31373400/swift-append-to-array-in-struct
    
    func addMenuItems(price: Int, name:String, description:String) {
        //successfully adds new item to array,
        menu.append(MenuItem(price: price, name: name, description: description, foodOrDrink: .Food))
        delegate?.itemsChanged()
    }
    func removeItems() {
        delegate?.itemsChanged()
    }
    func textChanged() {
        delegate?.itemsChanged()
    }
    
    func numItems(foodType: FoodOrDrink) -> Int {
        return (menu.filter { $0.foodOrDrink == foodType }).count
    }
    
    func fruitAtIndex(at index: Int, foodType: FoodOrDrink) -> String {
        return String(describing: (menu.filter { $0.foodOrDrink == foodType })[index])
    }
    
    
}

