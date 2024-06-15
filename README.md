# SDSView

Wrapped NSView/UIView

## ScrollTextView
wrapped NSTextView in NSScrollView / UITextView (already inherit UIScrollView)

### ViewModel for ScrollTextView with TextKit
use TextKitViewModel as ViewModel (use View-based viewportLayout)
```
struct ContentView: View {
    @StateObject var viewModel = TextKitViewModel("InitialText")
    @State private var text: String = "InitialText"
    var body: some View {
        VStack {
            ScrollTextView(text: $text,
                           textViewFactory: viewModel.textViewFactory,
                           textViewUpdate: viewModel.textViewUpdate)
        }
        .padding()
    }
}
```

## ScrollCollectionView
wrapped NSCollectionView in NSScrollView

## ScrollOutlineView
wrapped NSOutlineView in NSScrollView

## ScrollTableView
wrapped NSTableView in NSScrollView

## WebView
wrapped WKWebView (already in NSScrollView/UISScrollView)
note: not implemented for iOS yet

## convenient functions

### savePanelForFileName (only for macOS)
### openPanelForFileName (only for macOS)
