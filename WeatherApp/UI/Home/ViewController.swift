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
    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var viewModel: SearchViewModelProtocol = SearchViewModel(service: .init())
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
    }

    override func viewWillAppear(_ animated: Bool) {
        if viewModel.previousSearchPattern == "" {
            viewModel.getRecentCity()
        }
    }

    //MARK: - Setup
    private func setUpUI() {
        handleKeyboardContrain(contrainBottom: tableViewContrainBottom)
        tableView.delegate = self
        tableView.dataSource = self
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        navigationItem.titleView = self.searchController.searchBar;
        definesPresentationContext = true
    }

    private func bind() {
        viewModel.didGetCityListFromAPI = { [weak self] list, pattern in
            guard self?.viewModel.previousSearchPattern == pattern else { return }
            self?.viewModel.cityList = list
            if self?.viewModel.cityList.count == 0 {
                self?.setEmptyMessage(with: "Unable to find any matching weather location to the query submitted!")
            }
            self?.reloadData()
        }
        viewModel.didGetRecentCityList = { [weak self] list in
            self?.viewModel.cityList = list
            if self?.viewModel.cityList.count == 0 {
                self?.setEmptyMessage(with: "You don't have any search history yet!")
            }
            self?.reloadData()
        }
        viewModel.didFailWithError = { [weak self] error, pattern in
            guard self?.viewModel.previousSearchPattern == pattern else { return }
            self?.viewModel.cityList.removeAll()
            self?.setEmptyMessage(with: error.localizedDescription)
            self?.reloadData()
        }
    }

    //MARK: - Methods
    private func setEmptyMessage(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.emptyLabel.text = message
            self?.tableView.backgroundView = self?.emptyLabel
        }
    }

    private func restoreTableView() {
        tableView.backgroundView = nil
    }

    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    //MARK: - Navigate
    private func navigateToCityScreen(name: String) {
        let cityVc = CityViewController()
        cityVc.cityName = name
        viewModel.updateRecentCity(recent: name)
        navigationController?.pushViewController(cityVc, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = viewModel.cityList[indexPath.row]
        navigateToCityScreen(name: cityName)
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.cityList.count > 0 {
            restoreTableView()
        }
        return viewModel.cityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.cityList[indexPath.row]
        return cell
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getData(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getData(with: "")
    }
}
