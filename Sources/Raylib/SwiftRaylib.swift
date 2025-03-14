/**
 * Copyright (c) 2022 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under MIT License
 *
 * http://stregasgate.com
 */

import RaylibC

// Vector2 type
@_exported import struct RaylibC.Vector2

// Vector3 type
@_exported import struct RaylibC.Vector3

// Vector4 type
@_exported import struct RaylibC.Vector4

// Quaternion type, same as Vector4
@_exported import typealias RaylibC.Quaternion

// Matrix type (OpenGL style 4x4 - right handed, column major)
@_exported import struct RaylibC.Matrix

// Color type, RGBA (32bit)
@_exported import struct RaylibC.Color

// Rectangle type
@_exported import struct RaylibC.Rectangle

// Image type, bpp always RGBA (32bit)
// NOTE: Data stored in CPU memory (RAM)
@_exported import struct RaylibC.Image

// Texture type
// NOTE: Data stored in GPU memory
@_exported import struct RaylibC.Texture

// Texture2D type, same as Texture
@_exported import typealias RaylibC.Texture2D

// TextureCubemap type, actually, same as Texture
@_exported import typealias RaylibC.TextureCubemap

// RenderTexture type, for texture rendering
@_exported import struct RaylibC.RenderTexture

// RenderTexture2D type, same as RenderTexture
@_exported import typealias RaylibC.RenderTexture2D

// N-Patch layout info
@_exported import struct RaylibC.NPatchInfo

// Font character info
@_exported import struct RaylibC.GlyphInfo

// Font type, includes texture and charSet array data
@_exported import struct RaylibC.Font

// SpriteFont type fallback, defaults to Font

// Camera type, defines a camera position/orientation in 3d space
@_exported import struct RaylibC.Camera3D

// Camera type fallback, defaults to Camera3D
@_exported import typealias RaylibC.Camera

// Camera2D type, defines a 2d camera
@_exported import struct RaylibC.Camera2D

// Vertex data definning a mesh
// NOTE: Data stored in CPU memory (and GPU)
@_exported import struct RaylibC.Mesh

// Shader type (generic)
@_exported import struct RaylibC.Shader

// Material texture map
@_exported import struct RaylibC.MaterialMap

// Material type (generic)
@_exported import struct RaylibC.Material

// Transformation properties
@_exported import struct RaylibC.Transform

// Bone information
@_exported import struct RaylibC.BoneInfo

// Model type
@_exported import struct RaylibC.Model

// Model animation
@_exported import struct RaylibC.ModelAnimation

// Ray type (useful for raycast)
@_exported import struct RaylibC.Ray

// RayCollision, ray hit information
@_exported import struct RaylibC.RayCollision

// Bounding box type
@_exported import struct RaylibC.BoundingBox

// Wave type, defines audio wave data
@_exported import struct RaylibC.Wave

// Audio stream type
// NOTE: Useful to create custom audio streams not bound to a specific file
@_exported import struct RaylibC.AudioStream

// Sound source type
@_exported import struct RaylibC.Sound

// Music stream type (audio file streaming from memory)
// NOTE: Anything longer than ~10 seconds should be streamed
@_exported import struct RaylibC.Music

// Head-Mounted-Display device parameters
@_exported import struct RaylibC.VrDeviceInfo

// VR Stereo rendering configuration for simulator
@_exported import struct RaylibC.VrStereoConfig

// File path list
@_exported import struct RaylibC.FilePathList

/// Automation event list
@_exported import struct RaylibC.AutomationEventList

#if canImport(Foundation)
@_exported import struct Foundation.URL
@_exported import class Foundation.Bundle
#endif

public enum Raylib {
    @inlinable
    public static var raylibVersion: String {
        return RAYLIB_VERSION
    }
}
