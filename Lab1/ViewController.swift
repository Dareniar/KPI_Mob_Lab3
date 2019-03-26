//
//  ViewController.swift
//  Lab1
//
//  Created by Danil Shchegol on 3/11/19.
//  Copyright © 2019 Danil Shchegol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    var advice: String = "Вы не выбрали ни одного критерия"
    
    var selectedColor: Int?
    var selectedPrice: Int?
    
    var savedFlowers: [String]? = [String]()
    
    let colors = ["Черный", "Белый", "Желтый", "Красный", "Зеленый", "Синий"]
    let prices = ["До 30 грн. за цветок", "До 60 грн. за цветок", "Выше 60 грн. за цветок"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        button.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        
        if let flowers = UserDefaults.standard.value(forKey: "flowers") as? [String] {
            savedFlowers = flowers
        } else {
            UserDefaults.standard.set(savedFlowers, forKey: "flowers")
        }
    }
    
    @objc func okButtonTapped() {
        
        setupAdviceMessage()
        
        if let text = textField.text, text.count > 0 {
            advice = "\(text), советуем вам приобрести \(advice)"
        }
        
        let vc = UIAlertController(title: "Ваш цветок", message: advice, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        vc.addAction(cancelAction)
        self.show(vc, sender: self)
    }
    
    @objc func showButtonTapped() {
        
        let flowers = UserDefaults.standard.value(forKey: "flowers")
        var message: String = ""
        if let flowers = flowers as? [String], flowers.count > 0 {
            for flower in flowers {
                message.append(flower + "\n")
            }
        } else {
            message = "Вы еще не сохраняли цветы"
        }
        
        let vc = UIAlertController(title: "Сохраненные значения", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        vc.addAction(cancelAction)
        self.show(vc, sender: self)
        
    }
    
    func setupAdviceMessage() {
        guard let color = selectedColor, let price = selectedPrice else {
            advice = "Вы не выбрали ни одного критерия"
            return
        }
        
        switch (color, price) {
        case (0, 0): advice = "Черный одуван"
        case (1, 0): advice = "Белая ромашка"
        case (2, 0): advice = "Желтый одуван"
        case (3, 0): advice = "Красный мак"
        case (4, 0): advice = "Зеленый лемонграсс"
        case (5, 0): advice = "Синий колокольчик"
        case (0, 1): advice = "Черный тюльпан"
        case (1, 1): advice = "Белый тюльпан"
        case (2, 1): advice = "Желтый тюльпан"
        case (3, 1): advice = "Красный тюльпан"
        case (4, 1): advice = "Зеленый тюльпан"
        case (5, 1): advice = "Синий тюльпан"
        case (0, 2): advice = "Черная роза"
        case (1, 2): advice = "Белая роза"
        case (2, 2): advice = "Желтая роза"
        case (3, 2): advice = "Красная роза"
        case (4, 2): advice = "Зеленая роза"
        case (5, 2): advice = "Синяя роза"
        default:     advice = "Вы не выбрали ни одного критерия"
        }
        savedFlowers?.append(advice)
        UserDefaults.standard.set(savedFlowers, forKey: "flowers")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return colors.count
        } else {
            return prices.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Выберите цвет"
        } else {
            return "Выберите ценовую категорию"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = indexPath.section == 0 ? colors[indexPath.row] : prices[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for cell in tableView.visibleCells {
            if tableView.indexPath(for: cell)?.section == indexPath.section {
                cell.accessoryType = .none
            }
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        if indexPath.section == 0 {
            if selectedColor == indexPath.row {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                selectedColor = nil
            } else {
                selectedColor = indexPath.row
            }
        } else {
            if selectedPrice == indexPath.row {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                selectedPrice = nil
            } else {
                selectedPrice = indexPath.row
            }
        }
    }
}
