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
    var download: DownloadSectionable? = Download()

}

try Site().publish(withTheme: .doodle)
