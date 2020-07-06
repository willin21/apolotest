//
//  ViewController.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit
import CoreLocation

enum CellType: String {
    case CellItem = "apoloItemTableViewCell"
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var apoloSegment: UISegmentedControl!
    @IBOutlet weak var apoloTableView: UITableView!
    
    var viewModel = ApoloListViewModel()
    var currentDataSource: [Items]?
    var currentSwitch: Int = 0
    var isFilter: Bool = true
    
    fileprivate struct Segues {
        static let detailViewController = "detailSegueViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.doRequest()
        self.setupNavigationBar()
    }
    
    func doRequest() {
        viewModel.loadResults(success: {
            self.currentDataSource = self.viewModel.resultsViewModelList?.collection?.items
            self.apoloTableView.reloadData()
        }) { (error) in
            self.alert(textAlert: Constants.Text.somethingIsWrong)
        }
    }
    
    func setupTableView() {
        self.apoloTableView.delegate = self
        self.apoloTableView.dataSource = self
        self.apoloTableView.keyboardDismissMode = .onDrag
        self.apoloTableView.alwaysBounceVertical = false
        self.apoloTableView.register(UINib(nibName: CellType.CellItem.rawValue, bundle: nil), forCellReuseIdentifier: CellType.CellItem.rawValue)
    }
    
    func setupNavigationBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
        definesPresentationContext = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = Constants.Text.titleBar
    }
    
    func alert(textAlert: String) {
        let alert = UIAlertController(title: "", message: textAlert, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.Text.tryAgain, style: UIAlertAction.Style.default, handler: { action in
            self.doRequest()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func isLastPosition(position: Int) -> Bool {
        let total = (self.viewModel.resultsViewModelList?.collection?.items!.count) ?? 0
        
        if total == position - 1 {
            return true
        }
        
        return false
    }
    
    func validateFavorite(id: String) -> Bool {
        if let myCurrentFavorites = getFavorites() {
            if self.doesThisFavoriteExists(array: myCurrentFavorites, id: id) {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func amountItem(show: Bool, text: String) {
        if show {
            self.alertFavorite(textAlert: text)
        }
    }
    
    func setFooterButton(text: String, color: UIColor, view: UIView) -> UIButton {
        let button = UIButton()
        let widthButton: CGFloat = 200
        
        button.frame = CGRect(x: (view.frame.width - widthButton) / 2, y: 10, width: widthButton, height: 40)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    func filterDataSource(textToSearch: String) {
        if textToSearch.count > 0 {
            switch currentSwitch {
            case 0:
                currentDataSource = viewModel.resultsViewModelList?.collection?.items
            case 1:
                currentDataSource = getFavorites()
            default:
                break
            }

            let filteredResults = currentDataSource?.filter { ($0.data![0].title!.replacingOccurrences(of: " ", with: "").lowercased().contains(textToSearch.replacingOccurrences(of: " ", with: "").lowercased())) }
            
            isFilter = true
            currentDataSource = filteredResults
            apoloTableView.reloadData()
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            if let item = sender as? Items {
                detailVC.itemModel = item
                detailVC.delegate = self
            }
        }
    }
    
    // MARK: - Action
    @objc func buttonAction(_ sender: UIButton!) {
        let items = (currentDataSource?.count) ?? 0
        
        if items == 0 {
            self.doRequest()
        } else {
            self.viewModel.resultsViewModelList?.collection?.items?.removeAll()
            self.currentDataSource?.removeAll()
            self.removeAllFavorites()
            self.apoloTableView.reloadData()
            self.isFilter = false
        }
    }
    
    @IBAction func switchSegmentAction(_ sender: UISegmentedControl) {
        currentSwitch = sender.selectedSegmentIndex
        switch currentSwitch {
        case 0:
            currentDataSource = viewModel.resultsViewModelList?.collection?.items
        case 1:
            currentDataSource = getFavorites()
        default:
            break
        }
        
        apoloTableView.reloadData()
    }
}

// MARK: - Extensions
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSwitch {
        case 0:
            if currentDataSource?.count == 0 && !isFilter {
                self.amountItem(show: true, text: Constants.Text.noneItems)
            }
            
            return (currentDataSource?.count) ?? 0
        case 1:
            if currentDataSource == nil {
                self.amountItem(show: true, text: Constants.Text.nonefavoriteItems)
            }
            
            return (currentDataSource?.count) ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.apoloTableView.dequeueReusableCell(withIdentifier: CellType.CellItem.rawValue, for: indexPath) as! apoloItemTableViewCell
        let dataItem = (currentDataSource![indexPath.row].data![0])
        
        cell.accessoryType = .disclosureIndicator
        cell.isFavorite = validateFavorite(id: dataItem.nasa_id ?? "")
        cell.setupValues(data: dataItem)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = currentDataSource![indexPath.row]
        performSegue(withIdentifier: Segues.detailViewController, sender: item)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let items = (currentDataSource?.count) ?? 0
        let footerView = UIView()
        
        footerView.backgroundColor = .clear
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)

        if items == 0 {
            let button = setFooterButton(text: Constants.Text.reload, color: .systemGreen, view: footerView)
            footerView.addSubview(button)
        } else {
            let button = setFooterButton(text: Constants.Text.delete, color: .red, view: footerView)
            footerView.addSubview(button)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    // MARK: - Swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            switch currentSwitch {
            case 0:
                currentDataSource!.remove(at: indexPath.section)
            case 1:
                if var dataItem = getFavorites() {
                    let id = dataItem[indexPath.row].data![0].nasa_id
                    let isExistent = doesThisFavoriteExists(array: dataItem, id: id!)
                    
                    if isExistent {
                        let filteredIndices = dataItem.indices.filter { dataItem[$0].data![0].nasa_id == id }
                        
                        var index: Int = 0
                        _ = filteredIndices.map {index = $0}
                        dataItem.remove(at: index)
                        
                        let encodedPreferences = try! JSONEncoder().encode(dataItem)
                        UserDefaultsHelper.saveObject(objectToSave: encodedPreferences, forKey: Constants.UserDefaults.saveFavoriteItems)
                    }
                }
                
                currentDataSource!.remove(at: indexPath.section)
            default:
                break
            }
            
            apoloTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id = self.currentDataSource![indexPath.row].data![0].nasa_id
        let contextItem = UIContextualAction(style: .normal, title: "Favorites") { (contextualAction, view, boolValue) in
            self.savedFavorite(object: self.currentDataSource![indexPath.row])
            self.apoloTableView.reloadData()
            boolValue(true)
        }
        
        if self.validateFavorite(id: id ?? "") {
            contextItem.backgroundColor = .systemYellow
        } else {
            contextItem.backgroundColor = .darkGray
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

// MARK: SearchController
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterDataSource(textToSearch: text)
    }
}

extension HomeViewController: FavoriteProtocol {
    func favoriteUpdate() {
        apoloTableView.reloadData()
    }
}
