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
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>!

    private enum Constant: String {
        case cell = "BudgetTableViewCell"
    }

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)

        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cell.rawValue)
    }

    @objc private func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(
            rootViewController: AddBudgetCategoryViewController(
                persistentContainer: persistentContainer))
        present(navController, animated: true)
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

    // UITableViewDataSource delegate function
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cell.rawValue, for: indexPath)
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)

        var configuration = cell.defaultContentConfiguration()
        configuration.text = budgetCategory.name
        cell.contentConfiguration = configuration

        return cell
    }

}

extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


