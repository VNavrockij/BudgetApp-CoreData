//
//  BudgetCategoriesTableViewController.swift
//  BudgetApp
//
//  Created by Vitalii Navrotskyi on 22.04.2024.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    private var persistentContainer: NSPersistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


