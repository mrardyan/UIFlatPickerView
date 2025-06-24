// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UIFlatPickerView",
  platforms: [
    .iOS(.v12),
    .macOS(.v11),
  ],
  products: [
    .library(
      name: "UIFlatPickerView",
      targets: ["UIFlatPickerView"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "UIFlatPickerView",
      dependencies: [],
      path: "Sources/UIFlatPickerView"),
    .testTarget(
      name: "UIFlatPickerViewTests",
      dependencies: ["UIFlatPickerView"],
      path: "Tests/UIFlatPickerViewTests"),
  ]
)
