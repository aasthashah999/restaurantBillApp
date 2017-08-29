//
//  ViewController.swift
//  RestaurantApp
//
//  Created by Aastha Shah on 6/29/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, RestaurantModelListenerProtocol{

    override func viewDidLoad() {
        //Adding Gradient colors in the backgroud as CALayer
        super.viewDidLoad()
        myRestaurantBill.delegate = self
        //label declarations for quantity, line total, food total, tip, tax, and final total
    }
    
    //functions for picker
    @IBOutlet weak var items: UIPickerView!{
        didSet{
            items.delegate = self
            items.dataSource = self
        }
    }
    //filling data
    let myRestaurantBill = RestaurantBill()
    var itemInTable:[String] = []
    private func mapSection(_ section: Int) -> FoodOrDrink {
        switch section {
        case 0: return .Food
        case 1: return .Drink
        default: preconditionFailure("Invalid section! \(section)")
        }
    }
    //protocol
    func itemsChanged() {
        items.reloadAllComponents()
    }
    //data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myRestaurantBill.menu.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return foodName[row]
        return "\(myRestaurantBill.menu[row].name) : $\(myRestaurantBill.menu[row].price/100)"
    }
    
    
    //functions for table
    //declaration for tableView
    
    @IBOutlet weak var billTableView: UITableView!
    static let CellID = "cell"
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return itemInTable.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = itemInTable[indexPath.row]
        return cell
    }
    
    
    //label declarations for quantity, line total, food total, tip, tax, and final total
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var lineTotal: UILabel!
    @IBOutlet weak var foodTotal: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var finalTotal: UILabel!
    
    
    //declaration of needed variables
    var quantityOfFood:Int = 0
    
    
    //stepper 
    @IBOutlet weak var quantityStepper: UIStepper!
    
    //Stepper function
    @IBAction func quantityStepper(_ sender: UIStepper) {
        //sets label equal to quantity
        quantity.text = Int(sender.value).description
        quantityOfFood = Int(sender.value)
        
    }
    
    //addItem button and function
    
    @IBAction func addItemButton(_ sender: Any) {
        myRestaurantBill.addItem(foodName: myRestaurantBill.menu[items.selectedRow(inComponent: 0)].name, quantity: quantityOfFood)
        itemInTable.append("\(myRestaurantBill.menu[items.selectedRow(inComponent: 0)].name) : \(quantityOfFood) @ $ \(myRestaurantBill.menu[items.selectedRow(inComponent: 0)].price/100) : \(myRestaurantBill.menu[items.selectedRow(inComponent: 0)].foodOrDrink)")
        let indexPath = IndexPath(row: itemInTable.count - 1 , section:0)
        billTableView.beginUpdates()
        billTableView.insertRows(at: [indexPath], with: .automatic)
        billTableView.endUpdates()
        updateUI()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemsViewController: ItemsTableViewController = segue.destination as? ItemsTableViewController {
            itemsViewController.myRestaurantBill = myRestaurantBill
        
        }
        print(segue.destination)
    }

    func updateUI(){
            let foodTotalDollar = String(format: "%.2f", myRestaurantBill.baseTotal)
            foodTotal.text = "$\(foodTotalDollar)"
            let tipDollarAmount = String(format: "%.2f",myRestaurantBill.baseTotal*0.10)
            tip.text = "$\(tipDollarAmount)"
            let taxDollarAmount = String(format: "%.2f", myRestaurantBill.baseTotal*0.07)
            tax.text = "$\(taxDollarAmount)"
            let finalDollarAmount = String(format: "%.2f", myRestaurantBill.finalTotal)
            finalTotal.text = "$\(finalDollarAmount)"
            
    }
    


}

