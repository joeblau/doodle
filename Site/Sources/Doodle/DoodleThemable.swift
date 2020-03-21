// ScottForstallThemable.swift
// Copyright (c) 2020 Tapsnap, LLC

import Publish


protocol Sectionable {
    var title: String { get set }
    var subtitle: String { get set }
}

protocol HeroSectionable: Sectionable {}

protocol DownloadSectionable: Sectionable {
    var appStoreURL: String { get set }
}

protocol DoodleThemable: Website {
    var copyright: String { get set }
    var appStoreURL: String { get set }
    var hero: HeroSectionable? { get set }
    var download: DownloadSectionable? { get set }
}
