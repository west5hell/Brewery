//
//  ContentView.swift
//  Brewery
//
//  Created by Pongt Chia on 31/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var brewList: [String] = []
    @State private var navigationPath = NavigationPath()
    @State private var term: BrewTerminology? = .formulae
    @State private var selectedFormula: String?
    @State private var brewCommandOutput: String = ""

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $term)
        } content: {
            List(listData, id: \.self, selection: $selectedFormula) {
                Text($0)
            }
        } detail: {
            if let selectedFormula {
                FormulaInfoView(formula: selectedFormula)
            } else {
                ContentUnavailableView(
                    "Select a Formula",
                    systemImage: "flask.fill",
                    description: Text(
                        "Choose an formula from the list to view info."
                    )
                )
            }
        }
        .onChange(of: term, { oldValue, newValue in
            if let newValue {
                load(command: "list --\(newValue.rawValue) --versions")
            }
        })
        .onAppear {
            load(command: "list --formula --versions")
        }
    }
    
    var listData: [String] {
        brewCommandOutput.split(separator: "\n").map { String($0) }
    }
    
    func load(command: String) {
        do {
            if let res = try Homebrew.run(command) {
                brewCommandOutput = res
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}

struct FormulaInfoView: View {
    let formula: String

    @State private var info: String = ""

    var body: some View {
        VStack {
            Button("Deps") {
                do {
                    if let res = try Homebrew.run("deps \(formula)") {
                        print(res)
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            .padding()

            ScrollView {
                VStack {
                    Text(info)
                }
                .padding()
            }
        }
        .navigationTitle(formula)
        .onAppear {
            loadInfo()
        }
        .onChange(of: formula) { _, _ in
            loadInfo()
        }
    }

    func loadInfo() {
        do {
            if let res = try Homebrew.run("info \(formula)") {
                info = res
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
