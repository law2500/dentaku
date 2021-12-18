//
//  ContentView.swift
//  denntakuApp
//

import SwiftUI

enum CaluculateState {
    case initisl, purasu, paasento, mainasu, kakuru, sum
}

struct ContentView: View {
    
    @State var selectedIteme: String = "0"
    @State var caluculateNumber: Double = 0
    @State var caluculateState: CaluculateState = .initisl
    
    private let caluculateItems: [[String]] = [
        ["AC","+/-","%","+"],
        ["7","8","9","*"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="]
    ]
    
    private let numbers: [String] = ["1","2","3","4","5","6","7","8","9"]
    private let symbols: [String] = ["+","-","*","="]
    
    private let buttoonWidth = (UIScreen.main.bounds.width - 50) / 4
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text(selectedIteme  == "0" ? check(number: caluculateNumber) : selectedIteme)
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(.white)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack {
                    ForEach(caluculateItems, id: \.self) { items in
                        NumberView(selectedIteme: $selectedIteme, caluculateNumber: $caluculateNumber, caluculateState: $caluculateState, items: items)
                        
                        
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    private func check(number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne) {
            return String(Int(number))
        } else {
            return String(Int(number))
        }
    }
}




struct NumberView: View {
    
    @Binding var selectedIteme: String
    @Binding var caluculateNumber: Double
    @Binding var caluculateState: CaluculateState
    
    var items: [String]
    private let buttoonWidth = (UIScreen.main.bounds.width - 50) / 4
    private let numbers: [String] = ["1","2","3","4","5","6","7","8","9","0","."]
    private let symbols: [String] = ["+","-","*","="]
    
    var body: some View {
        
        HStack {
            ForEach(items, id: \.self) { item in
                
                Button {
                    handleButtonInfo(item: item)
            
                } label: {
                    Text(item)
                        .font(.system(size: 30, weight: .regular))
                        .frame(minWidth: 0 ,maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity)
                }
                .foregroundColor(numbers.contains(item) || symbols.contains(item) ? .white : .black)
                .background(handleButtonColor(item: item))
                .frame(width: item == "0" ?  buttoonWidth * 2 + 10 : buttoonWidth)
                .cornerRadius(buttoonWidth)

            }
            .frame(height: buttoonWidth)
        }
    }
    
    private func handleButtonColor(item: String) -> Color {
        if numbers.contains(item) {
            return Color(white: 0.2, opacity: 1)
        } else if symbols.contains(item) {
            return .orange
        }else {
            return Color(white: 0.8, opacity: 1)
        }
            
    }
    
    private func handleButtonInfo(item: String) {
        if numbers.contains(item) {
            
            if item == "." && (selectedIteme.contains(".") || selectedIteme.contains("0")) {
                return
            }
            
            
            if selectedIteme.count >= 10 {
                return
            }
            
            if selectedIteme == "0" {
                selectedIteme = item
                return
            }
            
            selectedIteme += item
        } else if item == "AC" {
            selectedIteme = "0"
            caluculateNumber = 0
            caluculateState = .initisl
        }
        
        guard let selectedNumber = Double(selectedIteme) else {return}
        
        if item == "%" {
            statHo(state: .paasento, selectedtNumber: selectedNumber)
        } else if item == "*" {
            statHo(state: .kakuru, selectedtNumber: selectedNumber)
        } else if item == "-" {
            statHo(state: .mainasu, selectedtNumber: selectedNumber)
            
        }else if item == "+" {
            statHo(state: .purasu, selectedtNumber: selectedNumber)
            
        }else if item == "=" {
            
            caluclate(selectedtNumber: selectedNumber)
            caluculateState = .sum
            selectedIteme = String(caluculateNumber)
        }
        
        
    }
    
    private func statHo(state: CaluculateState, selectedtNumber: Double ) {
        if selectedIteme == "0"{
            caluculateState = state
            return
        }
        
        selectedIteme = "0"
        caluculateState = state
        caluclate(selectedtNumber: selectedtNumber)
    }
    
    private func caluclate(selectedtNumber: Double) {
        
        if caluculateNumber == 0 {
            caluculateNumber = selectedtNumber
            return
        }
        
        switch caluculateState {
            
        case .purasu:
            caluculateNumber = caluculateNumber + selectedtNumber
        case .paasento:
            caluculateNumber = caluculateNumber / selectedtNumber
        case .mainasu:
            caluculateNumber = caluculateNumber - selectedtNumber
        case .kakuru:
            caluculateNumber = caluculateNumber * selectedtNumber
        default:
            break
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

