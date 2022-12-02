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
    private let cellIdentifier = "Cell"
    private let searchController = UISearchController(searchResultsController: nil)
    private var viewModel = SearchViewModel()
    private var debounceTimer: Timer?
    private var filteredCity: [String] = []
    private var recentSearchCity: [String] = []

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self

        setUpUI()
        setUpNotificationCenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        recentSearchCity = viewModel.getRecentCity()
        tableView.reloadData()
    }

    //MARK: - Setup
    private func setUpUI() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        self.navigationItem.titleView = self.searchController.searchBar;
        self.definesPresentationContext = true
    }

    private func setUpNotificationCenter() {
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
    private func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            tableViewContrainBottom.constant = 0
            view.layoutIfNeeded()
            return
        }

        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.tableViewContrainBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }

    private func updateRecentCity(with recent: String) {
        viewModel.updateRecentCity(recent: recent, recentList: recentSearchCity)
        recentSearchCity.removeAll()
        recentSearchCity = viewModel.getRecentCity()

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func setEmptyMessage(with message: String) {
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

    //MARK: - Navigate
    private func navigateToCityScreen(name: String) {
        let cityVc = CityViewController()
        cityVc.cityName = name
        updateRecentCity(with: name)
        navigationController?.pushViewController(cityVc, animated: true)
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
        navigateToCityScreen(name: cityName)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            if filteredCity.count > 0 {
                restoreTableView()
            }
            return filteredCity.count
          }

        if recentSearchCity.count > 0 {
            restoreTableView()
        } else {
            setEmptyMessage(with: "You don't have any search history yet!")
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

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigateToCityScreen(name: searchController.searchBar.text ?? "")
    }
}

//MARK: - SearchViewModelDelegate
extension ViewController: SearchViewModelDelegate {
    func didUpdateCityList(_ model: SearchViewModel, cityList: CityList) {
        self.filteredCity.removeAll()
        self.filteredCity = cityList.cityList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailWithError(_ model: SearchViewModel, error: APIError) {
        self.filteredCity.removeAll()
        DispatchQueue.main.async {
            self.setEmptyMessage(with: error.localizedDescription)
            self.tableView.reloadData()
        }
    }
}
