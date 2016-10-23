//
//  NearBusStopsViewController.swift
//  Katanga
//
//  Created by Víctor Galán on 23/10/16.
//  Copyright © 2016 Software Craftsmanship Toledo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NearBusStopsViewController: UIViewController {
    
    
    //MARK: Private variables
    
    private var disposeBag = DisposeBag()
    private let activityIndicator = ActivityIndicator()
    
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(NearBusStopCell.self)
            tableView.tableFooterView = UIView()
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.hidesWhenStopped = true
        }
    }
    
    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.customizeTableView(withColor: .black)
        
        setupRx()
    }
    
    
    //MARK: Private methods
    
    private func setupRx() {
    
        //TODO Real values
        KatangaBusApiClient()
            .nearbyBusStops(latitude: 39.8628316, longitude: -4.0273231, meters: 500)
            .trackActivity(activityIndicator)
            .scan([], accumulator: { $0 + [$1] })
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellType: NearBusStopCell.self)) { row, nearBusStop, cell in
                cell.busStopName = nearBusStop.busStop.address
                
                let distanceFormatted = String(format: "%.2f", nearBusStop.distance)
                cell.distance = "(\(distanceFormatted) metros)"
                
                cell.items = nearBusStop.times
            }
            .addDisposableTo(disposeBag)
        
        
        activityIndicator
            .drive(spinner.rx.animating)
            .addDisposableTo(disposeBag)
    }
}
