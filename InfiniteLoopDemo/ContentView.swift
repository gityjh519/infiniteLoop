//
//  ContentView.swift
//  InfiniteLoopDemo
//
//  Created by yaojinhai on 2020/7/25.
//  Copyright © 2020 yaojinhai. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ViewController()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainViewController {
        MainViewController()
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = MainViewController 
    
    
}
