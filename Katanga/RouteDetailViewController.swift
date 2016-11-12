/**
*    Copyright 2016-today Software Craftmanship Toledo
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

/*!
@author Víctor Galán
*/

import UIKit
import RxCocoa
import RxSwift


class RouteDetailViewController : UIViewController, DataListTableView {
    
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 200
        }
    }
    
    typealias Model = BusStop
    typealias CellType = BusStopCell
    
    var viewModel: RouteDetailViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize(tableView: tableView)
        
        bindViewModel(tableView: tableView, driver: viewModel!.getBusStops())
            .addDisposableTo(disposeBag)
        
        viewModel?.routeId()
            .drive(rx.title)
            .addDisposableTo(disposeBag)
    }
    
    func fillCell(row: Int, element: Model, cell: CellType) {
        cell.busStopName = element.address
    }
}