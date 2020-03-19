// DoodleViewController.swift
// Copyright (c) 2020 Joe Blau

import PencilKit
import UIKit

final class DoodleViewController: UIViewController {
    private lazy var canvasView: PKCanvasView = {
        let v = PKCanvasView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }()

    private lazy var shareButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up.fill"),
                        style: .plain,
                        target: self,
                        action: #selector(exportImageAction))
    }()
    
    private lazy var clearButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
                        style: .plain,
                        target: self,
                        action: #selector(clearCanvasAction))
    }()
    
    private lazy var undoGesture: UITapGestureRecognizer = {
        let r = UITapGestureRecognizer()
        r.numberOfTouchesRequired = 2
        r.numberOfTapsRequired = 2
        r.addTarget(self, action: #selector(undoAction))
        return r
    }()

    private var buttonsEnabled: Bool = false {
        didSet {
            shareButton.isEnabled = self.buttonsEnabled
            clearButton.isEnabled = self.buttonsEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = shareButton
        navigationItem.rightBarButtonItem = clearButton
        buttonsEnabled = false

        canvasView.addGestureRecognizer(undoGesture)
        
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
        false
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        UIRectEdge.all
    }

    @objc func clearCanvasAction() {
        canvasView.drawing = PKDrawing()
        buttonsEnabled = false
    }

    @objc func undoAction() {
        canvasView.undoManager?.undo()
    }
    
    @objc func exportImageAction(_ barButtonItem: UIBarButtonItem) {
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds,
                                             scale: 1.0)
        let activityViewController = UIActivityViewController(activityItems: [image],
                                                              applicationActivities: nil)
        activityViewController.modalPresentationStyle = .popover
        switch UIDevice.current.userInterfaceIdiom {
        case .pad, .phone: activityViewController.popoverPresentationController?.barButtonItem = barButtonItem
        default: break
        }
        present(activityViewController, animated: true, completion: nil)
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

extension DoodleViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_: PKCanvasView) {
        buttonsEnabled = true
    }
}
