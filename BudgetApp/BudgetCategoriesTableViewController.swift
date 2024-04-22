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
        setupUI()
    }

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // add bar button
        let addBudgetCategoryButton = UIBarButtonItem(
            title: "Add Category",
            style: .done,
            target: self,
            action: #selector(showAddBudgetCategory)
        )
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }

    @objc private func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(
            rootViewController: AddBudgetCategoryViewController(
                persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
}


