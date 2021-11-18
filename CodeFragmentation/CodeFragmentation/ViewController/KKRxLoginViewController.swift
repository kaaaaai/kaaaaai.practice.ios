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

class KKRxLoginViewController: KKBaseViewController {
    override var isAutoDismiss: Bool { true }
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    @IBOutlet weak var signalButton: UIButton!
    
    var disposeBag = DisposeBag()

    var globalObserver: Single<String>?
    var subject1: BehaviorSubject<String>!
    var subject2: BehaviorSubject<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loginMethod()
        
//        signalMethod()
//        driverMethod()
        rxSwiftTest()
        
        let tap = signalButton.rx.tap.asSignal()
        tap.emit(onNext:
                    {
                        self.subject1.onNext(self.testOneMethod())
                        self.subject2.onNext(self.testTwoMethod())
                    }).disposed(by: disposeBag)

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
        
        event.drive(onNext: observer).disposed(by: disposeBag)

        let newObserver: () -> Void = { showAlert("弹出提示框 2")}
        event.drive(onNext: newObserver).disposed(by: disposeBag)
    }
    
    func signalMethod(){
        let showAlert: (String) -> Void = { mes in
            self.showAlert(mes: mes)
        }
        
        let event: Signal<Void> = signalButton.rx.tap.asSignal()
        
        let observer: ()-> Void = { showAlert("弹出提示框 1") }

        event.emit(onNext: observer).disposed(by: disposeBag)
        
        let newObserver: () -> Void = { showAlert("弹出提示框 2")}
        event.emit(onNext: newObserver).disposed(by: disposeBag)
    }
    
    
    func rxSwiftTest(){
        let subject1 = BehaviorSubject(value: self.testOneMethod())
        self.subject1 = subject1
        let subject2 = BehaviorSubject(value: self.testTwoMethod())
        self.subject2 = subject2
        
        let concat: Single<String> = Observable
            .concat(self.subject1, self.subject2).take(1).asSingle()
        self.globalObserver = concat
        
        
        self.globalObserver!.subscribe { (str) in
            print("Single: \(str)")
        } onError: { _ in
            print("error!!!!")
        }.dispose()
        
        let observable: Observable<String> = Observable.concat(self.subject1,self.subject2).take(1).asObservable()
        observable.subscribe(onNext: { string in
            print("Single: \(string)")
        }).dispose()

        self.subject1.onNext(self.testOneMethod())
        self.subject2.onNext(self.testTwoMethod())
    }
    
    func testOneMethod() -> String{
        let str = "testOneMethod"
        print(str)
        return str
        
    }
    
    func testTwoMethod() -> String{
        let str = "testTwoMethod"
        print(str)
        return str
    }
}
