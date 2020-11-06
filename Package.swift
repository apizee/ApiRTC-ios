// swift-tools-version:5.3

import PackageDescription
 
let package = Package(
    name: "ApiRTCPackage",
    products: [
        .library(
            name: "ApiRTCPackage",
            targets: ["ApiRTC"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/robbiehanson/CocoaAsyncSocket", 
            from: "7.6.4"
        ),
        .package(
            url: "https://github.com/socketio/socket.io-client-swift", 
            from: "15.2.0"
        ),
        .package(
            url: "https://github.com/ReactiveX/RxSwift", 
            from: "5.1.1"
        )
    ],
    targets: [
        .binaryTarget(name: "ApiRTC", path: "./ApiRTC.xcframework")
    ]
)
