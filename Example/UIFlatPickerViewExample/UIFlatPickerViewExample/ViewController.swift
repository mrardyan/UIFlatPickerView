// © 2025 Ardyan - Pattern Matters. All rights reserved.

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    
    // MARK: - Data
    private let pickerVariants = [
        "Basic Picker",
        "Infinite Scrolling Picker", 
        "Custom Styled Picker",
        "Multi-Component Picker"
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "UIFlatPickerView Examples"
        view.backgroundColor = .systemBackground
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = pickerVariants[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pickerVC: UIViewController
        
        switch indexPath.row {
        case 0:
            pickerVC = BasicPickerViewController()
        case 1:
            pickerVC = InfinitePickerViewController()
        case 2:
            pickerVC = CustomPickerViewController()
        case 3:
            pickerVC = MultiComponentPickerViewController()
        default:
            return
        }
        
        navigationController?.pushViewController(pickerVC, animated: true)
    }
} 