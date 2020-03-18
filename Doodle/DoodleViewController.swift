// DoodleViewController.swift
// Copyright (c) 2020 Joe Blau

import PencilKit
import UIKit

class DoodleViewController: UIViewController {
    lazy var canvasView: PKCanvasView = {
        let v = PKCanvasView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    lazy var clearButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
                        style: .plain,
                        target: self,
                        action: #selector(clearCanvas))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = clearButton

        guard let navigationView = navigationController?.view else { return }
        navigationView.insertSubview(canvasView, at: 1)
        canvasView.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        canvasView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor).isActive = true
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
      return false
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.all
    }

    @objc func clearCanvas() {
        canvasView.drawing = PKDrawing()
        clearButton.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let window = view.window,
            let toolPicker = PKToolPicker.shared(for: window) else { return }

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}
