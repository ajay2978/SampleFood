//
//  ItemTVC.swift
//  SampleFood
//
//  Created by Pankaj Yadav on 09/08/22.
//

import UIKit

protocol ItemCellDelegate{
    func addButtonAction(index:Int)
    func getprice(price:Int)
}

class ItemTVC: UITableViewCell {

    @IBOutlet weak var itemCategory: UILabel!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var addQuantityStepper: UIStepper!
    @IBOutlet weak var quantityCountLabel: UILabel!
    
    var cellDelegate: ItemCellDelegate?
    var index: IndexPath?
    
    var foodQuantityCount = [Int]()
    var foodPrice = 0
    
    var foodItemCount = itemCounts(count: 0) {
            didSet {
                addQuantityStepper.value = Double(foodItemCount.count)
                quantityCountLabel.text = String(foodItemCount.count)
               
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func expandButtonAction(_ sender: UIButton) {
 //        addQuantityStepper.value = 1.0
    }
    
    @IBAction func addQuantityStepperAction(_ sender: UIStepper) {
//        cellDelegate?.onStepperClick(index: (index?.row)!, sender: sender)
//            sender.maximumValue = 1  //for incrementing
//            sender.minimumValue = -1 //for decrementing
            foodItemCount.count = Int(sender.value)
            self.quantityCountLabel.text = String(Int(sender.value))
        foodPrice = foodPrice + (Int(itemCount.text!) ?? 0)
        cellDelegate?.getprice(price: foodPrice)
    }
    
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
