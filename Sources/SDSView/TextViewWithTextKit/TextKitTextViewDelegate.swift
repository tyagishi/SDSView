//
//  TextKitTextViewDelegate.swift
//
//  Created by : Tomoaki Yagishita on 2024/06/15
//  © 2024  SmallDeskSoftware
//

import SwiftUI
import SDSNSUIBridge
#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public final class TextKitTextViewDelegate: NSObject, NSUITextViewDelegate {
    @Binding var text: String
    weak var textViewDelegate: NSUITextViewDelegate? = nil
    
    public init(_ text: Binding<String>) {
        self._text = text
    }
    
    public func nsuiTextDidChange(_ textView: NSUITextView) {
        text = textView.string
        #if os(iOS)
        forceLayout(textView)
        #endif
    }
    
    public func forceLayout(_ textView: NSUITextView) {
        guard let textLayoutManager = textView.textLayoutManager else { return }
        textLayoutManager.textViewportLayoutController.layoutViewport()
    }
    
    #if os(macOS)
    // MARK: NSTextDelegate
    @MainActor 
    public func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        textViewDelegate?.textShouldBeginEditing?(textObject) ?? true // YES means do it
    }

    @MainActor 
    public func textShouldEndEditing(_ textObject: NSText) -> Bool {
        textViewDelegate?.textShouldEndEditing?(textObject) ?? true // YES means do it
    }

    @MainActor
    public func textDidBeginEditing(_ notification: Notification) {
        textViewDelegate?.textDidBeginEditing?(notification)
    }

    @MainActor
    public func textDidEndEditing(_ notification: Notification) {
        textViewDelegate?.textDidEndEditing?(notification)
    }

    @MainActor
    public func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSUITextView else { return }
        textViewDelegate?.textDidChange?(notification)
        nsuiTextDidChange(textView)
    }
    
    // MARK: NSTextViewDelegate
    // note: add implementation one by one when it is necessary
    @MainActor
    public func undoManager(for view: NSTextView) -> UndoManager? { textViewDelegate?.undoManager?(for: view) }

    @MainActor
    public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        textViewDelegate?.textView?(textView, doCommandBy: commandSelector) ?? false
    }

    @MainActor
    public func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        textViewDelegate?.textView?(view, menu: menu, for: event, at: charIndex)
    }

    // swiftlint:disable all
    // Delegate only.
    //@MainActor func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool { }
    
