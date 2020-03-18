// UINavigationBar+Extensions.swift
// Copyright (c) 2020 Joe Blau

import UIKit

extension UINavigationBar {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        switch view.isKind(of: UIControl.self) {
        case true: return super.hitTest(point, with: event)
        case false: return nil
        }
    }
}
