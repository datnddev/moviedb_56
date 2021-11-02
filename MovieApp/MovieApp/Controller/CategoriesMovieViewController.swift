//
//  ViewController.swift
//  Movie App
//
//  Created by datNguyem on 19/10/2021.
//

import UIKit

final class CategoriesMovieViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var homeSections = [HomeSection]()
    private enum LayoutOptions {
        static let heightForHeaderInSection: CGFloat = 55
        static var heightForCellInSection: CGFloat {
            return UIScreen.main.bounds.height * 0.4
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        loadData()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.barTintColor = UIColor.hex_0E1A2B
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(searchIconDidTapped))
    }
    
    @objc
    private func searchIconDidTapped() {
        let searchVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "MovieSearchViewController")
            as! MovieSearchViewController
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView?.isHidden = false
        tableView.register(CategoriesTableViewCell.nib,
                           forCellReuseIdentifier: CategoriesTableViewCell.identifier)
    }
    
    private func createHomeSection() -> [HomeSection] {
        var sections = [HomeSection]()
        Categories.allCases.forEach {
            sections.append(HomeSection(kind: $0, data: []))
        }
        return sections
    }
    
    private func loadData() {
        let dispatchGroup = DispatchGroup()
        homeSections = createHomeSection()
        
        for index in 0..<homeSections.count {
            let url = Constant.getCategoriesLink(for: homeSections[index].kind)
            dispatchGroup.enter()
            APIFeching().fetchingData(typeGeneric: CategoriesMovie.self, url: url) { [weak self] result in
                switch result {
                case .success(let movies):
                    guard let self = self else { return }
                    self.homeSections[index].data = movies.results
                case .failure(let error):
                    print("Error when fetching data \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            //reload data after fetching in here
            self.tableView.reloadData()
        }
    }
}

extension CategoriesMovieViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.identifier, for: indexPath) as! CategoriesTableViewCell
        cell.configure(movies: homeSections[indexPath.section].data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderCategoriesTableView(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.width,
            height: LayoutOptions.heightForHeaderInSection))
        headerView.configure(homeSection: homeSections[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LayoutOptions.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension CategoriesMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutOptions.heightForCellInSection
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
