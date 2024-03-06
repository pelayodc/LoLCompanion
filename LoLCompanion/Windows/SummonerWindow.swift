//
//  SummonerWindow.swift
//  LoLCompanion
//
//  Created by Pelayo Del Campo González on 5/3/24.
//

import Foundation
import AppKit
import SwiftUI

class SummonerWindow: NSWindow {

    init(with rect: NSRect, data: SummonerViewViewModel) {
        super.init(contentRect: rect, styleMask: [], backing: .buffered, defer: false)

        isReleasedWhenClosed = false

        let dragonManager = DDragonManager()

        let mainView = SummonerExtendedView(viewModel: data, myWindow: self)
            .environmentObject(dragonManager)
            .frame(width: rect.width, height: rect.height, alignment: .top).background(
                LoLCompanionColors.background.swiftUI
            )

        let hostingView = LoLCompanionHostingView(rootView: mainView)
        hostingView.frame = NSRect(origin: .zero, size: rect.size)
        hostingView.layer?.cornerRadius = 8
        hostingView.layer?.cornerCurve = .continuous
        hostingView.layer?.masksToBounds = true
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow
        contentView = visualEffect
        
        self.isMovableByWindowBackground = true

        self.contentView?.addSubview(hostingView)
    }

    deinit {
        print("CustomWindow DE-INIT")
    }

    //override var canBecomeKey: Bool { false }
    //override var canBecomeMain: Bool { false }

    func presentWindow() {
        orderFront(nil)
    }

    func hideWindow() {
        orderBack(nil)
    }
}
