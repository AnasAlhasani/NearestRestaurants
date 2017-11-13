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
    private var restaurants: [Restaurant] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nearest Restaurants"
        LocationClient.shared.startUpdatinglocation()
        configureTableView()
        getNearestRestaurants()
    }

}

//MARK: - Configuration
private extension RestaurantsListViewController {
    
    func configureTableView() {
        tableView.register(RestaurantInfoCell.self)
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

//MARK: - APIRequest
private extension RestaurantsListViewController {
    
    @objc func getNearestRestaurants() {
        let parameters: [String: Any] = [
            Foursquare.SearchKeys.Location: "31.9685694,35.898531",
            Foursquare.SearchKeys.v : "20170901",
            Foursquare.SearchKeys.Intent: "food",
            Foursquare.SearchKeys.Limit: "10",
            Foursquare.Client.ID.key: Foursquare.Client.ID.value,
            Foursquare.Client.Secret.key: Foursquare.Client.Secret.value
        ]
        
        let request = ApiRequest(resource: Restaurant())
        
        tableView.refreshControl?.beginRefreshing()
        
        request.loadData(withParameters: parameters, onSuccess: { [weak self] items in
            
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
        cell.restaurant = restaurants[indexPath.row]
        return cell
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

