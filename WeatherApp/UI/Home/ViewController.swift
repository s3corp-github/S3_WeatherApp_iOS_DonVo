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
    private var filteredCity : [String] = []
    private var recentSearchCity : [String] = []
    private let cellIdentifier = "Cell"
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel = SearchViewModel()
    private var debounceTimer: Timer?

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
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

    override func viewWillAppear(_ animated: Bool) {
        recentSearchCity = viewModel.getRecentCity()
        tableView.reloadData()
    }

    //MARK: - Methods
    private func filterCity(for searchText: String) {
        filteredCity = recentSearchCity.filter { city in
            return city.lowercased().contains(searchText.lowercased())
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

    private func updateRecentCity(recent: String) {
        viewModel.updateRecentCity(recent: recent, recentList: recentSearchCity )
        recentSearchCity = viewModel.getRecentCity()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func setEmptyMessage(message: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = .none;
    }

    private func restoreTableView() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
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
        updateRecentCity(recent: cityName)
        navigationController?.pushViewController(cityVc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            if filteredCity.count > 0 {
                restoreTableView()
            } else {
                setEmptyMessage(message: "Couldn't find any suitable place.")
            }
            return filteredCity.count
          }

        if recentSearchCity.count > 0 {
            restoreTableView()
        } else {
            setEmptyMessage(message: "You don't have any search history yet!")
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
        if !searchController.isActive || searchController.searchBar.text == "" {
            self.filteredCity.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            debounceTimer?.invalidate()
        } else {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.viewModel.fetchCity(with: searchController.searchBar.text ?? "")
            }
        }
    }
 }

//MARK: - SearchViewModelDelegate
extension ViewController: SearchViewModelDelegate {
    func didUpdateCityList(_ model: SearchViewModel, cityList: CityList) {
        self.filteredCity = cityList.cityList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailWithError(_ model: SearchViewModel, error: APIError) {
        self.filteredCity.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
