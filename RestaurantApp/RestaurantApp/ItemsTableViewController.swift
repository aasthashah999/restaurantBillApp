//
//  ItemsTableViewController.swift
//  RestaurantApp
//
//  Created by Aastha Shah on 7/7/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit

class itemsTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

class ItemsTableViewController: UITableViewController, SingleItemEditedListener {
    //declaration for model
    var myRestaurantBill: RestaurantBill?
    // var tappedRow: Int = -1 // The -1 "sentinel value" is highly discouraged in Swift
    var tappedRow: Int?
    
    
    //declaration for table
    @IBOutlet var ItemTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK:  SSingleItemEditedListener
    // this is the correct "data event" listener
    func singleItemChanged(price: String, description: String, name: String) {
        guard let actualTappedRow = tappedRow else {
            return
        }
        
        guard let bill = myRestaurantBill else {
            return
        }
        bill.menu[actualTappedRow].name = name
        guard let intPrice = Int(price) else {
            return
        }
        bill.menu[actualTappedRow].price = intPrice
        bill.menu[actualTappedRow].description = description
        ItemTable.reloadData()
        bill.textChanged()
    
    }


    // MARK: RestaurantModelListenerProtocol
    func itemsChanged() {
        ItemTable.reloadData()
    }
    
    //SOURCE: https://www.lynda.com/Swift-tutorials/Send-data-back-original-view-controller/504400/579552-4.html
    //this function sets the edited text as the new test for the row as the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //returns one section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //returns number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRestaurantBill?.menu.count ?? 0
    }
    
    //setting cell and its labels
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = ItemTable.dequeueReusableCell(withIdentifier: "menuItemCell") as? itemsTableViewCell
        itemCell?.itemNameLabel.text = myRestaurantBill?.menu[indexPath.row].name
        guard let price = myRestaurantBill?.menu[indexPath.row].price else{
            print("No receiver!!")
            return itemCell!
        }
        itemCell?.priceLabel.text = "$\(price/100)"
        itemCell?.descriptionLabel.text = myRestaurantBill?.menu[indexPath.row].description
        if itemCell?.itemNameLabel.text == "Rambutan" {
            itemCell?.itemImage.image = UIImage(named: "Rambutan")
        }
        if itemCell?.itemNameLabel.text == "Oranges" {
            itemCell?.itemImage.image = UIImage(named: "Oranges")
        }
        if itemCell?.itemNameLabel.text == "Mango Lassi" {
            itemCell?.itemImage.image = UIImage(named: "MangoLassi")
        }
        if itemCell?.itemNameLabel.text == "Chai" {
            itemCell?.itemImage.image = UIImage(named: "Chai")
        }
        return itemCell!
    }
    
    
    //adding rows and items
    @IBAction func addButtonPressed(_ sender: Any) {
        //adds new row and new item to array
        //however, the pickerView must be updated
        myRestaurantBill?.addMenuItems(price: 0, name: "New Item", description: "Description")
        let indexPath = IndexPath(row:(myRestaurantBill?.menu.count)!-1, section:0)
        ItemTable.beginUpdates()
        ItemTable.insertRows(at: [indexPath], with: .automatic)
        ItemTable.endUpdates()
        ItemTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
   
    //deleting rows and items
    //this updates the model, but the pickerView does not know that something has changed
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myRestaurantBill?.menu.remove(at: indexPath.row)
            ItemTable.deleteRows(at: [indexPath], with: .automatic)
            myRestaurantBill?.removeItems()
        }
    }
    
    //transition to editor
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editorViewController: EditorViewController = segue.destination as? EditorViewController {
            tappedRow = ItemTable.indexPathForSelectedRow?.row
            //whenever this is fired, the itemsChanged is fired
            //crucial to setting changed data to new data
            editorViewController.receiver = self
            // setting name of nameText to respective areas of array
            editorViewController.nameText = myRestaurantBill!.menu[tappedRow!].name
            editorViewController.priceText = String(myRestaurantBill!.menu[tappedRow!].price)
            editorViewController.descriptionText = myRestaurantBill!.menu[tappedRow!].description
        }
    }
}
