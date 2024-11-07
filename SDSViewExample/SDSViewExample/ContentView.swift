//
//  ContentView.swift
//
//  Created by : Tomoaki Yagishita on 2024/10/31
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSView
import PDFKit

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            Tab("PDFView", systemImage: "document", content: {
                PDFExampleView()
            })
            Tab("TextView", systemImage: "character.cursor.ibeam", content: {
                TextExampleView()
            })
        }
        .padding()
    }
    

}

#Preview {
    ContentView()
}

struct TextExampleView: View {
    @State private var viewModel = TextKitViewModel()
    @State private var text = "Hello TextKit"
    var body: some View {
        ScrollTextView(text: $text, textViewFactory: viewModel.textViewFactory, textViewUpdate: viewModel.textViewUpdate)
    }
}

struct PDFExampleView: View {
    var pdfDoc: PDFDocument?

    init() {
        self.pdfDoc = readPDF()
    }

    var body: some View {
        if let pdfDoc = pdfDoc {
            PDFPageView(pdfDocument: pdfDoc,
                        config: PDFPageViewConfig(displayMode: .singlePage, autoScales: true))
        } else {
            Text("NoPDF doc")
        }
    }
    func readPDF() -> PDFDocument? {
        guard let path = Bundle.main.path(forResource: "PDFSampleFile", ofType: "pdf") else { print("noPDF"); return nil }
        let filePath = URL(filePath: path)
        guard let pdfData = try? Data(contentsOf: filePath) else { print("noData"); return nil }
        return PDFDocument(data: pdfData)
    }
}
