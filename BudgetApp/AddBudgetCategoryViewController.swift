//
//  AddBudgetCategoryViewController.swift
//  BudgetApp
//
//  Created by Vitalii Navrotskyi on 22.04.2024.
//

import UIKit
import CoreData

class AddBudgetCategoryViewController: UIViewController {

    private var persistentContainer: NSPersistentContainer

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Budget name"
        textField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 10, height: .zero))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Budget amount"
        textField.leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: 10, height: .zero))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var addBudgetButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        return button
    }()

    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
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
            NSLog("No valid text")
            return false
        }
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreatorThan(0)
    }

    private func saveBudgetCategory() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            NSLog("No valid text")
            return
        }

        do {
            let budgetCategory = BudgetCategory(context: persistentContainer.viewContext)
            budgetCategory.name = name
            budgetCategory.amount = Double(amount) ?? 0.0
            try persistentContainer.viewContext.save()
            // dismiss the model
            dismiss(animated: true)
        } catch {
            errorMessageLabel.text = "Unable to save budget category"
            NSLog("Unable to save budget category")
        }

    }

    @objc private func addBudgetButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveBudgetCategory()
        } else {
            errorMessageLabel.text = "Unable to save budget. Budget name and amount is required"
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add Budget"

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        view.addSubview(stackView)

        [nameTextField, amountTextField, addBudgetButton, errorMessageLabel].forEach(stackView.addArrangedSubview(_:))

        // add constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addBudgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        //add button click
        addBudgetButton.addTarget(self, action: #selector(addBudgetButtonPressed), for: .touchUpInside)

        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
