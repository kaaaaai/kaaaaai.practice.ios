//
//  KKRxLoginViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/2/23.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class KKRxLoginViewController: UIViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    @IBOutlet weak var signalButton: UIButton!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginMethod()
        
//        signalMethod()
        driverMethod()
    }
    
    func loginMethod(){
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    
    func showAlert(mes: String = "This is wonderful") {
        let alertView = UIAlertController(title: "RxExample", message: mes, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertView.addAction(action)
       self.present(alertView, animated: true, completion: nil)
    }
}

extension KKRxLoginViewController{
    func driverMethod(){
        let showAlert: (String) -> Void = { mes in
            self.showAlert(mes: mes)
        }
        
        let event: Driver<Void> = signalButton.rx.tap.asDriver()
        
        let observer: ()-> Void = { showAlert("弹出提示框 1") }
        
        event.drive(onNext: observer)
//
        let newObserver: () -> Void = { showAlert("弹出提示框 2")}
        event.drive(onNext: newObserver)
    }
    
    func signalMethod(){
        let showAlert: (String) -> Void = { mes in
            self.showAlert(mes: mes)
        }
        
        let event: Signal<Void> = signalButton.rx.tap.asSignal()
        
        let observer: ()-> Void = { showAlert("弹出提示框 1") }

        event.emit(onNext: observer)
        
        let newObserver: () -> Void = { showAlert("弹出提示框 2")}
        event.emit(onNext: newObserver)
    }
}
