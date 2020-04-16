// main.swift
// Copyright (c) 2020 Joe Blau

import BlauTheme
import Foundation
import Plot
import Publish

public struct BulletPoint: BulletPointable {
    public var symbol: String?
    public var tags: [String]?
    public var images: [String]?
    public var title: String?
    public var description: String?
    public var url: URL?
}

public struct TextLink: TextLinkable {
    public var text: String
    public var url: URL
}

struct HeaderURL: AppearanceURLable {
    var light: URL = URL(string: "/img/ipad/hero-light@2x.png")!
    var dark: URL = URL(string: "/img/ipad/hero-dark@2x.png")!
}

struct AppStoreAppearanceURL: AppearanceURLable {
    var light: URL = URL(string: "/img/us/app-store-light.svg")!
    var dark: URL = URL(string: "/img/us/app-store-dark.svg")!
}

struct AppStoreLink: ImageLinkable {
    var image: AppearanceURLable = AppStoreAppearanceURL()
    var url: URL = URL(string: "https://itunes.apple.com/app/id1503601939")!
}

// MARK: - Header

struct Header: HeaderSectionable {
    var callToActionImageLink: ImageLinkable? = AppStoreLink()
    var image: AppearanceURLable? = HeaderURL()
    var backgroundImage: URL?
    var title: String? = "Doodle"
    var subtitle: String?
}

// MARK: - Call To Action

struct CallToAction: CallToActionSectionable {
    var callToActionImageLink: ImageLinkable? = AppStoreLink()
    var title: String? = "Download"
    var subtitle: String? = "Get Doodle for iOS or iPadOS"
}

// MARK: - Features

struct Features: FeatureSectionable {
    var title: String? = "Features"
    var subtitle: String?
    var list: [BulletPointable] = [
        BulletPoint(symbol: "􀖔",
                    title: "Finger",
                    description: "Quickly doodle a drawing with your finger"),
        BulletPoint(symbol: "􀈊",
                    title: "Pencil",
                    description: "Quickly doodle a drawing with your  Pencil"),
        BulletPoint(symbol: "􀈒",
                    title: "Delete",
                    description: "Quickly erase your drawing with one tap"),
        BulletPoint(symbol: "􀝜",
                    title: "Record",
                    description: "Record your screen and voice to create a narrated drawing"),
        BulletPoint(symbol: "􀓜",
                    title: "Containment",
                    description: "Prevents accidental edge gestures to leave the app"),
        BulletPoint(symbol: "􀀂",
                    title: "Modes",
                    description: "Light mode and dark mode support"),
        BulletPoint(symbol: "􀈃",
                    title: "Share",
                    description: "Share doodles with friends family"),
        BulletPoint(symbol: "􀈅",
                    title: "Save",
                    description: "Save individual drawing for the future"),
        BulletPoint(symbol: "􀙧",
                    title: "Privacy",
                    description: "No analytics, no tracking, no app storage"),
    ]
}

// MARK: - Footer

struct Footer: FooterSectionable {
    var navigationLinks: [TextLinkable] = [
        TextLink(text: "Home", url: URL(string: "/")!),
        TextLink(text: "GitHub", url: URL(string: "https://github.com/joeblau/doodle")!),
    ]
    var copyright: String = "2020 Joe Blau"
    var title: String?
    var subtitle: String?
}

// MARK: - Site

struct Site: BlauThemable {
    enum SectionID: String, WebsiteSectionID {
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {}

    var url = URL(string: "https://joeblau.com/doodle")!
    var imagePath: Path?
    var name = "Doodle"
    var description = "Doodle Drawing Pad"
    var language: Language { .english }
    var copyright: String = "2020"
    var keywords: String = "Redact, Sensational, News, Shield, Desational"
    var css: String?
    var hero: HeroSectionable?
    var header: HeaderSectionable? = Header()
    var features: FeatureSectionable? = Features()
    var callToAction: CallToActionSectionable? = CallToAction()
    var footer: FooterSectionable? = Footer()
}

try Site().publish(withTheme: .blau)
