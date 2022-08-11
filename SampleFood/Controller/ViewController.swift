//
//  ViewController.swift
//  SampleFood
//
//  Created by Pankaj Yadav on 09/08/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var placeOrderButton: UIButton!
    
    var hiddenSections = Set<Int>()
    var decodedData = CollectionViewData()
    var decodedCategories = [Dictionary<String, [CollectionViewDatum]>.Keys.Element]()
    var decodedItems = [[Dictionary<String, [CollectionViewDatum]>.Values.Element]]()
    var categories = [Dictionary<String, [CollectionViewDatum]>.Values.Element]()
    var count = [itemCounts]()
    var menuItems: [CollectionViewDatum] = []
    var numberOfItemsAddedInEachRow : [Int] = []
    var stepvalue = 0
    
    var myFoodPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }

    @IBAction func placeOrderButtonAction(_ sender: UIButton) {
        placeOrderButton.setTitle("Place Order", for: .normal)
        showAlert(withTitle: "ABCFoods", message: "Order successfully placed!")
    }
    
    func initializeView() {
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
        placeOrderButton.setTitle("Place Order", for: .normal)
        MenuTableView.register(UINib(nibName: "TableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableViewHeader")
        if let localData = self.readLocalFile(forName: "data") {
            self.parse(jsonData: localData)
        }
        let urlString = "file:///Users/pankajyadav/Desktop/SampleFood/SampleFood/Model/menu.json"

        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                self.parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
        private func readLocalFile(forName name: String) -> Data? {
            do {
                if let bundlePath = Bundle.main.path(forResource: name,
                                                     ofType: "json"),
                    let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    return jsonData
                }
            } catch {
                print(error)
            }
            
            return nil
        }

    private func parse(jsonData: Data) {
        do {
            decodedData = try JSONDecoder().decode(CollectionViewData.self,
                                                       from: jsonData)
            print(decodedData.values)
            decodedCategories = Array(decodedData.keys)
            categories = Array(decodedData.values)
            decodedItems.append(categories)
            for i in 0..<categories.count {
                menuItems = categories[i].map { $0 }
                print(menuItems.count)
                for i in 0..<menuItems.count {
                    let initialCount = itemCounts(count: 0)
                            self.count.append(initialCount)
                    numberOfItemsAddedInEachRow.append(0)
                }
                
            }
        } catch {
            print("decode error")
        }
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    func stepvalueAtIndex(index:Int) {
        stepvalue = 1
    }
    
    func getOrderValues(cell:UITableViewCell) {
    }
    
}

extension ViewController : UITableViewDataSource, UITableViewDelegate, ItemCellDelegate {
    func getprice(price: Int) {
        placeOrderButton.setTitle("Place Order", for: .normal)
        myFoodPrice = price
    }
    
    func addButtonAction(index: Int) {
        
    }
    
    func onStepperClick(index: Int, sender: UIStepper) {
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        return self.categories[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTableView.dequeueReusableCell(withIdentifier: "ItemTVC", for: indexPath) as! ItemTVC
        menuItems = categories[indexPath.section].map { $0 }
        cell.itemCategory.text = menuItems[indexPath.row].name
        cell.itemCount.text = "\(menuItems[indexPath.row].price)"
        if menuItems[indexPath.row].instock == false {
            cell.addQuantityStepper.isHidden = true
            cell.expandButton.isHidden = true
            cell.quantityCountLabel.isHidden = true
        }
        else {
            cell.addQuantityStepper.isHidden = false
            cell.expandButton.isHidden = false
            cell.quantityCountLabel.isHidden = false
        }
        placeOrderButton.setTitle("Place Order", for: .normal)
        cell.expandButton.tag = indexPath.row
        cell.expandButton.addTarget(self,
                                action: #selector(self.addButton(sender:)),
                                for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuItems = categories[indexPath.section].map { $0 }
        if menuItems[indexPath.row].instock == false {
            showAlert(withTitle: "ABCFoods", message: "This item is out of stock. We are sorry for the inconvinience. Please select anything else.")
        }
        else {
            debugPrint("This is available")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainView = UIView()
        mainView.frame = CGRect(x: 10, y: 60, width: 200, height: 200)
        mainView.layer.backgroundColor = UIColor.white.cgColor
        var label = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: 150, height: 30)
        label.backgroundColor=UIColor.white
        label.textColor = .gray
        label.textAlignment = NSTextAlignment.left
        label.text = decodedCategories[section]
        mainView.addSubview(label)
        let bound = MenuTableView.bounds.maxX
        var countLabel = UILabel()
        countLabel.frame = CGRect(x: bound-70, y: 10, width: 20, height: 30)
        countLabel.backgroundColor=UIColor.white
        countLabel.textAlignment = NSTextAlignment.center
        countLabel.text = "\(menuItems.count)"
        mainView.addSubview(countLabel)

                var sectionButton: UIButton = UIButton()
        sectionButton.frame=CGRect(x: bound-40 , y: 10, width: 30, height: 30)
        sectionButton.backgroundColor=UIColor.red
        sectionButton.setTitle("button", for: UIControl.State.normal)
        mainView.addSubview(sectionButton)

                var txtField : UITextField = UITextField()
        txtField.frame = CGRect(x: 50, y: 10, width: 100,height: 50)
        txtField.backgroundColor = UIColor.gray
        sectionButton.setImage(UIImage(named: "downArrow"), for: .normal)
        sectionButton.backgroundColor = .white
        sectionButton.tintColor = .gray
        sectionButton.tag = section
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)

        return mainView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc
    private func addButton(sender: UIButton) {
        numberOfItemsAddedInEachRow[sender.tag] = 1
        MenuTableView.reloadData()
    }

    
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<self.categories[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.MenuTableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.MenuTableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }

}

