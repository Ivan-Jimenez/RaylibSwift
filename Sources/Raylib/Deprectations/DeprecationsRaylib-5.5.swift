/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

// This file contains deprecations for SwiftRaylib from Raylib 4.0 to 5.5
// Swift will guide you through upgrading, and this file contains the hints it needs to do so.

import RaylibC

// MARK: - Module Audio
public extension Raylib {
    /// Play a sound (using multichannel buffer pool)
    @available(*, deprecated, renamed: "playSound()")
    @inlinable
    static func playSoundMulti(_ sound: Sound) {
        RaylibC.PlaySound(sound)
    }

    /// Stop any sound playing (using multichannel buffer pool)
    @available(*, unavailable, renamed: "stopSound()")
    @inlinable
    static func stopSoundMulti() {
        fatalError()
    }

    /// Get number of sounds playing in the multichannel
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func getSoundsPlaying() -> Int32 {
        fatalError()
    }
}


// MARK: - Module Core
public extension Raylib {
    /// Get a ray trace from mouse position
    @available(*, deprecated, message: "use getScreenToWorldRay()")
    @inlinable
    static func getMouseRay(_ mousePosition: Vector2, _ camera: Camera) -> Ray {
        return RaylibC.GetScreenToWorldRay(mousePosition, camera)
    }

    /// Get filenames in a directory path (memory should be freed)
    @available(*, deprecated, message: "use loadDirectoryFiles()")
    @inlinable
    static func getDirectoryFiles(_ dirPath: String) -> [String] {
        return dirPath.withCString { cString in
            let result = RaylibC.LoadDirectoryFiles(cString)
            let buffer = UnsafeMutableBufferPointer(start: result.paths, count: Int(result.count))
            return buffer.compactMap({$0}).map({String(cString: $0)})
        }
    }

    /// Clear directory files paths buffers (free memory)
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func clearDirectoryFiles() {
        fatalError()
    }

    /// Get dropped files names (memory should be freed)
    @available(*, deprecated, message: "use loadDroppedFiles()")
    @inlinable
    static func getDroppedFiles() -> [String] {
        let result = RaylibC.LoadDroppedFiles()
        let buffer = UnsafeMutableBufferPointer(start: result.paths, count: Int(result.count))
        return buffer.compactMap({$0}).map({String(cString: $0)})
    }

    /// Clear dropped files paths buffer (free memory)
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func clearDroppedFiles() {
        fatalError()
    }

    /// Save integer value to storage file (to defined position), returns true on success
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func saveStorageValue(_ position: UInt32, _ value: Int32) -> Bool {
        fatalError()
    }
    
    /// Load integer value from storage file (from defined position)
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func loadStorageValue(_ position: UInt32) -> Int32 {
        fatalError()
    }
}

// MARK: - Module Models
public extension Raylib {
    /// Draw cube textured
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawCubeTexture(_ texture: Texture2D, _ position: Vector3, _ width: Float, _ height: Float, _ length: Float, _ color: Color) {
        fatalError()
    }
    
    /// Draw cube with a region of a texture
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawCubeTextureRec(_ texture: Texture2D, _ source: Rectangle, _ position: Vector3, _ width: Float, _ height: Float, _ length: Float, _ color: Color) {
        fatalError()
    }

    /// Unload model (but not meshes) from memory (RAM and/or VRAM)
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func unloadModelKeepMeshes(_ model: Model) {
        fatalError()
    }

    /// Compute mesh binormals
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func genMeshBinormals(_ mesh: inout Mesh) {
        fatalError()
    }

    /// Get collision info between ray and model
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func getRayCollisionModel(_ ray: Ray, _ model: Model) -> RayCollision {
        fatalError()
    }
}

// MARK: - Module Shapes
public extension Raylib {
    /// Draw line using quadratic bezier curves with a control point
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawLineBezierQuad(_ startPos: Vector2, _ endPos: Vector2, _ controlPos: Vector2, _ thick: Float, _ color: Color) {
        fatalError()
    }
    
    /// Draw line using cubic bezier curves with 2 control points
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawLineBezierCubic(_ startPos: Vector2, _ endPos: Vector2, _ startControlPos: Vector2, _ endControlPos: Vector2, _ thick: Float, _ color: Color) {
        fatalError()
    }

    /// Draw rectangle with rounded edges outline
    @available(*, unavailable, message: "Removed Raylib 5.5")
    @inlinable
    static func drawRectangleRoundedLines(_ rec: Rectangle, _ roundness: Float, _ segments: Int32, _ lineThick: Float, _ color: Color) {
        fatalError()
    }
}

// MARK: - Module Textures
public extension Raylib {
    /// Generate image: vertical gradient
    @available(*, deprecated, message: "use genImageGradientLinear()")
    @inlinable
    static func genImageGradientV(_ width: Int32, _ height: Int32, _ top: Color, _ bottom: Color) -> Image {
        return RaylibC.GenImageGradientLinear(width, height, 0, top, bottom)
    }
    
    /// Generate image: horizontal gradient
    @available(*, deprecated, message: "use genImageGradientLinear()")
    @inlinable
    static func genImageGradientH(_ width: Int32, _ height: Int32, _ left: Color, _ right: Color) -> Image {
        return RaylibC.GenImageGradientLinear(width, height, 90, left, right) // TODO: Not sure about the angle
    }

    /// Draw texture quad with tiling and offset parameters
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawTextureQuad(_ texture: Texture2D, _ tiling: Vector2, _ offset: Vector2, _ quad: Rectangle, _ tint: Color) {
        fatalError()
    }
    
    /// Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawTextureTiled(_ texture: Texture2D, _ source: Rectangle, _ dest: Rectangle, _ origin: Vector2, _ rotation: Float, _ scale: Float, _ tint: Color) {
        fatalError()    
    }

    /// Draw a textured polygon
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    static func drawTexturePoly(_ texture: Texture2D, _ center: Vector2, _ points: [Vector2], _ texcoords: [Vector2], _ tint: Color) {
        fatalError()
    }
}

// MARK: - Module Math
public extension  Raylib {
    /// Normalize provided matrix
    @available(*, unavailable, message: "Removed in Raylib 5.5")
    @inlinable
    var normalized: Matrix {
        fatalError()
    }
}
