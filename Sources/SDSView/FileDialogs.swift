//
//  FileDialogs.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/02
//  © 2022  SmallDeskSoftware
//

import Foundation
#if os(macOS)
import AppKit
#endif

@MainActor
public func savePanelForFilename(_ fileName: String? = nil) async -> URL? {
    #if os(macOS)
    let panel = NSSavePanel()
    panel.canCreateDirectories = true
    panel.showsTagField = true
    panel.isExtensionHidden = true
    panel.level = NSWindow.Level.modalPanel
    if let fileName = fileName {
        panel.nameFieldStringValue = fileName
    }
    let result = await panel.beginSheetModal(for: NSApp.mainWindow!)
    if result == .OK {
        return panel.url
    }
    return nil
    #elseif os(iOS)
    fatalError("not implemented")
    #endif
}
@MainActor
public func savePanelForFolder() async -> URL? {
    #if os(macOS)
    let panel = NSSavePanel()
    panel.canCreateDirectories = true
    panel.showsTagField = true
    panel.allowedContentTypes = [.directory]
    panel.isExtensionHidden = true
    panel.level = NSWindow.Level.modalPanel
    let result = await panel.beginSheetModal(for: NSApp.mainWindow!)
    if result == .OK {
        return panel.url
    }
    return nil
    #elseif os(iOS)
    fatalError("not implemented")
    #endif
}
@MainActor
public func openPanelForFolder() async -> URL? {
    #if os(macOS)
    let panel = NSOpenPanel()
    panel.canCreateDirectories = true
    panel.canChooseDirectories = true
    panel.showsTagField = true
    panel.isExtensionHidden = true
    panel.level = NSWindow.Level.modalPanel
    let result = await panel.beginSheetModal(for: NSApp.mainWindow!)
    if result == .OK {
        return panel.url
    }
    return nil
    #elseif os(iOS)
    fatalError("not implemented")
    #endif
}

@MainActor
public func openPanelForFilename(_ folder: URL? = nil) async -> [URL] {
#if os(macOS)
    let panel = NSOpenPanel()
    panel.canChooseDirectories = false
    panel.canCreateDirectories = false
    panel.allowsMultipleSelection = true
    panel.showsTagField = true
    panel.isExtensionHidden = true
    panel.level = NSWindow.Level.modalPanel
    let result = await panel.beginSheetModal(for: NSApp.mainWindow!)
    if result == .OK {
        return panel.urls
    }
    return []
#elseif os(iOS)
    fatalError("not implemented")
#endif
}
