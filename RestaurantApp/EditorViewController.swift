//
//  EditorViewController.swift
//  RestaurantApp
//
//  Created by Aastha Shah on 7/11/17.
//  Copyright © 2017 Aastha Shah. All rights reserved.
//

import UIKit

// w/o private on 'nameText': I can say:
// editorVC.nameText = "foo" --> event handling in setName does not run, e.g. itemNameText.text = n
// Two ways of making consistent:
//  1. private var xxxText in declaration
// setX and getX are non-idiomatic Swift
//
// 2. didSet strategy: then editorVC.nameText = "foo" triggers observer, does same as
// editorVC.setName("foo") did before

protocol SingleItemEditedListener {
    func singleItemChanged(price: String, description: String, name: String)
}

class EditorViewController: UIViewController {
    // MARK: Model
    var priceText: String = "" {
        //everytime priceText is changed,  code inside the brackets will execute
        didSet {
            if isViewLoaded {
                //every time priceText is changed itemPriceText is changed 
                itemPriceText.text = priceText
            }
        }
    }
    var descriptionText: String = "" {
        didSet {
            if isViewLoaded {
                itemDescriptiontText.text = descriptionText
            }
        }
    }//when name is changed this runs, so everytime a new row is clicked
    var nameText: String = "" {
        didSet { // event handler: runs when a certain condition is triggered
            // runs right after any instance of EditorViewController receives an assignment to nameText
            if isViewLoaded {
                itemNameText.text = nameText
            }
        }
    }

    
    //declarations for elements in View
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var itemNameText: UITextField!
    // this didSet only runs _on entry_ to this VC, so it's consistent with underlying model
    // parentVC.prepareForSegue will trigger this. This not inolved on the way back
    @IBOutlet weak var itemPriceText: UITextField!
    @IBOutlet weak var itemDescriptiontText: UITextView!
    // This is bad: hardwires this editor to a concrete parent type when not necessary
    var mainViewEditor: ItemsTableViewController!
    // better:
    var receiver: SingleItemEditedListener?
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameText.text = nameText
        itemPriceText.text = priceText
        itemDescriptiontText.text = descriptionText
    }
    
    
    //sets the new text to the variable in the ItemTableViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let price =  itemPriceText.text,
            let description = itemDescriptiontText.text,
            let name = itemNameText.text else {
            // complain horribly
            print("No text!!")
            return
        }
        guard let receiver = receiver else {
            print("No receiver!!")
            return
        }
        receiver.singleItemChanged(price: price, description: description, name: name)
        //sets value here for price, description, and name
    }

}
