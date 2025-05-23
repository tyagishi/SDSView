//
//  SwiftUIView.swift
//  SDSMarkdownEditView
//
//  Created by Tomoaki Yagishita on 2024/12/16.
//

import SwiftUI
import Combine
import SDSNSUIBridge
import SDSViewExtension

public protocol SearchTarget: ObservableObject {
    associatedtype SearchResult

    @MainActor func search(_ keyword: String,_ ignoreCase: Bool)

    var searchResultRanges: [SearchResult] { get }
    @MainActor func clearSearchResult()

    @MainActor func emphasizeNextSearchResult()
    @MainActor func emphasizePrevSearchResult()
    
    var targetChangedPublisher: AnyPublisher<Void,Never> { get }
}

/// SearchBar
///   search bar for target(SearchTarget compliant)
/// Functionality
///   1) textfield for search key text input(then trigger search)
///   2) react to text change, re-trigger search with key text
///   3) trigger search keyword highlight when request with index
///   4) ignorecase flag
///   5) able to control textfield focus from parent view
public struct SearchBar<T: SearchTarget>: View {
    @ObservedObject var target: T
    
    @State private var searchKey: String = ""
    @State private var ignoreCase = true
    
    public init(target: T) {
        self.target = target
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "text.magnifyingglass")
            ZStack {
                TextField("Search", text: $searchKey)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        target.search(searchKey, ignoreCase)
                    }
                    .onChange(of: searchKey, perform: { _ in
                        target.search(searchKey, ignoreCase)
                    })
                HStack {
                    Text("\(target.searchResultRanges.count) matches").font(.footnote)
                        .opacity(target.searchResultRanges.isEmpty ? 0.0 : 1.0)
                    Image(systemName: "x.circle")
                        .opacity(searchKey == "" ? 0.1 : 1.0)
                        .disabled(searchKey=="")
                        .onTapGesture { searchKey = ""; target.search("", ignoreCase) }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding(.trailing, 2)
            }
            .frame(width: 300)
            Button(action: { ignoreCase.toggle(); target.search(searchKey, ignoreCase) },
                   label: { Image(systemName: "textformat")
                    .modify({ if !ignoreCase { $0.foregroundStyle(.tint) } else { $0 } })
            })
            Button(action: {
                target.emphasizePrevSearchResult()
            }, label: { Image(systemName: "arrowtriangle.left") })
            .keyboardShortcut("g", modifiers: [.command, .shift])
            .disabled(target.searchResultRanges.isEmpty)
            Button(action: {
                target.emphasizeNextSearchResult()
            }, label: { Image(systemName: "arrowtriangle.right") })
            .keyboardShortcut("g", modifiers: [.command])
            .disabled(target.searchResultRanges.isEmpty)
        }
        .modify {
            if #available(macOS 14,*) {
                $0.buttonStyle(.accessoryBar)
            } else {
                $0
            }
        }
        .onReceive(target.targetChangedPublisher) { _ in
            target.clearSearchResult()
            target.search(searchKey, ignoreCase)
        }
    }
}
