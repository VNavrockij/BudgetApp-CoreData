//
//  BudgetDetailViewController.swift
//  BudgetApp
//
//  Created by Vitalii Navrotskyi on 30.04.2024.
//

import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {

    private var persistentContainer: NSPersistentContainer
    private var fetchResultsController: NSFetchedResultsController<Transaction>!
    private var budgetCategory: BudgetCategory

    private enum Constant: String {
        case transactionCell = "TransactionTableViewCell"
    }

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.transactionCell.rawValue)
        return tableView
    }()

    lazy var saveTransactionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Transaction", for: .normal)
        return button
    }()

    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()

    init(budgetCategory: BudgetCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)

        // create request based on selected budget category
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]

        fetchResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultsController.delegate = self

        do {
            try fetchResultsController.performFetch()
        } catch {
            errorMessageLabel.text = "Unable to fetch transactions"
            NSLog(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }

        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreatorThan(0)
    }

    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }

        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = Date()

        do {
            try persistentContainer.viewContext.save()
            tableView.reloadData()
        } catch {
            errorMessageLabel.text = "Unable to save transaction"
        }
    }

    @objc private func saveTransactionButtonPressed() {
        
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid"
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name

        // stackView
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(tableView)

        view.addSubview(stackView)

        // add constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)

        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
}

extension BudgetDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (fetchResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.transactionCell.rawValue, for: indexPath)

        let transaction = fetchResultsController.object(at: indexPath)
        // cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = transaction.name
        content.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = content
        
        return cell
    }
}

extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {

}

extension BudgetDetailViewController: UITableViewDelegate {

}
