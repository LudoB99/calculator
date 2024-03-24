//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Ludovic Belzile on 2024-03-23.
//
import Foundation

enum Operation {
    case add, subtract, multiply, divide, none
}

class CalculatorModel: ObservableObject {
    @Published var value = "0"
    private var currentOperand = ""
    private var firstOperand = ""
    private var currentOperation: Operation = .none
    private var hasDecimal = false
    
    func didTap(button: CalcButton) {
        switch button {
        case .clear:
            clear()
        case .negative:
            toggleNegative()
        case .percent:
            percent()
        case .decimal:
            appendDecimal()
        case .equal:
            performOperation()
        default:
            if let digit = Int(button.rawValue) {
                appendDigit(digit)
            } else {
                // Handle other operations
                let operation: Operation
                switch button {
                case .add:
                    operation = .add
                case .subtract:
                    operation = .subtract
                case .multiply:
                    operation = .multiply
                case .divide:
                    operation = .divide
                default:
                    return
                }
                handleOperation(operation)
            }
        }
    }
    
    private func appendDigit(_ digit: Int) {
        currentOperand += "\(digit)"
        value = currentOperand
    }
    
    private func appendDecimal() {
        if !hasDecimal {
            currentOperand += "."
            value = currentOperand
            hasDecimal = true
        }
    }
    
    private func toggleNegative() {
        if value.prefix(1) == "-" {
            currentOperand.removeFirst()
            value = currentOperand
        } else {
            currentOperand = "-" + currentOperand
            value = currentOperand
        }
    }
    
    private func percent() {
        guard value != "0", let currentValue = Double(value) else { return }
        currentOperand = String(currentValue / 100)
        value = currentOperand
    }
    
    private func handleOperation(_ operation: Operation) {
        if currentOperand.isEmpty {
            if let lastValue = Double(value) {
                firstOperand = "\(lastValue)"
            }
        } else {
            firstOperand = currentOperand
            currentOperand = ""
        }
        currentOperation = operation
    }
    
    private func performOperation() {
        if currentOperand.isEmpty {
            currentOperand = "0"
        }
        if let firstValue = Double(firstOperand), let secondValue = Double(currentOperand) {
            switch currentOperation {
            case .add:
                let result = firstValue + secondValue
                value = isInteger(result) ? "\(Int(result))" : "\(result)"
            case .subtract:
                let result = firstValue - secondValue
                value = isInteger(result) ? "\(Int(result))" : "\(result)"
            case .multiply:
                let result = firstValue * secondValue
                value = isInteger(result) ? "\(Int(result))" : "\(result)"
            case .divide:
                if secondValue != 0 {
                    let result = firstValue / secondValue
                    value = isInteger(result) ? "\(Int(result))" : "\(result)"
                } else {
                    value = "Error"
                }
            case .none:
                break
            }
        }
        currentOperand = value
    }
    
    private func isInteger(_ number: Double) -> Bool {
        return number.truncatingRemainder(dividingBy: 1) == 0
    }
    
    private func clear() {
        value = "0"
        currentOperand = ""
        firstOperand = ""
        currentOperation = .none
        hasDecimal = false
    }
}
