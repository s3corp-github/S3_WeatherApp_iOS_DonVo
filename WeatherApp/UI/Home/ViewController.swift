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
    private lazy var messageView: MessageView = {
        return MessageView(frame: tableView.frame)
    }()

    private lazy var loadingView: LoadingView = {
        return LoadingView(frame: tableView.frame)
    }()

    private lazy var viewModel: SearchViewModelProtocol = SearchViewModel()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        viewModel.didGetCityList = { [weak self] in
            self?.removeTableViewSubView()
            self?.reloadData()
        }

        viewModel.didFailWithError = { [weak self] error in
            if let apiError = error as? APIError {
                self?.setErrorMessage(apiError.localizedDescription)
            }
            if let apiError = error as? SearchCityError {
                self?.setErrorMessage(apiError.message)
            }
            self?.reloadData()
        }
    }

    //MARK: - Methods
    private func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setErrorMessage(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageView.setMessage(message)
            self?.tableView.addOnlySubView(self?.messageView ?? UIView())
        }
    }

    private func removeTableViewSubView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.removeAllSubViews()
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
        guard viewModel.willFetchData(with: searchText) else { return }
        viewModel.fetchData(with: searchText)
        tableView.addOnlySubView(loadingView)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard viewModel.willFetchData(with: "") else { return }
        viewModel.fetchData(with: "")
    }
}
