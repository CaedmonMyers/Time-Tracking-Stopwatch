//
// Stopwatch
// CustomPicker.swift
//
// Created by Reyna Myers on 26/7/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI

struct PickerContent: View {
    var body: some View {
        ForEach(0...30, id: \.self) { number in
            Text(number.description)
                .rotationEffect(Angle(degrees: 90))
                .foregroundStyle(Color.white)
                .font(.system(.title2, design: .rounded, weight: .bold))
        }
    }
}


struct HorizontalNumberPicker: View {
    @Binding var selectedNumber: Int
    private let range = 0...10
    private let circleSize: CGFloat = 100
    private let spacing: CGFloat = 20

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = CGFloat(range.count) * (circleSize + spacing) - spacing
            let scrollViewWidth = geometry.size.width
            let padding = (scrollViewWidth - circleSize) / 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(range, id: \.self) { number in
                        Text("\(number)")
                            .font(.largeTitle)
                            .foregroundColor(self.selectedNumber == number ? .blue : .gray)
                            .frame(width: self.circleSize, height: self.circleSize)
                            .background(Circle().stroke(self.selectedNumber == number ? Color.blue : Color.gray, lineWidth: 2))
                            .id(number)
                            .onTapGesture {
                                withAnimation {
                                    self.selectedNumber = number
                                }
                            }
                    }
                }
                .padding(.horizontal, padding)
            }
            .content.offset(x: (CGFloat(selectedNumber) * -(circleSize + spacing)) + (scrollViewWidth / 2) - (circleSize / 2))
            .frame(width: scrollViewWidth)
            .onChange(of: geometry.frame(in: .global).minX) { newValue in
                let centerX = scrollViewWidth / 2
                let offset = newValue - padding
                let newSelectedNumber = Int(round((centerX - offset) / (circleSize + spacing)))
                if newSelectedNumber >= range.lowerBound && newSelectedNumber <= range.upperBound {
                    selectedNumber = newSelectedNumber
                }
            }
        }
        .frame(height: circleSize)
    }
}

#Preview {
    ContentView()
}
