//
//  MovieResultViewController.swift
//  MovieApp
//
//  Created by datNguyem on 02/11/2021.
//

import UIKit

final class MovieSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var movieTableView: UITableView!
    @IBOutlet private weak var backImageView: UIImageView!
    private var genres = [Genre]()
    private var movies = [Movie]()
    private var selectedIndexPath: IndexPath? {
        didSet {
            print(selectedIndexPath)
        }
    }
    
    private enum LayoutOptions {
        static let defaultPadding: CGFloat = 8
        static let tableViewHeight: CGFloat = 130
        static let defaultItemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                            heightDimension: .absolute(48))
        static let selectedSectionInsets = NSDirectionalEdgeInsets(top: 1,
                                                                   leading: 20,
                                                                   bottom: 1,
                                                                   trailing: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        setupTableView()
        getGenres()
        setupAction()
    }
    
    private func setupAction() {
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        )
    }
    
    @objc
    private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.layer.backgroundColor = UIColor.white.cgColor
        searchField?.textColor = .hex_0E1A2B
    }
    
    private func setupTableView() {
        movieTableView.keyboardDismissMode = .onDrag
        movieTableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
    
    @objc
    private func movieTableViewDidTapped() {
        view.endEditing(true)
    }
    
    private func setupCollectionView() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: createLayout(), configuration: config)
        genreCollectionView.setCollectionViewLayout(layout, animated: false)
        genreCollectionView.register(GenreCollectionViewCell.nib,
                                     forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
    }
    
    private func createLayout() -> NSCollectionLayoutSection {
        let itemSize = LayoutOptions.defaultItemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = LayoutOptions.selectedSectionInsets
        section.interGroupSpacing = LayoutOptions.defaultPadding
        return section
    }
    
    private func getGenres() {
        APIFeching().fetchingData(typeGeneric: Genres.self, url: Constant.getGenresLink()) { result in
            switch result {
            case .success(let genres):
                self.genres = genres.genres
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.genreCollectionView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func searchMovie(query: String, genre: Genre?){
        APIFeching().fetchingData(typeGeneric: CategoriesMovie.self,
                                  url: Constant.getSearchLink(query: query, genre: genre)) { result in
            switch result {
            case .success(let movies):
                self.movies = movies.results
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.movieTableView.reloadData()
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            view.endEditing(true)
            return
        }
        guard let indexPath = selectedIndexPath else {
            view.endEditing(true)
            searchMovie(query: query, genre: nil)
            return
        }
        view.endEditing(true)
        searchMovie(query: query, genre: genres[indexPath.row])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension MovieSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier,
                                                      for: indexPath) as! GenreCollectionViewCell
        cell.configure(title: genres[indexPath.row].name)
        return cell
    }
}

extension MovieSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! GenreCollectionViewCell
        
        if cell.isSelected {
            selectedIndexPath = nil
            collectionView.selectItem(at: nil, animated: false, scrollPosition: [])
            return false
        }
        selectedIndexPath = indexPath
        return true
    }
}

extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                 for: indexPath) as! MovieTableViewCell
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
}

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutOptions.tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController")
            as MovieDetailViewController
        detailVC.movieId = movies[indexPath.row].id
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

