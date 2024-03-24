//
//  ContentView.swift
//  Calculator
//
//  Created by Ludovic Belzile on 2024-03-23.
//

import SwiftUI

struct CalculatorView: View {
    @ObservedObject var model = CalculatorModel()
    
    static private let buttonHorizontalSpacing: CGFloat = 12
    static private let buttonVerticalSpacing: CGFloat = 12
    static private let numberOfButtonsPerRow: CGFloat = 4
    static private let zeroButtonWidthMultiplier: CGFloat = 2
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Text(model.value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .overlay(
                            GeometryReader { proxy in
                                Color.clear
                                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .trailing)
                            }
                        )
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: CalculatorView.buttonHorizontalSpacing) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func didTap(button: CalcButton) {
        model.didTap(button: button)
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        let availableWidth = UIScreen.main.bounds.width - (CalculatorView.numberOfButtonsPerRow + 1) * CalculatorView.buttonHorizontalSpacing
        return item == .zero ? 10 + availableWidth / CalculatorView.numberOfButtonsPerRow * CalculatorView.zeroButtonWidthMultiplier : availableWidth / CalculatorView.numberOfButtonsPerRow
    }
    
    func buttonHeight() -> CGFloat {
        let availableWidth = UIScreen.main.bounds.width - (CalculatorView.numberOfButtonsPerRow + 1) * CalculatorView.buttonHorizontalSpacing
        return availableWidth / CalculatorView.numberOfButtonsPerRow
    }
}


struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}
