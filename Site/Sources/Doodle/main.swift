import Foundation
import Publish
import Plot


struct Hero: HeroSectionable {
    var title: String = "Doodle"
    var subtitle: String = ""
}

struct Download: DownloadSectionable {
    var title = "Download"
    var subtitle = "Get Doodle for iOS or iPadOS"
    var appStoreURL = "https://apps.apple.com/us/app/news-shield/id1489025442?ls=1&mt=12"
}

struct Features: FeaturesSectionable {
    var title = "Features"
    var subtitle = ""
    var differentiators: [BulletPointable] = [
        
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
                    description: "No analytics, no tracking, no app storage")
    ]
}

struct Site: DoodleThemable {
    
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    var url = URL(string: "https://joeblau.com/doodle")!
    var name = "Doodle"
    var description = "Doodle Drawing Pad"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var copyright: String = "2020"
    var appStoreURL: String = "htt:"
    var hero: HeroSectionable? = Hero()
    var features: FeaturesSectionable? = Features()
    var download: DownloadSectionable? = Download()

}

try Site().publish(withTheme: .doodle)
