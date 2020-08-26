// DoodleViewController.swift
// Copyright (c) 2020 Joe Blau

import PencilKit
import ReplayKit
import UIKit

final class DoodleViewController: UIViewController {
    private var kPadding: CGFloat = 4.0
    private var kButtonSize: CGFloat = 52.0
    private lazy var canvasView: PKCanvasView = {
        let v = PKCanvasView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }()

    private lazy var menuButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        b.addTarget(self, action: #selector(showMenuAction(_:)), for: .touchUpInside)
        let interaction = UIContextMenuInteraction(delegate: self)
        b.addInteraction(interaction)
        return b
    }()

    private lazy var helpLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.alpha = 0.0
        let s = NSMutableAttributedString()
        let a = NSTextAttachment()
        a.image = UIImage(systemName: "arrow.left")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        s.append(NSAttributedString(attachment: a))
        s.append(NSAttributedString(string: NSLocalizedString("hint_long_press", comment: "long press")))
        l.attributedText = s

        return l
    }()

    private lazy var clearButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        b.addTarget(self, action: #selector(clearCanvasAction(_:)), for: .touchUpInside)
        return b
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
            clearButton.isEnabled = buttonsEnabled
        }
    }

    private let sharedScreenRecorder = RPScreenRecorder.shared()
    private let reviewManager = ReviewManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonsEnabled = false

        canvasView.addGestureRecognizer(undoGesture)
        sharedScreenRecorder.isMicrophoneEnabled = true

        view.addSubview(canvasView)
        canvasView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        canvasView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        canvasView.addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: kButtonSize).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: kButtonSize).isActive = true

        canvasView.addSubview(helpLabel)
        helpLabel.topAnchor.constraint(equalTo: menuButton.topAnchor).isActive = true
        helpLabel.bottomAnchor.constraint(equalTo: menuButton.bottomAnchor).isActive = true
        helpLabel.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: kPadding).isActive = true
        helpLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true

        canvasView.addSubview(clearButton)
        clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: kButtonSize).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: kButtonSize).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let window = view.window,
            let toolPicker = PKToolPicker.shared(for: window) else { return }

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
        switch UserDefaults.standard.integer(forKey: ReviewManager.kOpenCount) {
        case 0: showHelpAction()
        default: break
        }
        
        reviewManager.requestReview()
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

    @objc func showMenuAction(_: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.helpLabel.alpha = 1.0
        }

        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: .curveEaseOut,
                       animations: {
                           self.helpLabel.alpha = 0.0
        }, completion: nil)
    }

    @objc func clearCanvasAction(_: UIButton) {
        canvasView.drawing = PKDrawing()
        buttonsEnabled = false
    }

    @objc func undoAction() {
        canvasView.undoManager?.undo()
    }

    @objc func showHelpAction() {
        present(UINavigationController(rootViewController: HelpViewController()), animated: true, completion: nil)
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else {
            return
        }

        self.clearCanvasAction(clearButton)
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
    func contextMenuInteraction(_: UIContextMenuInteraction,
                                configurationForMenuAtLocation _: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil,
                                   previewProvider: nil) { [unowned self] _ -> UIMenu? in

            let share = UIAction(title: NSLocalizedString("menu_share", comment: "Share"),
                                 image: UIImage(systemName: "square.and.arrow.up.fill"),
                                 handler: self.exportImageAction)
            switch self.buttonsEnabled {
            case true: break
            case false: share.attributes = .disabled
            }

            let title: String
            switch RPScreenRecorder.shared().isRecording {
            case true: title = NSLocalizedString("menu_stop_recording", comment: "Stop Record")
            case false: title = NSLocalizedString("menu_start_recording", comment: "Start Record")
            }
            let record = UIAction(title: title,
                                  image: UIImage(systemName: "largecircle.fill.circle"),
                                  handler: self.toggleRecordAction)
            switch RPScreenRecorder.shared().isRecording {
            case true: record.attributes = .destructive
            case false: break
            }

            let recordGroup = UIMenu(title: "", options: .displayInline, children: [record])

            let help = UIAction(title: NSLocalizedString("menu_help", comment: "Help"),
                                image: UIImage(systemName: "questionmark"),
                                handler: self.showHelpAction)
            let helpGroup = UIMenu(title: "", options: .displayInline, children: [help])

            return UIMenu(title: "", children: [share, recordGroup, helpGroup])
        }
    }

    func exportImageAction(_: UIAction) {
        UITraitCollection(userInterfaceStyle: .light).performAsCurrent {
            let image = canvasView.drawing.image(from: canvasView.drawing.bounds,
                                                 scale: 1.0)

            let activityViewController = UIActivityViewController(activityItems: [image],
                                                                  applicationActivities: nil)
            activityViewController.modalPresentationStyle = .popover
            switch UIDevice.current.userInterfaceIdiom {
            case .pad, .phone: activityViewController.popoverPresentationController?.sourceView = menuButton
            default: break
            }
            present(activityViewController, animated: true, completion: nil)
        }
    }

    func toggleRecordAction(_: UIAction) {
        switch RPScreenRecorder.shared().isRecording {
        case true:

            sharedScreenRecorder.stopRecording { [unowned self] previewController, _ in
                guard let previewController = previewController else { return }
                previewController.modalPresentationStyle = .popover
                previewController.previewControllerDelegate = self
                previewController.popoverPresentationController?.sourceView = self.menuButton
                self.present(previewController, animated: true, completion: nil)
            }
        case false:
            sharedScreenRecorder.startRecording { _ in
                print("started")
            }
        }
    }

    func showHelpAction(_: UIAction) {
        showHelpAction()
    }
}
