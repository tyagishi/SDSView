//
//  TextKitViewMoewl+NSTextViewportLayoutControllerDelegate.swift
//
//  Created by : Tomoaki Yagishita on 2024/06/14
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSNSUIBridge
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import OSLog

extension OSLog {
    // static fileprivate var log = Logger(subsystem: "com.smalldesksoftware.vanillaTextView", category: "TextKitViewModel: NSTextViewportLayoutControllerDelegate")
    fileprivate static var log = Logger(.disabled)
}

#if false // use this as template
extension TextKitViewModel: NSTextViewportLayoutControllerDelegate {
    public func viewportBounds(for textViewportLayoutController: NSTextViewportLayoutController) -> CGRect {
        guard let textView = _textView else { return .zero }
        #if os(macOS)
        // implement from apple
        let overdrawRect = textView.preparedContentRect
        let visibleRect = textView.visibleRect
        var minY: CGFloat = 0
        var maxY: CGFloat = 0
        if overdrawRect.intersects(visibleRect) {
            // Use preparedContentRect for vertical overdraw and ensure visibleRect is included at the minimum,
            // the width is always bounds width for proper line wrapping.
            minY = min(overdrawRect.minY, max(visibleRect.minY, 0))
            maxY = max(overdrawRect.maxY, visibleRect.maxY)
        } else {
            // We use visible rect directly if preparedContentRect does not intersect.
            // This can happen if overdraw has not caught up with scrolling yet, such as before the first layout.
            minY = visibleRect.minY
            maxY = visibleRect.maxY
        }
        return CGRect(x: textView.bounds.minX, y: minY, width: textView.bounds.width, height: maxY - minY)
        #else
        return CGRect(origin: textView.contentOffset, size: textView.contentSize)
        #endif
    }
    
    public func textViewportLayoutControllerWillLayout(_ textViewportLayoutController: NSTextViewportLayoutController) {
        OSLog.log.debug(#function)
        #if os(macOS)
        contentView.subviews.removeAll()
        #else
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        #endif
    }
    public func textViewportLayoutControllerDidLayout(_ textViewportLayoutController: NSTextViewportLayoutController) {
        OSLog.log.debug(#function)
        updateTextViewSize()
        _textView?.needsDisplay = true
    }
    
    public func textViewportLayoutController(_ textViewportLayoutController: NSTextViewportLayoutController,
                                             configureRenderingSurfaceFor textLayoutFragment: NSTextLayoutFragment) {
        let fragmentView = fragmentViewMap.object(forKey: textLayoutFragment) ?? TextLayoutFragmentView(layoutFragment: textLayoutFragment, frame: .zero)

        fragmentView.frame = textLayoutFragment.layoutFragmentFrame

        OSLog.log.debug("draw \(textLayoutFragment.attrString?.string ?? "NoTxt")")
        contentView.addSubview(fragmentView)
        fragmentViewMap.setObject(fragmentView, forKey: textLayoutFragment)
        return
    }
    
    func updateTextViewSize() {
        guard let textView = _textView else { return }
        guard let textLayoutManager = textView.textLayoutManager else { return }
        let currentHeight = textView.bounds.height
        var height: CGFloat = 0
        // sometimes calculation for textFragmentFrame ignores intermediate line height (but this imple comes from Apple)
        // 途中の Fragment の高さを考慮しない maxY が設定されているケースがあるので、最後の要素だけをチェックするのは、ＮＧ
        // textLayoutManager.enumerateTextLayoutFragments(from: textLayoutManager.documentRange.endLocation,
        //                                                 options: [.reverse, .ensuresLayout]) { layoutFragment in
        //     height = layoutFragment.layoutFragmentFrame.maxY
        //     OSLog.log.debug("maxY: \(height)")
        //     return false // stop
        // }

        textLayoutManager.enumerateTextLayoutFragments(from: textLayoutManager.documentRange.location,
                                                       options: [.ensuresLayout]) { layoutFragment in
            //height += layoutFragment.layoutFragmentFrame.height
            height = layoutFragment.layoutFragmentFrame.maxY
            return true
        }
        height = max(height, _scrollView?.contentSize.height ?? 0)
        if abs(currentHeight - height) > 1e-10 {
            let contentSize = CGSize(width: textView.bounds.width, height: height)
            textView.setNSUIFrameSize(contentSize)
        }
    }
}
#endif

final class TextLayoutFragmentView: NSUIView {
    private let layoutFragment: NSTextLayoutFragment

    #if os(macOS)
    override var isFlipped: Bool { return true }
    #endif

    init(layoutFragment: NSTextLayoutFragment, frame: CGRect) {
        self.layoutFragment = layoutFragment
        super.init(frame: frame)
        needsLayout = true
        needsDisplay = true
        #if os(iOS)
        self.isOpaque = false
        #endif
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: CGRect) {
        #if os(macOS)
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        let pos: CGPoint = .zero
        #else
        guard let context = UIGraphicsGetCurrentContext() else { OSLog.log.debug("NoContext"); return }
        let pos: CGPoint = .zero //dirtyRect.origin
        #endif
        OSLog.log.debug("draw \(self.layoutFragment.attrString?.string ?? "NoTxt") at \(dirtyRect.debugDescription)")

        context.saveGState()
        layoutFragment.draw(at: pos, in: context)
        context.restoreGState()
    }
}
