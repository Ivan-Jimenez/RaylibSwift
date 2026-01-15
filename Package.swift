// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Raylib",
    products: [
        .library(name: "Raylib", targets: ["Raylib"]),
        .library(name: "RaylibC", targets: ["RaylibC"]),
    ],
    targets: [
        .executableTarget(name: "Example", dependencies: ["Raylib"]),
        .target(name: "Raylib", dependencies: ["RaylibC"]),
        .target(
            name: "RaylibC",
            path: "Sources/RaylibC/raylib-5.5/src",
            exclude: [
                "raylib.ico",
                "minshell.html", 
                "shell.html", 
                "raylib.rc", 
                "raylib.dll.rc",
                "raylib.dll.rc.data", 
                "raylib.rc.data", 
                "CMakeLists.txt",
                "external/glfw/include/GLFW/glfw3native.h", 
                "external/glfw/deps/mingw",
            ],
            sources: [
                "rcore.c", 
                "rmodels.c", 
                "rshapes.c", 
                "rtext.c", 
                "rtextures.c", 
                "utils.c",
                "raudio.c", 
                "rglfw.c",
                "rglfw.m",
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("external/glfw/include"),
                .define("PLATFORM_DESKTOP"),
                .define("GRAPHICS_API_OPENGL_33"),
                .define("_GLFW_X11", .when(platforms: [.linux])),
                .define("_GLFW_WIN32", .when(platforms: [.windows])),
                .define("_GLFW_COCOA", .when(platforms: [.macOS])),
                .unsafeFlags(["-fno-objc-arc"], .when(platforms: [.macOS])),
            ],
            linkerSettings: [
                .linkedLibrary("GL", .when(platforms: [.linux])),
                .linkedLibrary("m", .when(platforms: [.linux])),
                .linkedLibrary("pthread", .when(platforms: [.linux])),
                .linkedLibrary("dl", .when(platforms: [.linux])),
                .linkedLibrary("rt", .when(platforms: [.linux])),
                .linkedLibrary("X11", .when(platforms: [.linux])),
                .linkedLibrary("winmm", .when(platforms: [.windows])),
                .linkedLibrary("gdi32", .when(platforms: [.windows])),
                .linkedLibrary("opengl32", .when(platforms: [.windows])),
                .linkedLibrary("shell32", .when(platforms: [.windows])),
                .linkedFramework("Cocoa", .when(platforms: [.macOS])),
                .linkedFramework("IOKit", .when(platforms: [.macOS])),
                .linkedFramework("CoreVideo", .when(platforms: [.macOS])),
                .linkedFramework("OpenGL", .when(platforms: [.macOS])),
                .linkedFramework("CoreFoundation", .when(platforms: [.macOS])),
                .linkedFramework("CoreAudio", .when(platforms: [.macOS])),
                .linkedFramework("AudioToolbox", .when(platforms: [.macOS])),
            ]
        ),
    ]
)
