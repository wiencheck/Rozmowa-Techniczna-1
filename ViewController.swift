//
//  ViewController.swift
//  Rozmowa Techniczna 1
//
//  Created by Adam Wienconek on 29/09/2026.
//

import UIKit

protocol ViewModelDelegate: AnyObject {
    func viewModelDidUpdateItems(_ viewModel: ViewModel)
}

final class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    private lazy var db = Database()
    
    private(set) var items: [Item] = []
    
    func loadData() {
        db.fetchItems { result in
            guard case .success(let success) = result else {
                return
            }
            self.items = success
            self.delegate?.viewModelDidUpdateItems(self)
        }
    }
    
}


class ViewController: UIViewController {
    
    lazy var viewModel = ViewModel()
    
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Master"
        // Do any additional setup after loading the view.
        
        setupTableView()
        viewModel.delegate = self
        viewModel.loadData()
    }

}

private extension ViewController {
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
    }
}

extension ViewController: ViewModelDelegate {
    
    func viewModelDidUpdateItems(_ viewModel: ViewModel) {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = viewModel.items[indexPath.row]
        cell.contentConfiguration = {
            var configuration = UIListContentConfiguration.cell()
            configuration.text = item.title
            
            return configuration
        }()
        
        return cell
    }
}
