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
    var pdfDoc: PDFDocument?
    
    init() {
        self.pdfDoc = readPDF()
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            if let pdfDoc = pdfDoc {
                PDFPageView(pdfDocument: pdfDoc,
                            config: PDFPageViewConfig(displayMode: .singlePage, autoScales: true))
            } else {
                Text("NoPDF doc")
            }
        }
        .padding()
    }
    
    func readPDF() -> PDFDocument? {
        guard let path = Bundle.main.path(forResource: "PDFSampleFile", ofType: "pdf") else { print("noPDF"); return nil }
        let filePath = URL(filePath: path)
        guard let pdfData = try? Data(contentsOf: filePath) else { print("noData"); return nil }
        return PDFDocument(data: pdfData)
    }
}

#Preview {
    ContentView()
}
