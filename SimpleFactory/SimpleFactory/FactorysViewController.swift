//
//  FactorysViewController.swift
//  SimpleFactory
//
//  Created by chao on 2017/9/5.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

import UIKit



class FactorysViewController: UIViewController {

    
    var index: Int = 0
    
    
    @IBOutlet weak var textFieldA: UITextField!
    @IBOutlet weak var textFieldChar: UITextField!
    @IBOutlet weak var textFieldB: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch index {
        case 0:
            self.title = "未使用工厂模式"
        case 1:
            self.title = "业务的封装"
        case 2:
            self.title = "简单工厂模式"
        default:
            break
        }
        
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onResetAction(_ sender: Any) {
        
        self.textFieldA.text = nil
        self.textFieldChar.text = nil
        self.textFieldB.text = nil
    }
    
    @IBAction func onCalculateAction(_ sender: Any) {
        
        switch index {
        case 0:
            let newText = calculate(a: textFieldA.text!, c: textFieldChar.text!, b: textFieldB.text!)
            self.showCalculateResult(newText: newText)
        case 1:
            let newText = calcuSimpleFactory(a: textFieldA.text!, c: textFieldChar.text!, b: textFieldB.text!)
            self.showCalculateResult(newText: newText)
        case 2:
            let oper: Operation!
            oper = OperationFactory.createOperate(operate: textFieldChar.text!)!
            oper.NumberA = Double(textFieldA.text!)!
            oper.NumberB = Double(textFieldB.text!)!
            let result = oper.GetResult()
            self.showCalculateResult(newText:  String(result))
            
        default:
            break
        }
        
    }
    
    func showCalculateResult(newText: String)
    {
        if var originText = textView.text
        {
            originText = originText.appending("\n")
            originText = originText.appending(newText)
            self.textView.text = originText
        }
        else
        {
            self.textView.text = newText
        }
    }
    
    /**
     1. 直接计算
     */
    func calculate(a: String, c: String, b: String) -> String
    {
        var result : Float
        switch c {
        case "+":
            result = Float(a)! + Float(b)!
        case "-":
            result = Float(a)! - Float(b)!
        case "*":
            result = Float(a)! * Float(b)!
        case "/":
            result = Float(a)! / Float(b)!
        default:
            return "我不认识你" + " \(c)"
        }
        
        return "\(a) \(c) \(b) = \(result)"
    }
    
    /**
     2. 业务的封装
     */
    func calcuSimpleFactory(a: String, c: String, b: String) -> String {
        let numberA = Double(a)!
        let numberB = Double(b)!
        
        let opClass = SimpleOperation()
        let result = opClass.GetResult(numberA: numberA, numberB: numberB, operate: c)
        
        return "\(a) \(c) \(b) = \(result)"
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

/// 计算类
class SimpleOperation: NSObject
{
    public func GetResult(numberA: Double, numberB: Double, operate: String) -> Double
    {
        var result: Double = 0
        
        switch operate {
        case "+":
            result = numberA + numberB
        case "-":
            result = numberA - numberB
        case "*":
            result = numberA * numberB
        case "/":
            result = numberA / numberB
        default: break
        }
        
        return result
    }
}


/**
 *  简单工厂模式，运算父类
 */
public class Operation
{
    private var _numberA: Double = 0
    private var _numberB: Double = 0
    
    
    public var NumberA: Double {
        get { return _numberA }
        set { _numberA = newValue }
    }
    
    public var NumberB: Double {
        get { return _numberB }
        set { _numberB = newValue }
    }
    
    public func GetResult() -> Double
    {
        let result: Double = 0
        return result
    }
}

/**
 *  加减乘除类
 */

class OperationAdd: Operation
{
    public override func GetResult() -> Double
    {
        var result: Double = 0
        result = NumberA + NumberB
        return result
    }
}

class OperationSub: Operation
{
    public override func GetResult() -> Double
    {
        var result: Double = 0
        result = NumberA - NumberB
        return result
    }
}

class OperationMul: Operation
{
    public override func GetResult() -> Double
    {
        var result: Double = 0
        result = NumberA * NumberB
        return result
    }
}

class OperationDiv: Operation
{
    public override func GetResult() -> Double
    {
        var result: Double = 0
        if NumberB == 0 {
//            throw exception("除数不能为0")
            print("除数不能为0")
            return result
        }
        result = NumberA / NumberB
        return result
    }
}

/**
 *  简单工厂模式的实现
 */
public class OperationFactory
{
    public static func createOperate(operate: String) ->Operation!
    {
        var oper: Operation!
        switch operate {
        case "+":
            oper = OperationAdd()
        case "-":
            oper = OperationSub()
        case "*":
            oper = OperationMul()
        case "/":
            oper = OperationDiv()
        default:
            break
        }
        return oper
    }
}




