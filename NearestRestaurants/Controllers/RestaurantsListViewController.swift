//
//  RestaurantsListViewController.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class RestaurantsListViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet private var tableView: UITableView! {
        didSet {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(
                self,
                action: #selector(getNearestRestaurants),
                for: .valueChanged
            )
            tableView.refreshControl = refreshControl
        }
    }
    
    //MARK: Properties
    private let imageLoadQueue = OperationQueue()
    private var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    private var restaurants: [Restaurant] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clearCache()
        LocationClient.shared.startUpdatinglocation()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Nearest Restaurants"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getNearestRestaurants), name: Constant.NotificationCenterKeys.updateLocations, object: nil)
    }

}

//MARK: - Configuration
private extension RestaurantsListViewController {
    
    func clearCache() {
        #if CLEAR_CACHES
            let cachesFolderItems = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
            for item in cachesFolderItems {
                try? FileManager.default.removeItem(atPath: item)
            }
        #endif
    }
    
    func configureTableView() {
        tableView.register(RestaurantInfoCell.self)
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.prefetchDataSource = self
    }
}

//MARK: - APIRequest
private extension RestaurantsListViewController {
    
    @objc func getNearestRestaurants() {
        let parameters: [String: Any] = [
            Foursquare.SearchKeys.Location: "\(LocationClient.shared.currentLatitude),\(LocationClient.shared.currentLongitude)",
            Foursquare.SearchKeys.venueDate : Date().getStringDate(withFormat: .venue),
            Foursquare.SearchKeys.Intent: "food",
            Foursquare.SearchKeys.Limit: "10",
            Foursquare.Client.ID.key: Foursquare.Client.ID.value,
            Foursquare.Client.Secret.key: Foursquare.Client.Secret.value
        ]

        let request = ApiRequest(resource: Restaurant())
        
        tableView.refreshControl?.beginRefreshing()

        request.load(withURLParameters: parameters, onSuccess: { [weak self] items in
            
            guard let strongSelf = self else { return }
            guard let items = items else { return }
            
            strongSelf.restaurants = items.sorted(by: { $0.distance < $1.distance })
            strongSelf.tableView.reloadData()
            strongSelf.tableView.refreshControl?.endRefreshing()

        }) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.handleRequestError()
        }
    }
    
    func loadImage(_ url: URL?, at indexPath: IndexPath, forCell cell: RestaurantInfoCell) {
        
        guard let url = url else { return }
        
        let imageLoadOperation = ImageLoadOperation(url: url)
        
        imageLoadOperation.onSuccess = { [weak self] (image) in
            guard let strongSelf = self else { return }
            cell.restaurantImage = image
            strongSelf.imageLoadOperations.removeValue(forKey: indexPath)
        }
        imageLoadQueue.addOperation(imageLoadOperation)
        imageLoadOperations[indexPath] = imageLoadOperation
    }
    
    func handleRequestError() {
        tableView.refreshControl?.endRefreshing()
        
        displayAlert(onComplete: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNearestRestaurants()
        })
    }
}

//MARK: - UITableViewDataSource
extension RestaurantsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !restaurants.isEmpty else { return 0 }
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RestaurantInfoCell = tableView.dequeueReusableCell(at: indexPath)
        cell.selectionStyle = .none
        let restaurant = restaurants[indexPath.row]
        cell.restaurant = restaurant
        
        if let imageLoadOperation = imageLoadOperations[indexPath],
            let image = imageLoadOperation.image {
            cell.restaurantImage = image
        } else {
            loadImage(restaurant.imageURL, at: indexPath, forCell: cell)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations[indexPath] else { return }
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension RestaurantsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = RestaurantDetailsViewController.instantiate()
        controller.restaurant = restaurants[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension RestaurantsListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if let _ = imageLoadOperations[indexPath] {
                return
            }
            let imageLoadOperation = ImageLoadOperation(url: restaurants[indexPath.row].imageURL!)
            imageLoadQueue.addOperation(imageLoadOperation)
            imageLoadOperations[indexPath] = imageLoadOperation
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations[indexPath] else {
                return
            }
            imageLoadOperation.cancel()
            imageLoadOperations.removeValue(forKey: indexPath)
        }
    }
}




