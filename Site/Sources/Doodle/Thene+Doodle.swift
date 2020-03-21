// Thene+ScottForstall.swift
// Copyright (c) 2020 Joe Blau

import Plot
import Publish

extension Theme where Site: DoodleThemable {
    static var doodle: Self {
        Theme(htmlFactory: ScottForstallHTMLFactory(),
              resourcePaths: [])
    }

    private struct ScottForstallHTMLFactory: HTMLFactory {
        func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: index,
                      on: context.site,
                      titleSeparator: " | ",
                      stylesheetPaths: [Path("css/style.css"),
                                        Path("fonts/sfsymbols-font-stylesheet.css")]),
                .body(
                    .hero(for: context.site),
                    .main(
                        .features(for: context.site),
                        .download(for: context.site)
                    )
                )
            )
        }

        func makeSectionHTML(for _: Section<Site>, context _: PublishingContext<Site>) throws -> HTML {
            HTML()
        }

        func makeItemHTML(for _: Item<Site>, context _: PublishingContext<Site>) throws -> HTML {
            HTML()
        }

        func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
            HTML()
        }

        func makeTagListHTML(for _: TagListPage, context _: PublishingContext<Site>) throws -> HTML? {
            HTML()
        }

        func makeTagDetailsHTML(for _: TagDetailsPage, context _: PublishingContext<Site>) throws -> HTML? {
            HTML()
        }
    }
}

private extension Node where Context == HTML.BodyContext {
    // MARK: - Hero

    static func hero<T: DoodleThemable>(for site: T) -> Node {
        guard let hero = site.hero else {
            return .empty
        }
        return section(
            .class("hero hero-background"),
            .h1(.text(hero.title)),
            .appStoreLink(for: site),
            .div(
                .picture(
                    .source(
                        .attribute(named: "class", value: "brand-image"),
                        .attribute(named: "src", value: "/img/ipad/hero-dark.png"),
                        .srcset("/img/ipad/hero-dark@2x.png 2x"),
                        .media("(prefers-color-scheme: dark)")
                    ),
                    .img(
                        .attribute(named: "class", value: "brand-image"),
                        .src("img/ipad/hero-light.png"),
                        .attribute(named: "srcset", value: "/img/ipad/hero-light@2x.png 2x")
                    )
                    
                )
                
                
            )
        )
    }

    // MARK: - Features
    
    static func features<T: DoodleThemable>(for site: T) -> Node {
        guard let features = site.features else {
            return .empty
        }
        return .element(named: "", nodes: [
            .header(
                .h2(.text(features.title)),
                .if(features.subtitle.isEmpty == false,
                    .h4(.text(features.subtitle))
                )
            ),
            .section(
                .class("features max-section"),
                .forEach(features.differentiators) { differentiator in
                    .div(
                        .h3(
                            .if(differentiator.symbol != nil,
                                .span(.class("icon"), .text(differentiator.symbol!))
                            ),
                            .br(),
                            .element(named: "small", text: differentiator.title)
                        ),
                        .p(.text(differentiator.description)),
                        .if(!differentiator.href.isEmpty,
                            .a(
                                .href(differentiator.href),
                                .text("Learn More "),
                                .span(.class("icon"), .text("􀄯"))
                            )
                        )
                    )
                }
            )
        ])
    }

    // MARK: - Download
    
    static func download<T: DoodleThemable>(for site: T) -> Node {
        guard let download = site.download else {
            return .empty
        }
        return .element(named: "", nodes: [
            .header(
                .h2(.text(download.title)),
                .if(download.subtitle.isEmpty == false,
                    .h4(.text(download.subtitle))
                )
            ),
            .section(
                .class("downloads"),
                .div(
                    .appStoreLink(for: site)
                )
            )
        ])
    }

    // MARK: - Utility functions

    static func appStoreLink<T: DoodleThemable>(for site: T) -> Node {
        .a(
            .href(site.appStoreURL),
            .picture(
                .source(
                    .srcset("/img/us/app-store-dark.svg"),
                    .media("(prefers-color-scheme: dark)")
                ),
                .img(
                    .src("/img/us/app-store-light.svg")
                )
            )
        )
    }
}
