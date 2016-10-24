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
import RxSwift
import RxCocoa

class InitialViewController: UIViewController {
    
    
    //MARK: Private variables
    
    private var disposeBag = DisposeBag()
    
    private var spinner: UIActivityIndicatorView?
    
    
    //MARK: Outlets
    
    @IBOutlet weak var searchLocationButton: UIButton! {
        didSet {
            searchLocationButton.backgroundColor = .katangaYellow
            searchLocationButton.layer.cornerRadius = 30
            
            spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            spinner!.color = .black
            spinner!.center = CGPoint(x: 30, y: 30)

            searchLocationButton.addSubview(spinner!)
        }
    }

    @IBOutlet weak var metersSlider: UISlider!
    @IBOutlet weak var metersLabel: UILabel!
    
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRx()
    }
    
    
    //MARK: Private methods
    
    private func setUpRx() {
        metersSlider.rx.value
            .startWith(500)
            .map {"\(Int($0))"}
            .bindTo(metersLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        searchLocationButton.rx.tap
            .bindNext { [weak self] in
                self?.spinner?.startAnimating()
                self?.performSegue(withIdentifier: "shownearstops", sender: nil)
            }
            .addDisposableTo(disposeBag)
    }
}

