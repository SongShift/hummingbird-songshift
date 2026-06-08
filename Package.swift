// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var swiftSettings: [SwiftSetting] = [
    // https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md
    .enableUpcomingFeature("ExistentialAny"),

    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("MemberImportVisibility"),

    // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md
    .enableUpcomingFeature("InternalImportsByDefault"),
]

#if compiler(>=6.3)
swiftSettings.append(contentsOf: [
    .enableExperimentalFeature("AvailabilityMacro=hummingbird 2.0:macOS 14.0, iOS 17.0, tvOS 17.0, visionOS 1.0, Android 28")
])
#else
swiftSettings.append(contentsOf: [
    .enableExperimentalFeature("AvailabilityMacro=hummingbird 2.0:macOS 14.0, iOS 17.0, tvOS 17.0, visionOS 1.0")
])
#endif

let package = Package(
    name: "hummingbird-songshift",
    platforms: [.macOS(.v11), .iOS(.v15), .macCatalyst(.v15), .tvOS(.v15), .visionOS(.v1)],
    products: [
        .library(name: "HummingbirdUtilities", targets: ["HummingbirdUtilities"]),
    ],
    traits: [
        .trait(name: "ConfigurationSupport", description: "Enable support for swift-configuration package."),
        .default(enabledTraits: ["ConfigurationSupport"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.2"),
        .package(url: "https://github.com/apple/swift-atomics.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-configuration.git", from: "1.0.2", traits: []),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.11.0"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.5.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.100.0"),
        .package(url: "https://github.com/apple/swift-nio-extras.git", from: "1.34.1"),
        .package(url: "https://github.com/apple/swift-nio-http2.git", from: "1.44.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.14.0"),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", from: "1.20.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.30.0"),
    ],
    targets: [
        .target(
            name: "HummingbirdUtilities",
            swiftSettings: swiftSettings
        ),
    ]
)

if Context.environment["ENABLE_HB_BENCHMARKS"] != nil {
    package.dependencies.append(
        .package(url: "https://github.com/ordo-one/benchmark", from: "1.33.0")
    )
    package.targets.append(
        .executableTarget(
            name: "HummingbirdBenchmarks",
            dependencies: [
                "Hummingbird",
                "HummingbirdRouter",
                .product(name: "Benchmark", package: "benchmark"),
            ],
            path: "Benchmarks/HummingbirdBenchmarks",
            swiftSettings: swiftSettings,
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "benchmark")
            ]
        )
    )
    package.platforms = [.macOS(.v13), .iOS(.v15), .macCatalyst(.v15), .tvOS(.v15), .visionOS(.v1)]
}