//
//
//    // Delegate only.
//    @MainActor optional func textView(_ textView: NSTextView, clickedOn cell: any NSTextAttachmentCellProtocol, in cellFrame: NSRect, at charIndex: Int)
//
//
//    // Delegate only.
//    @MainActor optional func textView(_ textView: NSTextView, doubleClickedOn cell: any NSTextAttachmentCellProtocol, in cellFrame: NSRect, at charIndex: Int)
//
//
//    // Delegate only.  Allows the delegate to take over attachment dragging altogether.
//    @MainActor optional func textView(_ view: NSTextView, draggedCell cell: any NSTextAttachmentCellProtocol, in rect: NSRect, event: NSEvent, at charIndex: Int)
//
//
//    // Delegate only.  If the previous method is not used, this method and the next allow the textview to take care of attachment dragging and pasting, with the delegate responsible only for writing the attachment to the pasteboard.  In this method, the delegate should return an array of types that it can write to the pasteboard for the given attachment.
//    @MainActor optional func textView(_ view: NSTextView, writablePasteboardTypesFor cell: any NSTextAttachmentCellProtocol, at charIndex: Int) -> [NSPasteboard.PasteboardType]
//
//
//    // Delegate only.  In this method, the delegate should attempt to write the given attachment to the pasteboard with the given type, and return success or failure.
//    @MainActor optional func textView(_ view: NSTextView, write cell: any NSTextAttachmentCellProtocol, at charIndex: Int, to pboard: NSPasteboard, type: NSPasteboard.PasteboardType) -> Bool
//
//
//    // Delegate only.  Will not be called if textView:willChangeSelectionFromCharacterRanges:toCharacterRanges: is implemented.  Effectively prevents multiple selection.
//    @MainActor optional func textView(_ textView: NSTextView, willChangeSelectionFromCharacterRange oldSelectedCharRange: NSRange, toCharacterRange newSelectedCharRange: NSRange) -> NSRange
//
//
//    // Delegate only.  Supersedes textView:willChangeSelectionFromCharacterRange:toCharacterRange:.  Return value must be a non-nil, non-empty array of objects responding to rangeValue.
//    @MainActor optional func textView(_ textView: NSTextView, willChangeSelectionFromCharacterRanges oldSelectedCharRanges: [NSValue], toCharacterRanges newSelectedCharRanges: [NSValue]) -> [NSValue]
//
//
//    // Delegate only.  Supersedes textView:shouldChangeTextInRange:replacementString:.  The affectedRanges argument obeys the same restrictions as selectedRanges, and the replacementStrings argument will either be nil (for attribute-only changes) or have the same number of elements as affectedRanges.
//    @MainActor optional func textView(_ textView: NSTextView, shouldChangeTextInRanges affectedRanges: [NSValue], replacementStrings: [String]?) -> Bool
//
//
//    // Delegate only.  The delegate should return newTypingAttributes to allow the change, oldTypingAttributes to prevent it, or some other dictionary to modify it.
//    @available(macOS 10.0, *)
//    @MainActor optional func textView(_ textView: NSTextView, shouldChangeTypingAttributes oldTypingAttributes: [String : Any] = [:], toAttributes newTypingAttributes: [NSAttributedString.Key : Any] = [:]) -> [NSAttributedString.Key : Any]
//
//
//    @available(macOS 10.10, *)
//    @MainActor optional func textViewDidChangeSelection(_ notification: Notification)
//
//
//    @available(macOS 10.10, *)
//    @MainActor optional func textViewDidChangeTypingAttributes(_ notification: Notification)
//
//
//    // Delegate only.  Allows delegate to modify the tooltip that will be displayed from that specified by the NSToolTipAttributeName, or to suppress display of the tooltip (by returning nil).
//    @MainActor optional func textView(_ textView: NSTextView, willDisplayToolTip tooltip: String, forCharacterAt characterIndex: Int) -> String?
//
//
//    // Delegate only.  Allows delegate to modify the list of completions that will be presented for the partial word at the given range.  Returning nil or a zero-length array suppresses completion.  Optionally may specify the index of the initially selected completion; default is 0, and -1 indicates no selection.
//    @MainActor optional func textView(_ textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>?) -> [String]
//
//
//    // Delegate only.  If characters are changing, replacementString is what will replace the affectedCharRange.  If attributes only are changing, replacementString will be nil.  Will not be called if textView:shouldChangeTextInRanges:replacementStrings: is implemented.
//    @MainActor optional func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool
//
//
//
//
//    // Delegate only.  Allows delegate to control the setting of spelling and grammar indicators.  Values are those listed for NSSpellingStateAttributeName.
//    @available(macOS 10.5, *)
//    @MainActor optional func textView(_ textView: NSTextView, shouldSetSpellingState value: Int, range affectedCharRange: NSRange) -> Int
//
//
//    // Delegate only.  Allows delegate to control the context menu returned by menuForEvent:.  The menu parameter is the context menu NSTextView would otherwise return; charIndex is the index of the character that was right-clicked.
//    @available(macOS 10.5, *)
//    @MainActor optional func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu?
//
//
//    // Delegate only.  Called by checkTextInRange:types:options:, this method allows control over text checking options (via the return value) or types (by modifying the flags pointed to by the inout parameter checkingTypes).
//    @available(macOS 10.6, *)
//    @MainActor optional func textView(_ view: NSTextView, willCheckTextIn range: NSRange, options: [NSSpellChecker.OptionKey : Any] = [:], types checkingTypes: UnsafeMutablePointer<NSTextCheckingTypes>) -> [NSSpellChecker.OptionKey : Any]
//
//
//    // Delegate only.  Called by handleTextCheckingResults:forRange:orthography:wordCount:, this method allows observation of text checking, or modification of the results (via the return value).
//    @available(macOS 10.6, *)
//    @MainActor optional func textView(_ view: NSTextView, didCheckTextIn range: NSRange, types checkingTypes: NSTextCheckingTypes, options: [NSSpellChecker.OptionKey : Any] = [:], results: [NSTextCheckingResult], orthography: NSOrthography, wordCount: Int) -> [NSTextCheckingResult]
//
//
//    // Returns an URL representing the document contents for textAttachment.  The returned NSURL object is utilized by NSTextView for providing default behaviors involving text attachments such as Quick Look and double-clicking.  -[NSTextView quickLookPreviewableItemsInRanges:] uses this method for mapping text attachments to their corresponding document URLs.  NSTextView invokes -[NSWorkspace openURL:] with the URL returned from this method when the delegate has no -textView:doubleClickedOnCell:inRect:atPoint: implementation.
//    @available(macOS 10.7, *)
//    @MainActor optional func textView(_ textView: NSTextView, urlForContentsOf textAttachment: NSTextAttachment, at charIndex: Int) -> URL?
//
//
//    // Delegate only. Returns a sharing service picker created for items right before shown to the screen inside -orderFrontSharingServicePicker: method. The delegate specify a delegate for the NSSharingServicePicker instance. Also, it is allowed to return its own NSSharingServicePicker instance instead.
//    @available(macOS 10.8, *)
//    @MainActor optional func textView(_ textView: NSTextView, willShow servicePicker: NSSharingServicePicker, forItems items: [Any]) -> NSSharingServicePicker?
//
//
//
//
//    // Delegate only. Invoked from -updateTouchBarItemIdentifiers before setting the item identifiers for textView's NSTouchBar.
//    @available(macOS 10.12.2, *)
//    @MainActor optional func textView(_ textView: NSTextView, shouldUpdateTouchBarItemIdentifiers identifiers: [NSTouchBarItem.Identifier]) -> [NSTouchBarItem.Identifier]
//
//
//    // Delegate only. Provides customized list of candidates to textView.candidateListTouchBarItem. Invoked from -updateCandidates. NSTextView uses the candidates returned from this method and suppress its built-in candidate generation. Returning nil from this delegate method allows NSTextView to query candidates from NSSpellChecker.
//    @available(macOS 10.12.2, *)
//    @MainActor optional func textView(_ textView: NSTextView, candidatesForSelectedRange selectedRange: NSRange) -> [Any]?
//
//
//    // Delegate only. Allows customizing the candidate list queried from NSSpellChecker.
//    @available(macOS 10.12.2, *)
//    @MainActor optional func textView(_ textView: NSTextView, candidates: [NSTextCheckingResult], forSelectedRange selectedRange: NSRange) -> [NSTextCheckingResult]
//
//
//    // Delegate only. Notifies the delegate that the user selected the candidate at index in -[NSCandidateListTouchBarItem candidates] for textView.candidateListTouchBarItem. When no candidate selected, index is NSNotFound. Returning YES allows textView to insert the candidate into the text storage if it's NSString, NSAttributedString, or NSTextCheckingResult.
//    @available(macOS 10.12.2, *)
//    @MainActor optional func textView(_ textView: NSTextView, shouldSelectCandidateAt index: Int) -> Bool
    // swiftlint:enable all
    #else
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textViewDelegate?.textViewShouldBeginEditing?(textView) ?? true // YES means do it
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textViewDelegate?.textViewShouldEndEditing?(textView) ?? true // YES means do it
    }

    //    @available(iOS 2.0, *)
    //    public func textViewDidBeginEditing(_ textView: UITextView) {
    //        textViewDelegate?.textViewDidBeginEditing?(textView)
    //    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        textViewDelegate?.textViewDidEndEditing?(textView)
    }

    public func textView(_ textView: UITextView,
                         shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textViewDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    public func textViewDidChange(_ textView: UITextView) {
        textViewDelegate?.textViewDidChange?(textView)
        nsuiTextDidChange(textView)
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        textViewDelegate?.textViewDidChangeSelection?(textView)
    }
    #endif
}
