// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TodayList",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TodayList",
            targets: ["TodayList"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/DayPic/DownpourRx.git", branch: "main"),
        .package(url: "git@github.com:DayPic/PhotoOrganizer_iOS.git", branch: "main")
        
    ],
    targets: [
        .target(
            name: "TodayList",
            dependencies: [
                .product(name: "DownpourRx", package: "DownpourRx"),
                .product(name: "PhotoOrganizer", package: "PhotoOrganizer_iOS")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "TodayListTests",
            dependencies: ["TodayList"]
        ),
    ]
)
