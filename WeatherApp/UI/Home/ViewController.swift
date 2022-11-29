//
//  ViewController.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewContrainBottom: NSLayoutConstraint!

    //MARK: - Properties
    var filteredCity : [String] = []
    var recentSearchCity : [String] = ["Canada", "Chicago", "Canada", "Chicago", "Canada", "Chicago", "Canada", "Chicago", "Canada", "Chicago", "Canada", "Chicago", "Canada", "Chicago", "Canada", "Chicago"]
    let cellIdentifier = "Cell"
    let searchController = UISearchController(searchResultsController: nil)

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchBar.searchBarStyle = .minimal
        self.navigationItem.titleView = self.searchController.searchBar;
        self.definesPresentationContext = true

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
          forName: UIResponder.keyboardWillChangeFrameNotification,
          object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(
          forName: UIResponder.keyboardWillHideNotification,
          object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
    }

    //MARK: - Methods
    private func filterCity(for searchText: String) {
        filteredCity = recentSearchCity.filter { city in
            return city.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    private func handleKeyboard(notification: Notification) {
      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
          tableViewContrainBottom.constant = 0
        view.layoutIfNeeded()
        return
      }

      guard
        let info = notification.userInfo,
        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
          return
      }

      let keyboardHeight = keyboardFrame.cgRectValue.size.height
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.tableViewContrainBottom.constant = keyboardHeight
        self.view.layoutIfNeeded()
      })
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cityName = ""
        if searchController.isActive && searchController.searchBar.text != "" {
            cityName = filteredCity[indexPath.row]
        } else {
            cityName = recentSearchCity[indexPath.row]
        }
        let cityVc = CityViewController()
        cityVc.cityName = cityName
        navigationController?.pushViewController(cityVc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCity.count
          }
          return recentSearchCity.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
          let city: String
          if searchController.isActive && searchController.searchBar.text != "" {
              city = filteredCity[indexPath.row]
          } else {
              city = recentSearchCity[indexPath.row]
          }
          cell.textLabel?.text = city
          return cell
    }
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterCity(for: searchController.searchBar.text ?? "")
   }
 }
