//
//  MovieByCategoryViewController.swift
//  MovieApp
//
//  Created by datNguyem on 15/11/2021.
//

import UIKit

final class MovieByCategoryViewController: UIViewController {
    @IBOutlet private weak var movieTableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var categories: Categories?
    private var page: Int = 1
    private var isLoading = false
    private var movies = [Movie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.movieTableView.reloadData()
            }
        }
    }
    enum LayoutOptions {
        static let movieCellHeight: CGFloat = 130
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
    }
    
    private func setupTableView() {
        movieTableView.contentInsetAdjustmentBehavior = .never
        movieTableView.contentInset.top = 20
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        refreshControl.tintColor = .white
        movieTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc
    private func reloadData() {
        if !isLoading {
            page = 1
            loadData()
        }
    }
    
    func loadData() {
        guard let categories = categories else { return }
        isLoading = true
        let url = Constant.getCategoriesLink(for: categories, page: page)
        APIFeching().fetchingData(typeGeneric: CategoriesMovie.self, url: url) { result in
            defer {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.refreshControl.endRefreshing()
                    self.movieTableView.tableFooterView = nil
                    self.isLoading = false
                }
            }
            switch result {
            case .success(let categoriesMovie):
                if self.page == 1 {
                    self.movies = categoriesMovie.results
                } else {
                    self.movies.append(contentsOf: categoriesMovie.results)
                }
            case .failure(let error):
                print("Error when fetching data \(error)")
            }
        }
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: LayoutOptions.movieCellHeight))
        let spinner = UIActivityIndicatorView()
        spinner.color = .white
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

extension MovieByCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
}
extension MovieByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutOptions.movieCellHeight
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffSet = scrollView.contentOffset.y
        let maxOffSet = scrollView.contentSize.height - scrollView.frame.size.height
        print(currentOffSet)
        print("max \(maxOffSet)")
        if currentOffSet > maxOffSet{
            if !isLoading {
                self.movieTableView.tableFooterView = createFooterView()
                page += 1
                loadData()
            }
        }
    }
}
