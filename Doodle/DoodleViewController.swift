// DoodleViewController.swift
// Copyright (c) 2020 Joe Blau

import PencilKit
import UIKit
import ReplayKit

final class DoodleViewController: UIViewController {
    private lazy var canvasView: PKCanvasView = {
        let v = PKCanvasView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }()

    private lazy var menuButton: UIBarButtonItem = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        let interaction = UIContextMenuInteraction(delegate: self)
        b.addInteraction(interaction)
        return UIBarButtonItem(customView: b)
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
            clearButton.isEnabled = self.buttonsEnabled
        }
    }
    
    private let sharedScreenRecorder = RPScreenRecorder.shared()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = clearButton
        buttonsEnabled = false

        canvasView.addGestureRecognizer(undoGesture)
        sharedScreenRecorder.isMicrophoneEnabled = true

        guard let navigationView = navigationController?.view else { return }
        navigationView.insertSubview(canvasView, at: 1)
        canvasView.topAnchor.constraint(equalTo: navigationView.topAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor).isActive = true
        canvasView.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let window = view.window,
            let toolPicker = PKToolPicker.shared(for: window) else { return }

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
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

    // MARK: - Actions
    
    @objc func clearCanvasAction() {
        canvasView.drawing = PKDrawing()
        buttonsEnabled = false
    }

    @objc func undoAction() {
        canvasView.undoManager?.undo()
    }
}

// MARK: - PKCanvasViewDelegate

extension DoodleViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_: PKCanvasView) {
        buttonsEnabled = true
    }
}

// MARK: - RPPreviewViewControllerDelegate

extension DoodleViewController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension DoodleViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { [unowned self] suggestedActions -> UIMenu? in
            
            let share = UIAction(title: "Share",
                                 image: UIImage(systemName: "square.and.arrow.up.fill"),
                                 handler: self.exportImageAction)
            switch self.buttonsEnabled {
            case true: break
            case false: share.attributes = .disabled
            }
            
            let record = UIAction(title: "Record",
                                  image: UIImage(systemName: "largecircle.fill.circle"),
                                  handler: self.toggleRecordAction)
            switch RPScreenRecorder.shared().isRecording {
            case true: record.attributes = .destructive
            case false: break
            }
            
            let recordGroup = UIMenu(title: "", options: .displayInline, children: [record])
            return UIMenu(title: "", children: [share, recordGroup])
        }
    }
    
    func exportImageAction(_ action: UIAction) {
        let image = canvasView.drawing.image(from: canvasView.drawing.bounds,
                                             scale: 1.0)
        let activityViewController = UIActivityViewController(activityItems: [image],
                                                              applicationActivities: nil)
        activityViewController.modalPresentationStyle = .popover
        switch UIDevice.current.userInterfaceIdiom {
        case .pad, .phone: activityViewController.popoverPresentationController?.barButtonItem = menuButton
        default: break
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func toggleRecordAction(_ action: UIAction) {
            switch RPScreenRecorder.shared().isRecording {
            case true:
               
                    sharedScreenRecorder.stopRecording { [unowned self] (previewController, error) in
                    guard let previewController = previewController else { return }
                    previewController.modalPresentationStyle = .popover
                    previewController.previewControllerDelegate = self
                        previewController.popoverPresentationController?.barButtonItem = self.menuButton
                    self.present(previewController, animated: true, completion: nil)
                }
            case false:
                sharedScreenRecorder.startRecording { (error) in
                    print("started")
                }
            }
        }
}
