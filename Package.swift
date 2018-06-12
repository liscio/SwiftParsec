// swift-tools-version:4.0
//
//  Package.swift
//  SwiftParsec
//
//  Created by David Dufresne on 2016-05-10.
//  Copyright © 2016 David Dufresne. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SwiftParsec",
    products: [
        .library(name: "SwiftParsec", targets: ["SwiftParsec"]),
        .library(name: "SwiftParsecLanguages", targets: ["SwiftParsecLanguages"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftParsec"),
        .target(name: "SwiftParsecLanguages", dependencies: ["SwiftParsec"]),

        .testTarget(name: "SwiftParsecTests", dependencies: ["SwiftParsec"]),
        .testTarget(name: "SwiftParsecLanguagesTests", dependencies: ["SwiftParsecLanguages"])
    ]
)
