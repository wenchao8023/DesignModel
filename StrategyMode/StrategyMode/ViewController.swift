//
//  ViewController.swift
//  StrategyMode
//
//  Created by chao on 2017/9/21.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var index: NSInteger = 0
    
    let titleArr = ["正常收费", "满300返100", "打八折"]
    
    var total: Double = 0//总计
    
    @IBOutlet weak var receiveCash: UITextField!
    
    @IBOutlet weak var activeCash: UITextField!
    
    @IBOutlet weak var totalCash: UITextField!
    
    
    @IBAction func onCaculateAction(_ sender: Any) {
        
        
        
//        implementWithFactoryModel()
        
//        implementWithStrategyMode()
        
        /**
         不管是简单工厂模式 还是策略模式 都是在客户端判断类型 这样肯定是不可取的
         使用 简单工厂模式 + 策略模式
         */
        implemntByBoth()
    }
    
    // MARK: 简单工厂模式客户端实现
    func implementWithFactoryModel()
    {
        let cashFactory = CashFactory()
        let csuper = cashFactory.createCashAccept(type: titleArr[index])!
        
        let acturallyMoney = csuper.acceptCash(money: Double(receiveCash.text!)!)
        activeCash.text = String(acturallyMoney)
    }
    // MARK: 策略模式客户端实现
    func implementWithStrategyMode()
    {
        let cc = CashContext()
        let type: String = titleArr[index]
        switch type {
        case "正常收费":
            let cashNormal = CashNormal()
            cc.CashContext(csuper: cashNormal)
            break
        case "满300返100":
            let cr1 = CashReturn()
            cr1.cashReturn(moneyCondition: "300", moneyReturn: "100")
            cc.CashContext(csuper: cr1)
            break
        case "打八折":
            let cr2 = CashRebate()
            cr2.cashRebate(moneyRebate: "0.8")
            cc.CashContext(csuper: cr2)
            break
        default:
            break
        }
        
        var totalPrices:Double = 0
        totalPrices = cc.GetResult(money: Double(receiveCash.text!)!)
        activeCash.text = String(totalPrices)
        total = totalPrices + total
        totalCash.text = String(total)
    }
    
    // MARK: 简单工厂模式+策略模式的客户端实现
    func implemntByBoth()
    {
        var totalPrices:Double = 0
        let csuper = NewCashContext.init()
        csuper.newCashContext(type: titleArr[index])
        totalPrices = csuper.GetResult(money: Double(receiveCash.text!)!)
        total = total + totalPrices
        activeCash.text = String(totalPrices)
        totalCash.text = String(total)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = titleArr[index]
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



// MARK:
/// 现金收费抽象类
class CashSuper
{
    public func acceptCash(money: Double) ->Double { return 0 }
}

/// 正常收费子类 原价返回
class CashNormal: CashSuper
{
    override func acceptCash(money: Double) -> Double
    {
        return money
    }
}

/// 打折收费子类
class CashRebate: CashSuper
{
    /// 折率
    private var _moneyRebate: Double = 1
    public func cashRebate(moneyRebate: String)
    {
        _moneyRebate = Double(moneyRebate)!
    }
    
    override func acceptCash(money: Double) -> Double
    {
        return money * _moneyRebate
    }
}

/// 返利收费子类
class CashReturn: CashSuper
{
    private var _moneyCondition: Double = 0 //返利条件
    private var _moneyReturn : Double = 0 //返利值
    public func cashReturn(moneyCondition: String, moneyReturn: String)
    {
        _moneyCondition = Double(moneyCondition)!
        _moneyReturn = Double(moneyReturn)!
    }
    
    override func acceptCash(money: Double) -> Double {
        var result = money
        if (money >= _moneyCondition)
        {
            result = money - floor(money / _moneyCondition) * _moneyReturn
        }
        
        return result
    }
}

// MARK:
/// 这个还是延续上一次的简单工厂模式来实现的
class CashFactory
{
    public func createCashAccept(type: String) -> CashSuper!
    {
        var cs: CashSuper!
        switch type {
        case "正常收费":
            cs = CashNormal()
            break
        case "满300返100":
            let cr1 = CashReturn()
            cr1.cashReturn(moneyCondition: "300", moneyReturn: "100")
            cs = cr1
            break
        case "打八折":
            let cr2 = CashRebate()
            cr2.cashRebate(moneyRebate: "0.8")
            cs = cr2
            break
        default:
            break
        }
        return cs!
    }
}

// MARK: 

/**
 *  很显然，简单工厂模式并不能满足当打折条件变化之后的case，这里要引入【策略模式】
 *
 *  策略模式：定义了算法家族，分别封装起来，让它们之间可以相互替换
 *  好处   ：此模式让算法的变化，不会影响到使用算法的客户
 */
class CashContext
{
    private var _csuper = CashSuper()
    public func CashContext(csuper: CashSuper)
    {
        _csuper = csuper
    }
    
    public func GetResult(money: Double) ->Double
    {
        return _csuper.acceptCash(money:money)
    }
}

class NewCashContext
{
    var cs: CashSuper! = nil
    func newCashContext(type: String)
    {
        switch type {
        case "正常收费":
            cs = CashNormal()
            break
        case "满300返100":
            let cr1 = CashReturn()
            cr1.cashReturn(moneyCondition: "300", moneyReturn: "100")
            cs = cr1
            break
        case "打八折":
            let cr2 = CashRebate()
            cr2.cashRebate(moneyRebate: "0.8")
            cs = cr2
            break
        default:
            break
        }
    }
    
    func GetResult(money: Double) -> Double
    {
        return cs.acceptCash(money:money)
    }
    
}
