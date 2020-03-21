// ScottForstallThemable.swift
// Copyright (c) 2020 Joe Blau

import Publish


protocol Sectionable {
    var title: String { get set }
    var subtitle: String { get set }
}

protocol HeroSectionable: Sectionable {}

protocol DownloadSectionable: Sectionable {
    var appStoreURL: String { get set }
}

public protocol BulletPointable {
    var symbol: String? { get set }
    var tags: [String] { get set }
    var images: [String] { get set }
    var title: String { get set }
    var description: String { get set }
    var href: String { get set }
}

struct BulletPoint: BulletPointable {
    var symbol: String? = nil
    var tags: [String] = [String]()
    var images: [String] = [String]()
    var title: String
    var description: String
    var href: String = ""
}

protocol FeaturesSectionable: Sectionable {
    var differentiators: [BulletPointable] { get set }
}

protocol DoodleThemable: Website {
    var copyright: String { get set }
    var appStoreURL: String { get set }
    var hero: HeroSectionable? { get set }
    var features: FeaturesSectionable? { get set }
    var download: DownloadSectionable? { get set }
}
