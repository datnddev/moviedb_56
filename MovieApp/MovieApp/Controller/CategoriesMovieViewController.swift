//
//  ViewController.swift
//  Movie App
//
//  Created by datNguyem on 19/10/2021.
//

import UIKit

struct HomeSection {
    var kind: Categories
    var data: [Movie]
}

final class CategoriesMovieViewController: UIViewController {
    private var homeSections = [HomeSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        dispatchGroup.notify(queue: .main) {
            //reload data after fetching in here
        }
    }
}
