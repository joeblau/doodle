// HelpViewController.swift
// Copyright (c) 2020 Joe Blau

import UIKit

struct Item {
    let image: UIImage?
    let text: String
}

struct Section {
    let header: String?
    let footer: String?
    let items: [Item]
}

final class HelpViewController: UITableViewController {
    let helpSections: [Section]

    init() {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            helpSections = [
            Section(header: "Interface",
                    footer: nil,
                    items: [
                        Item(image: UIImage(systemName: "line.horizontal.3"),
                             text: NSLocalizedString("help_menu", comment: "help")),
                        Item(image: UIImage(systemName: "trash"),
                             text: NSLocalizedString("help_clear", comment: "clear")),
                        Item(image: UIImage(systemName: "pencil.tip"),
                             text: NSLocalizedString("help_tool", comment: "tool")),
                        Item(image: UIImage(systemName: "arrow.up.left.and.arrow.down.right"),
                             text: NSLocalizedString("help_tool_picker", comment: "tool picker")),
                        Item(image: UIImage(systemName: "square.and.arrow.up"),
                             text: NSLocalizedString("help_menu_share", comment: "share")),
                        Item(image: UIImage(systemName: "largecircle.fill.circle"),
                             text: NSLocalizedString("help_menu_record", comment: "record")),
                    ]),
            Section(header: "Gestures",
                    footer: nil,
                    items: [
                        Item(image: UIImage(systemName: "squares.below.rectangle"),
                             text: NSLocalizedString("help_close", comment: "close")),
                        Item(image: UIImage(systemName: "square.grid.3x2"),
                             text: NSLocalizedString("help_minimize", comment: "minimize")),
                        Item(image: UIImage(systemName: "2.circle"),
                             text: NSLocalizedString("help_undo", comment: "undo")),
                    ]),
            Section(header: "Canvas",
                    footer: nil,
                    items: [
                        Item(image: UIImage(systemName: "hand.draw"),
                             text: NSLocalizedString("help_hand", comment: "hand")),
                        Item(image: UIImage(systemName: "pencil.and.outline"),
                             text: NSLocalizedString("help_hardware", comment: "stylus")),
                    ]),
        ]
        case .phone:
            helpSections = [
                Section(header: "Interface",
                        footer: nil,
                        items: [
                            Item(image: UIImage(systemName: "line.horizontal.3"),
                                 text: NSLocalizedString("help_menu", comment: "help")),
                            Item(image: UIImage(systemName: "trash"),
                                 text: NSLocalizedString("help_clear", comment: "clear")),
                            Item(image: UIImage(systemName: "pencil.tip"),
                                 text: NSLocalizedString("help_tool", comment: "tool")),
                            Item(image: UIImage(systemName: "arrow.up.left.and.arrow.down.right"),
                                 text: NSLocalizedString("help_tool_picker", comment: "tool picker")),
                            Item(image: UIImage(systemName: "square.and.arrow.up"),
                                 text: NSLocalizedString("help_menu_share", comment: "share")),
                            Item(image: UIImage(systemName: "largecircle.fill.circle"),
                                 text: NSLocalizedString("help_menu_record", comment: "record")),
                        ]),
                Section(header: "Gestures",
                        footer: nil,
                        items: [
                            Item(image: UIImage(systemName: "2.circle"),
                                 text: NSLocalizedString("help_undo", comment: "undo")),
                        ]),
                Section(header: "Canvas",
                        footer: nil,
                        items: [
                            Item(image: UIImage(systemName: "hand.draw"),
                                 text: NSLocalizedString("help_hand", comment: "hand")),
                        ]),
            ]
        default: fatalError("unspecified device")
        }
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("help_title", comment: "title")

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(closeAction))
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func numberOfSections(in _: UITableView) -> Int {
        helpSections.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        helpSections[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = helpSections[indexPath.section].items[indexPath.item]
        cell.imageView?.image = item.image
        cell.textLabel?.text = item.text
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        helpSections[section].header
    }

    override func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        helpSections[section].footer
    }

    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}
