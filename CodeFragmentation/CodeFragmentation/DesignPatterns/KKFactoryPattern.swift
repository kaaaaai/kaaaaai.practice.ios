//
//  KKFactoryPattern.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/7/30.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKFactoryPattern: NSObject {

    //MARK:单例模式
    @objc static let Headquarters = KKFactoryPattern()
    
    private override init() {}
    
    func factoryConstruction() {
        let c = Client()
        c.createProduct(type: 0).creatNail()
        
        let cSimple = SimpleClient()
        cSimple.s.createProduct(type: 0).creatNail()
        
        let cMethod = MethodClient()
        cMethod.f.createProduct(type: 0)?.creatNail()
        
        let cAbstract = AbstraClient()
        cAbstract.f.createProductA(type: 0)?.creatHammer()
        cAbstract.f.createProductB(type: 0)?.creatNail()
    }
}

//MARK: 工厂模式通用 协议、类
@objc
protocol Product {
    func creatNail()
    @objc optional func useNail() //添加 @objc optional 标记可选方法
}

class ConcreateProductA: Product {
    func creatNail() {
        NSLog("📍钉子 A 被创建了！")
    }
}

class ConcreateProductB: Product {
    func creatNail() {
        NSLog("📍钉子 B 被创建了！")
    }
}

//MARK:无工厂
class Client {
    func createProduct(type: Int) -> Product {
        if type == 0 {
            return ConcreateProductA()
        }else{
            return ConcreateProductB()
        }
    }
}

//MARK:简单工厂
class SimpleClient {
    let s = SimpleFactory()
}

class SimpleFactory {
    func createProduct(type: Int) -> Product {
        if type == 0 {
            return ConcreateProductA()
        }else{
            return ConcreateProductB()
        }
    }
}

//MARK:工厂方法
class MethodClient {
    let f = MethodFactory()
}

class MethodFactory {
    func createProduct() -> Product? { return nil } //用于继承
    func createProduct(type: Int) -> Product? { // 用于调用
        if type == 0 {
            return ConcreteFactoryA().createProduct()
        } else {
            return ConcreteFactoryB().createProduct()
        }
    }
}

//工厂子类实现初始化方法
class ConcreteFactoryA: MethodFactory {
    override func createProduct() -> Product? {
         // ... 产品加工过程
        return ConcreateProductA()
    }
}

class ConcreteFactoryB: MethodFactory {
    override func createProduct() -> Product? {
         // ... 产品加工过程
        return ConcreateProductB()
    }
}

//MARK: 抽象工厂
protocol ProductA {
    func creatHammer()
    func useHammer()
}

extension ProductA {
    func useHammer(){
        NSLog("使用锤子方法的可选实现")
    }
}

class ConcreateProductA1: ProductA {
    func creatHammer() {
        NSLog("🔨锤子1被创建了！")
    }
}

class ConcreateProductA2: ProductA {
    func creatHammer() {
        NSLog("🔨锤子2被创建了！")
    }
}


protocol ProductB {
    func creatNail()
    func useNail()
}

extension ProductB {
    func useNail() {
        NSLog("使用钉子方法的可选实现")
    }
}

class ConcreateProductB1: ProductB {
    func creatNail() {
        NSLog("📍钉子1被创建了！")
    }
}

class ConcreateProductB2: ProductB {
    func creatNail() {
        NSLog("📍钉子2被创建了！")
    }
}

class AbstraClient{
    let f = AbstraFactory()
}

class AbstraFactory {
    func createProductA() -> ProductA? {return nil} //用于继承
    func createProductB() -> ProductB? {return nil} //用于继承

    func createProductA(type: Int) -> ProductA? {//用于调用
        if type == 0 {
            return ConcreateFactory1().createProductA()
        }else{
            return ConcreateFactory2().createProductA()
        }
    }
    
    func createProductB(type: Int) -> ProductB? {//用于调用
        if type == 0 {
            return ConcreateFactory1().createProductB()
        }else{
            return ConcreateFactory2().createProductB()
        }
    }
}

class ConcreateFactory1: AbstraFactory{
    override func createProductA() -> ProductA? {
        // ... 产品加工过程
        return ConcreateProductA1()
    }
    
    override func createProductB() -> ProductB? {
        // ... 产品加工过程
        return ConcreateProductB1()
    }
}

class ConcreateFactory2: AbstraFactory {
    override func createProductA() -> ProductA? {
        // ... 产品加工过程
        return ConcreateProductA2()
    }
    
    override func createProductB() -> ProductB? {
        // ... 产品加工过程
        return ConcreateProductB2()
    }
}
