//
// Stopwatch
// ContentView.swift
//
// Created by Reyna Myers on 26/7/24
//
// Copyright ©2024 DoorHinge Apps.
//


import SwiftUI

struct ContentView: View {
    @State private var elapsedTime: TimeInterval = 0.0
    @State private var isRunning = false
    @State private var penaltyNumber = 0
    @State private var times: [PersonType] = []
    @State private var showAlert = false
    @State private var newPersonName: String = ""
    
    @State var updateStates = false
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: [Color(hex: "434343"), Color(hex: "161616")], startPoint: .top, endPoint: .bottom)
                
                ScrollView {
                    VStack {
                        Text(timeString(from: elapsedTime + Double(penaltyNumber)))
                            .font(.system(size: 150, weight: .regular, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.top, 50)
                        
                        controlButtons
                            .zIndex(10.0)
                        
                        if !isRunning && elapsedTime != 0.0 {
                            penaltyPicker
                                .zIndex(0.0)
                            
                            addMenu
                                .zIndex(10.0)
                        }
                        
                        Spacer()
                            .frame(height: 50)
                        
                        ScrollView {
                            ForEach(times, id: \.id) { personTime in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.3))
                                    
                                    VStack {
                                        Text(personTime.name)
                                            .padding(10)
                                            .foregroundStyle(Color.white)
                                            .font(.system(.title2, design: .rounded, weight: .bold))
                                            .underline(true, pattern: .solid, color: .white)
                                        
                                        
                                            if personTime.times.count >= 2 {
                                                HStack {
                                                    Spacer()
                                                    
                                                    VStack {
                                                        Text("Most Recent")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                        
                                                        Text(timeString(from: personTime.times.last!))
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    VStack {
                                                        Text("Second Most Recent")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                        
                                                        Text(timeString(from: personTime.times[personTime.times.count - 2]))
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    VStack {
                                                        Text("Fastest")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                        
                                                        Text(timeString(from: personTime.times.min()!))
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                    }
                                                    
                                                    Spacer()
                                                    
//                                                    Text(personTime.times.description)
//                                                        .font(.system(size: 4))
                                                }
                                            } else if personTime.times.count == 1 {
                                                HStack {
                                                    Spacer()
                                                    
                                                    VStack {
                                                        Text("Most Recent")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                        
                                                        Text(timeString(from: personTime.times.first!))
                                                            .font(.title3)
                                                            .foregroundColor(.white)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    VStack {
                                                        Text("Fastest")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                        
                                                        Text(timeString(from: personTime.times.first!))
                                                            .font(.title3)
                                                            .foregroundColor(.white)
                                                    }
                                                    
                                                    Spacer()
                                                }
                                            } else {
                                                Text("No times recorded")
                                                    .font(.body)
                                                    .foregroundColor(.white)
                                            }
                                        
                                    }
                                    .padding(10)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        times = times.filter { $0.id != personTime.id }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }.padding(10)
                            .scrollIndicators(.hidden)
                            .frame(maxHeight: geo.size.height)
                    }
                }
            }
            .ignoresSafeArea()
            .onReceive(timer) { _ in
                if isRunning {
                    elapsedTime += 0.01
                }
            }
            .alert("Add New Person", isPresented: $showAlert) {
                TextField("Enter name", text: $newPersonName)
                
                Button("Cancel", role: .cancel) {
                    showAlert = false
                }
                Button("Add", action: addNewPerson)
            }
        }
    }
    
    var controlButtons: some View {
        HStack {
            Spacer()
            Button(action: resetTimer) {
                buttonView(label: "Reset", colorHex: "3576A6")
            }
            Spacer()
            Button(action: toggleTimer) {
                buttonView(label: isRunning ? "Pause" : "Start", colorHex: isRunning ? "B62741" : "0F822C")
            }
            Spacer()
        }
    }
    
    var addMenu: some View {
        Menu {
            ForEach(uniqueNames(), id: \.self) { name in
                Button(name) {
                    addTimeToPerson(name: name)
                    
                    resetTimer()
                }
            }
            
            Button {
                showAlert = true
            } label: {
                Label("Add New Name", systemImage: "plus")
            }

        } label: {
            buttonView(label: "Add", colorHex: "35A67D")
        }
    }
    
    var penaltyPicker: some View {
        VStack {
                Text("Add Penalty")
                    .foregroundStyle(Color.white)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                
                pickerStack
        }
        .padding(.top, 50)
    }
    
    var pickerStack: some View {
        ZStack {
            HStack {
                Spacer()
                
                CircleView(colorHex: "3576A6")
                
                Spacer()
            }
            
            pickerOverlay
        }
    }
    
    var pickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.1)
                .frame(width: 65)
            
            Picker("", selection: $penaltyNumber) {
                ForEach(0...30, id: \.self) { number in
                    Text(number.description)
                        .rotationEffect(Angle(degrees: 90))
                        .foregroundStyle(Color.white)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 200)
            .scaleEffect(2)
            .rotationEffect(Angle(degrees: -90))
        }
        .frame(height: 75)
        .clipped()
    }
    
    func uniqueNames() -> [String] {
        Set(times.map { $0.name }).sorted()
    }
    
    func addTimeToPerson(name: String) {
        if let index = times.firstIndex(where: { $0.name == name }) {
            times[index].times.append(elapsedTime + Double(penaltyNumber))
        }
    }
    
    func addNewPerson() {
        let newPerson = PersonType(name: newPersonName, times: [])
        times.append(newPerson)
        
        addTimeToPerson(name: newPersonName)
        
        newPersonName = ""
        showAlert = false
        
        resetTimer()
    }
    
    func resetTimer() {
        elapsedTime = 0.0
        isRunning = false
        penaltyNumber = 0
    }
    
    func toggleTimer() {
        isRunning.toggle()
    }
    
    func buttonView(label: String, colorHex: String) -> some View {
        ZStack {
            Capsule()
                .stroke(Color(hex: colorHex), lineWidth: 2)
            
            Capsule()
                .fill(Color(hex: colorHex))
                .padding(4)
            
            Text(label)
                .foregroundStyle(Color.white)
                .font(.system(.title2, design: .rounded, weight: .bold))
        }
        .frame(width: 200, height: 70)
    }
    
    func CircleView(colorHex: String) -> some View {
        ZStack {
            Circle()
                .stroke(Color(hex: colorHex), lineWidth: 2)
            
            Circle()
                .fill(Color(hex: colorHex))
                .padding(4)
        }.frame(height: 70)
    }
    
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}

#Preview {
    ContentView()
}
