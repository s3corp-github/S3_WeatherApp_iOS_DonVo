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
    private var cityList: [String] = []

    private lazy var viewModel: SearchViewModelProtocol = SearchViewModel()
    private lazy var emptyLabel: UILabel = {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height))

        let messageLabel = UILabel(frame: rect)
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        return messageLabel
    }()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bind()
        viewModel.getRecentCity()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar(searchController.searchBar, textDidChange: viewModel.previousSearchPattern)
    }

    //MARK: - Setup
    private func setUpUI() {
        self.hideKeyboardWhenTappedAround()
        self.handleKeyboardContrain(contrainBottom: tableViewContrainBottom)
        tableView.delegate = self
        tableView.dataSource = self
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        self.navigationItem.titleView = self.searchController.searchBar;
        self.definesPresentationContext = true
    }

    private func bind() {
        viewModel.didGetCityListFromAPI = { [weak self] list in
            self?.cityList.removeAll()
            if list.count != 0 {
                self?.cityList = list
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self?.setEmptyMessage(with: "Unable to find any matching weather location to the query submitted!")
                    self?.tableView.reloadData()
                }
            }
        }
        viewModel.didGetRecentCityList = { [weak self] list in
            self?.cityList.removeAll()
            if list.count != 0 {
                self?.cityList = list
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self?.setEmptyMessage(with: "You don't have any search history yet!")
                    self?.tableView.reloadData()
                }
            }
        }
        viewModel.didFailWithError = { [weak self] error in
            self?.cityList.removeAll()
            DispatchQueue.main.async {
                self?.setEmptyMessage(with: error.localizedDescription)
                self?.tableView.reloadData()
            }
        }
    }

    //MARK: - Methods
    private func updateRecentCity(with recent: String) {
        viewModel.updateRecentCity(recent: recent)
    }

    private func getData(with pattern: String ) {
        viewModel.getData(with: pattern)
    }

    private func setEmptyMessage(with message: String) {
        emptyLabel.text = message
        tableView.backgroundView = emptyLabel;
    }

    private func restoreTableView() {
        tableView.backgroundView = nil
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
        let cityName = cityList[indexPath.row]
        navigateToCityScreen(name: cityName)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cityList.count > 0 {
            restoreTableView()
        }
        return cityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let city = cityList[indexPath.row]
        cell.textLabel?.text = city
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getData(with: "")
    }
}
