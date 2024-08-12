//
//  LSApp.swift
//  MiniUiFramework
//
//  Created by lake on 2024/8/10.
//

import Foundation
import MobileCoreServices
import UIKit

@objc protocol LSApplicationWorkspace {
    static func defaultWorkspace() -> Self
    func allInstalledApplications() -> [NSObject]
    func allApplications() -> [NSObject]
    func installedPlugins() -> [NSObject]
    func openApplicationWithBundleID(_ bundleID: AnyObject!) -> Bool
}

@objc protocol LSAppProxy {
    var itemName: NSString { get }
    var localizedName: NSString { get }
    var containingBundle: NSObject { get }
    var bundleIdentifier: NSString { get }
    var shortVersionString: NSString { get }
}

struct LSApp {
    let workspace: LSApplicationWorkspace

    init() {
        let app = unsafeBitCast(NSClassFromString("LSApplicationWorkspace"), to: LSApplicationWorkspace.Type.self)
        self.workspace = app.defaultWorkspace()
    }

    func appList() -> [Info] {
        let plugins = workspace.installedPlugins()
        var set = [String: AnyObject]()
        for plugin in plugins {
            guard let app = plugin.perform(#selector(getter: LSAppProxy.containingBundle)) else { continue }
            let nsApp = app.takeUnretainedValue()
            guard let bundleIdentifier = nsApp.perform(#selector(getter: LSAppProxy.bundleIdentifier)) else { continue }
            set[bundleIdentifier.takeUnretainedValue() as! String] = nsApp
        }
        var list = [Info]()
        for item in set.values {
            var appName = item.perform(#selector(getter: LSAppProxy.itemName))
            if appName == nil {
                appName = item.perform(#selector(getter: LSAppProxy.localizedName))
            }
            guard let bundleId = item.perform(#selector(getter: LSAppProxy.bundleIdentifier)) else { continue }
            guard let version = item.perform(#selector(getter: LSAppProxy.shortVersionString)) else { continue }
            let icon = UIImage._applicationIconImage(forBundleIdentifier: bundleId.takeUnretainedValue() as? String, format: 10, scale: UIScreen.main.scale)
            list.append(Info(appName: appName!.takeUnretainedValue() as! String, version: version.takeUnretainedValue() as! String, bundleId: bundleId.takeUnretainedValue() as! String, icon: icon as? UIImage))
        }
        return list
    }

    struct Info {
        let appName: String
        let version: String
        let bundleId: String
        let icon: UIImage?
    }
}
