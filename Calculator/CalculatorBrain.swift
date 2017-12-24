//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sai on 02/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation>=[
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({-$0}),
        "x": Operation.binaryOperation({$0*$1}),
        "/": Operation.binaryOperation({$0/$1}),
        "+": Operation.binaryOperation({$0+$1}),
        "-": Operation.binaryOperation({$0-$1}),
        "=": Operation.equals,
    ]
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator=value
            case .unaryOperation(let fun):
                if accumulator != nil{
                    accumulator=fun(accumulator!)
                }
            case .binaryOperation(let fun):
                if accumulator != nil{
                    pendingBinaryOperation=PendingBinaryOperation(fun: fun, firstOperand: accumulator!)
                    accumulator=nil
                }
            case .equals:
                performPendingBinaryOperation()
                break
            }
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator=pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation=nil
        }
    }
    
    private var pendingBinaryOperation:PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let fun: (Double,Double)->Double
        let firstOperand: Double
        func perform(with secondOperand:Double)->Double{
            return fun(firstOperand,secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator=operand
    }
    var result:Double?{
        get {
            return accumulator
        }
    }
}
