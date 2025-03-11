/**
 * Copyright (c) 2022 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under MIT License
 *
 * http://stregasgate.com
 */

import RaylibC

//------------------------------------------------------------------------------------
// Texture Loading and Drawing Functions (Module: textures)
//------------------------------------------------------------------------------------
//MARK: - Image loading functions
// NOTE: This functions do not require GPU access
public extension Raylib {
    /// Load image from file into CPU memory (RAM)
    @inlinable
    static func loadImage(_ fileName: String) -> Image {
        return fileName.withCString { cString in
            return RaylibC.LoadImage(cString)
        }
    }
    
    /// Load image from RAW file data
    @inlinable
    static func loadImageRaw(_ fileName: String, _ width: Int32, _ height: Int32, _ format: PixelFormat, _ headerSize: Int32) -> Image {
        return fileName.withCString { cString in
            return RaylibC.LoadImageRaw(cString, width, height, format.rawValue, headerSize)
        }
    }
    
    /// Load image sequence from file (frames appended to image.data)
    @inlinable
    static func loadImageAnim(_ fileName: String, _ frames: inout Int32) -> Image {
        return fileName.withCString { cString in
            return RaylibC.LoadImageAnim(cString, &frames)
        }
    }
    
    /// Load image from memory buffer, fileType refers to extension: i.e. `.png`
    @inlinable
    static func loadImageFromMemory(_ fileType: String, _ fileData: UnsafePointer<UInt8>!, _ dataSize: Int32) -> Image {
        return fileType.withCString { cString in
            return RaylibC.LoadImageFromMemory(cString, fileData, dataSize)
        }
    }
    
    /// Load image from GPU texture data
    @inlinable
    static func loadImageFromTexture(_ texture: Texture2D) -> Image {
        return RaylibC.LoadImageFromTexture(texture)
    }
    
    // Load image from screen buffer and (screenshot)
    @inlinable
    static func loadImageFromScreen() -> Image {
        return RaylibC.LoadImageFromScreen()
    }

    /// Check if an image is valid (data and parameters)
    @inlinable
    static func isImageValid(_ image: Image) -> Bool {
        let result = RaylibC.IsImageValid(image)
#if os(Windows)
        return result.rawValue != 0
#else 
        return result
#endif
    }
    
    /// Unload image from CPU memory (RAM)
    @inlinable
    static func unloadImage(_ image: Image) {
        RaylibC.UnloadImage(image)
    }
    
    /// Export image data to file, returns true on success
    @inlinable
    static func exportImage(_ image: Image, _ fileName: String) -> Bool {
        return fileName.withCString { cString in
            let result = RaylibC.ExportImage(image, cString)
#if os(Windows)
            return result.rawValue != 0
#else
            return result
#endif
        }
    }
    
    /// Export image to memory buffer
    @inlinable
    static func exportImageToMemory(_ image: Image, _ fileType: String, _ fileSize: inout Int32) -> UnsafeMutablePointer<UInt8>! {
        return RaylibC.ExportImageToMemory(image, fileType, &fileSize)
    }
    
    /// Export image as code file defining an array of bytes, returns true on success
    @inlinable
    static func exportImageAsCode(_ image: Image, _ fileName: String) -> Bool {
        return fileName.withCString { cString in
            let result = RaylibC.ExportImageAsCode(image, cString)
#if os(Windows)
            return result.rawValue != 0
#else
            return result
#endif
        }
    }
}


//MARK: - Image generation functions
public extension Raylib {
    /// Generate image: plain color
    @inlinable
    static func genImageColor(_ width: Int32, _ height: Int32, _ color: Color) -> Image {
        return RaylibC.GenImageColor(width, height, color)
    }
    
    // TODO: Drecrated. Use GenImageGradientLinear
    /// Generate image: vertical gradient
    @inlinable
    static func genImageGradientV(_ width: Int32, _ height: Int32, _ top: Color, _ bottom: Color) -> Image {
        return RaylibC.GenImageGradientLinear(width, height, 0, top, bottom)
    }
    
    // TODO: Drecrated. Use GenImageGradientLinear
    /// Generate image: horizontal gradient
    @inlinable
    static func genImageGradientH(_ width: Int32, _ height: Int32, _ left: Color, _ right: Color) -> Image {
        return RaylibC.GenImageGradientLinear(width, height, 90, left, right) // TODO: Not sure about the angle
    }

    /// Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
    @inlinable
    static func genImageGradientLinear(_ width: Int32, _ height: Int32, direction: Int32, _ start: Color, _ end: Color) -> Image {
        return RaylibC.GenImageGradientLinear(width, height, direction, start, end)
    } 
    
    /// Generate image: radial gradient
    @inlinable
    static func genImageGradientRadial(_ width: Int32, _ height: Int32, _ density: Float, _ inner: Color, _ outer: Color) -> Image {
        return RaylibC.GenImageGradientRadial(width, height, density, inner, outer)
    }
    
    /// Generate image: checked
    @inlinable
    static func genImageChecked(_ width: Int32, _ height: Int32, _ checksX: Int32, _ checksY: Int32, _ col1: Color, _ col2: Color) -> Image {
        return RaylibC.GenImageChecked(width, height, checksX, checksY, col1, col2)
    }
    
    /// Generate image: white noise
    @inlinable
    static func genImageWhiteNoise(_ width: Int32, _ height: Int32, _ factor: Float) -> Image {
        return RaylibC.GenImageWhiteNoise(width, height, factor)
    }

    /// Generate image: perlin noise
    @inlinable
    static func genImagePerlinNoise(_ width: Int32, _ height: Int32, _ offsetX: Int32, _ offsetY: Int32, _ scale: Float) -> Image {
        return RaylibC.GenImagePerlinNoise(width, height, offsetX, offsetY, scale)
    }

    /// Generate image: cellular algorithm, bigger tileSize means bigger cells
    @inlinable
    static func genImageCellular(_ width: Int32, _ height: Int32, _ tileSize: Int32) -> Image {
        return RaylibC.GenImageCellular(width, height, tileSize)
    }

    /// Generate image: grayscale image from text data
    @inlinable
    static func genImageText(_ width: Int32, _ height: Int32, _ text: String) -> Image {
        return RaylibC.GenImageText(width, height, text)
    }
}


//MARK: - Image manipulation functions
public extension Raylib {
    /// Create an image duplicate (useful for transformations)
    @inlinable
    static func imageCopy(_ image: Image) -> Image {
        return RaylibC.ImageCopy(image)
    }
    
    /// Create an image from another image piece
    @inlinable
    static func imageFromImage(_ image: Image, _ rec: Rectangle) -> Image {
        return RaylibC.ImageFromImage(image, rec)
    }

    /// Create an image from a selected channel of another image (GRAYSCALE)
    @inlinable
    static func ImageFromChannel(_ image: Image, _ selectedChannel: Int32) -> Image {
        return RaylibC.ImageFromChannel(image, selectedChannel)
    }
    
    /// Create an image from text (default font)
    @inlinable
    static func imageText(_ text: String, _ fontSize: Int32, _ color: Color) -> Image {
        return text.withCString { cString in
            return RaylibC.ImageText(cString, fontSize, color)
        }
    }
    
    /// Create an image from text (custom sprite font)
    @inlinable
    static func imageTextEx(_ font: Font, _ text: String, _ fontSize: Float, _ spacing: Float, _ tint: Color) -> Image {
        return text.withCString { cString in
            return RaylibC.ImageTextEx(font, cString, fontSize, spacing, tint)
        }
    }
    
    /// Convert image data to desired format
    @inlinable
    static func imageFormat(_ image: inout Image, _ newFormat: PixelFormat) {
        RaylibC.ImageFormat(&image, newFormat.rawValue)
    }
    
    /// Convert image to POT (power-of-two)
    @inlinable
    static func imageToPOT(_ image: inout Image, _ fill: Color) {
        RaylibC.ImageToPOT(&image, fill)
    }
    
    /// Crop an image to a defined rectangle
    @inlinable
    static func imageCrop(_ image: inout Image, _ crop: Rectangle) {
        RaylibC.ImageCrop(&image, crop)
    }
    
    /// Crop image depending on alpha value
    @inlinable
    static func imageAlphaCrop(_ image: inout Image, _ threshold: Float) {
        RaylibC.ImageAlphaCrop(&image, threshold)
    }
    
    /// Clear alpha channel to desired color
    @inlinable
    static func imageAlphaClear(_ image: inout Image, _ color: Color, _ threshold: Float) {
        RaylibC.ImageAlphaClear(&image, color, threshold)
    }
    
    /// Apply alpha mask to image
    @inlinable
    static func imageAlphaMask(_ image: inout Image, _ alphaMask: Image) {
        RaylibC.ImageAlphaMask(&image, alphaMask)
    }
    
    /// Premultiply alpha channel
    @inlinable
    static func imageAlphaPremultiply(_ image: inout Image) {
        RaylibC.ImageAlphaPremultiply(&image)
    }

    /// Apply Gaussian blur using a box blur approximation
    @inlinable
    static func imageBlurGaussian(_ image: inout Image, _ blurSize: Int32) {
        RaylibC.ImageBlurGaussian(&image, blurSize)
    }                                            
    
    /// Apply custom square convolution kernel to image
    @inlinable
    static func imageKernelConvolution(_ image: inout Image, _ kernel: inout Float, _ kernelSize: Int32) {
        RaylibC.ImageKernelConvolution(&image, &kernel, kernelSize)
    }

    /// Resize image (Bicubic scaling algorithm)
    @inlinable
    static func imageResize(_ image: inout Image, _ newWidth: Int32, _ newHeight: Int32) {
        RaylibC.ImageResize(&image, newWidth, newHeight)
    }
    
    /// Resize image (Nearest-Neighbor scaling algorithm)
    @inlinable
    static func imageResizeNN(_ image: inout Image, _ newWidth: Int32, _ newHeight: Int32) {
        RaylibC.ImageResizeNN(&image, newWidth, newHeight)
    }
    
    /// Resize canvas and fill with color
    @inlinable
    static func imageResizeCanvas(_ image: inout Image, _ newWidth: Int32, _ newHeight: Int32, _ offsetX: Int32, _ offsetY: Int32, _ fill: Color) {
        RaylibC.ImageResizeCanvas(&image, newWidth, newHeight, offsetX, offsetY, fill)
    }
    
    /// Compute all mipmap levels for a provided image
    @inlinable
    static func imageMipmaps(_ image: inout Image) {
        RaylibC.ImageMipmaps(&image)
    }
    
    /// Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
    @inlinable
    static func imageDither(_ image: inout Image, _ rBpp: Int32, _ gBpp: Int32, _ bBpp: Int32, _ aBpp: Int32) {
        RaylibC.ImageDither(&image, rBpp, gBpp, bBpp, aBpp)
    }
    
    /// Flip image vertically
    @inlinable
    static func imageFlipVertical(_ image: inout Image) {
        RaylibC.ImageFlipVertical(&image)
    }
    
    /// Flip image horizontally
    @inlinable
    static func imageFlipHorizontal(_ image: inout Image) {
        RaylibC.ImageFlipHorizontal(&image)
    }
    
    /// Rotate image clockwise 90deg
    @inlinable
    static func imageRotateCW(_ image: inout Image) {
        RaylibC.ImageRotateCW(&image)
    }
    
    /// Rotate image counter-clockwise 90deg
    @inlinable
    static func imageRotateCCW(_ image: inout Image) {
        RaylibC.ImageRotateCCW(&image)
    }
    
    /// Modify image color: tint
    @inlinable
    static func imageColorTint(_ image: inout Image, _ color: Color) {
        RaylibC.ImageColorTint(&image, color)
    }
    
    /// Modify image color: invert
    @inlinable
    static func imageColorInvert(_ image: inout Image) {
        RaylibC.ImageColorInvert(&image)
    }
    
    /// Modify image color: grayscale
    @inlinable
    static func imageColorGrayscale(_ image: inout Image) {
        RaylibC.ImageColorGrayscale(&image)
    }
    
    /// Modify image color: contrast (-100 to 100)
    @inlinable
    static func imageColorContrast(_ image: inout Image, _ contrast: Float) {
        RaylibC.ImageColorContrast(&image, contrast)
    }
    
    /// Modify image color: brightness (-255 to 255)
    @inlinable
    static func imageColorBrightness(_ image: inout Image, _ brightness: Int32) {
        RaylibC.ImageColorBrightness(&image, brightness)
    }
    
    /// Modify image color: replace color
    @inlinable
    static func imageColorReplace(_ image: inout Image, _ color: Color, _ replace: Color) {
        RaylibC.ImageColorReplace(&image, color, replace)
    }
    
    /// Load color data from image as a Color array (RGBA - 32bit)
    @inlinable
    static func loadImageColors(_ image: Image) -> [Color] {
        let count = image.width * image.height * 4
        let result = RaylibC.LoadImageColors(image)
        let buffer = UnsafeMutableBufferPointer(start: result, count: Int(count))
        return Array(buffer)
    }
    
    /// Load colors palette from image as a Color array (RGBA - 32bit)
    @inlinable
    static func loadImagePalette(_ image: Image, _ maxPaletteSize: Int32) -> [Color] {
        var colorsCount: Int32 = 0
        let result = RaylibC.LoadImagePalette(image, maxPaletteSize, &colorsCount)
        let buffer = UnsafeMutableBufferPointer(start: result, count: Int(colorsCount))
        return Array(buffer)
    }
    
    /// Unload color data loaded with LoadImageColors()
    @inlinable @available(*, unavailable, message: "No need to do this in swift.")
    static func unloadImageColors(_ colors: [Color]) {
        var _colors = colors
        RaylibC.UnloadImageColors(&_colors)
    }
    
    /// Unload colors palette loaded with LoadImagePalette()
    @inlinable @available(*, unavailable, message: "No need to do this in swift.")
    static func unloadImagePalette(_ colors: [Color]) {
        var _colors = colors
        RaylibC.UnloadImagePalette(&_colors)
    }
    
    /// Get image alpha border rectangle
    @inlinable
    static func getImageAlphaBorder(_ image: Image, _ threshold: Float) -> Rectangle {
        return RaylibC.GetImageAlphaBorder(image, threshold)
    }
    
    /// Get image pixel color at (x, y) position
    @inlinable
    static func getImageColor(_ image: Image, _ x: Int32, _ y: Int32) -> Color {
        return RaylibC.GetImageColor(image, x, y)
    }
}


//MARK: - Image drawing functions
// NOTE: Image software-rendering functions (CPU)
public extension Raylib {
    /// Clear image background with given color
    @inlinable
    static func imageClearBackground(_ dst: inout Image, _ color: Color) {
        RaylibC.ImageClearBackground(&dst, color)
    }
    
    /// Draw pixel within an image
    @inlinable
    static func imageDrawPixel(_ dst: inout Image, _ posX: Int32, _ posY: Int32, _ color: Color) {
        RaylibC.ImageDrawPixel(&dst, posX, posY, color)
    }
    
    /// Draw pixel within an image (Vector version)
    @inlinable
    static func imageDrawPixelV(_ dst: inout Image, _ position: Vector2, _ color: Color) {
        RaylibC.ImageDrawPixelV(&dst, position, color)
    }
    
    /// Draw line within an image
    @inlinable
    static func imageDrawLine(_ dst: inout Image, _ startPosX: Int32, _ startPosY: Int32, _ endPosX: Int32, _ endPosY: Int32, _ color: Color) {
        RaylibC.ImageDrawLine(&dst, startPosX, startPosY, endPosX, endPosY, color)
    }
    
    /// Draw line within an image (Vector version)
    @inlinable
    static func imageDrawLineV(_ dst: inout Image, _ start: Vector2, _ end: Vector2, _ color: Color) {
        RaylibC.ImageDrawLineV(&dst, start, end, color)
    }

    /// Draw a line defining thickness within an image
    @inlinable
    static func imageDrawLineEx(_ dst: inout Image, _ start: Vector2, _ end: Vector2, _ thick: Int32, _ color: Color) {
        RaylibC.ImageDrawLineEx(&dst, start, end, thick, color)
    }
    
    /// Draw circle within an image
    @inlinable
    static func imageDrawCircle(_ dst: inout Image, _ centerX: Int32, _ centerY: Int32, _ radius: Int32, _ color: Color) {
        RaylibC.ImageDrawCircle(&dst, centerX, centerY, radius, color)
    }
    
    /// Draw circle within an image (Vector version)
    @inlinable
    static func imageDrawCircleV(_ dst: inout Image, _ center: Vector2, _ radius: Int32, _ color: Color) {
        RaylibC.ImageDrawCircleV(&dst, center, radius, color)
    }
    
    /// Draw circle outline within an image
    @inlinable
    static func imageDrawCircleLines(_ dst: inout Image, _ centerX: Int32, _ centerY: Int32, _ radius: Int32, _ color: Color) {
        RaylibC.ImageDrawCircleLines(&dst, centerX, centerY, radius, color)
    }

    /// Draw circle outline within an image (Vector version)
    @inlinable
    static func ImageDrawCircleLinesV(_ dst: inout Image, _ center: Vector2, _ radius: Int32, _ color: Color) {
        RaylibC.ImageDrawCircleLinesV(&dst, center, radius, color)
    }

    /// Draw rectangle within an image
    @inlinable
    static func imageDrawRectangle(_ dst: inout Image, _ posX: Int32, _ posY: Int32, _ width: Int32, _ height: Int32, _ color: Color) {
        RaylibC.ImageDrawRectangle(&dst, posX, posY, width, height, color)
    }
    
    /// Draw rectangle within an image (Vector version)
    @inlinable
    static func imageDrawRectangleV(_ dst: inout Image, _ position: Vector2, _ size: Vector2, _ color: Color) {
        RaylibC.ImageDrawRectangleV(&dst, position, size, color)
    }
    
    /// Draw rectangle within an image
    @inlinable
    static func imageDrawRectangleRec(_ dst: inout Image, _ rec: Rectangle, _ color: Color) {
        RaylibC.ImageDrawRectangleRec(&dst, rec, color)
    }
    
    /// Draw rectangle lines within an image
    @inlinable
    static func imageDrawRectangleLines(_ dst: inout Image, _ rec: Rectangle, _ thick: Int32, _ color: Color) {
        RaylibC.ImageDrawRectangleLines(&dst, rec, thick, color)
    }

    /// Draw triangle within an image
    @inlinable
    static func imageDrawTriangle(_ dst: inout Image, _ v1: Vector2, _ v2: Vector2, _ v3: Vector2, _ color: Color) {
        RaylibC.ImageDrawTriangle(&dst, v1, v2, v3, color)
    }
    
    /// Draw triangle with interpolated colors within an image
    @inlinable
    static func imageDrawTriangleEx(_ dst: inout Image, _ v1: Vector2, _ v2: Vector2, _ v3: Vector2, _ c1: Color, _ c2: Color, _ c3: Color) {
        RaylibC.ImageDrawTriangleEx(&dst, v1, v2, v3, c1, c2, c3)
    }

    /// Draw triangle outline within an image
    @inlinable
    static func imageDrawTriangleLines(_ dst: inout Image, _ v1: Vector2, _ v2: Vector2, _ v3: Vector2, _ color: Color) {
        RaylibC.ImageDrawTriangleLines(&dst, v1, v2, v3, color)
    }

    /// Draw a triangle fan defined by points within an image (first vertex is the center)
    @inlinable
    static func imageDrawTriangleFan(_ dst: inout Image, _ points: [Vector2], _ pointCount: Int32, _ color: Color) {
        var _points = points
        RaylibC.ImageDrawTriangleFan(&dst, &_points, pointCount, color)
    }

    /// Draw a triangle strip defined by points within an image
    @inlinable
    static func imageDrawTriangleStrip(_ dst: inout Image, _ points: [Vector2], _ pointCount: Int32, _ color: Color) {
        var _points = points
        RaylibC.ImageDrawTriangleStrip(&dst, &_points, pointCount, color)
    }

    /// Draw a source image within a destination image (tint applied to source)
    @inlinable
    static func imageDraw(_ dst: inout Image, _ src: Image, _ srcRec: Rectangle, _ dstRec: Rectangle, _ tint: Color) {
        RaylibC.ImageDraw(&dst, src, srcRec, dstRec, tint)
    }
    
    /// Draw text (using default font) within an image (destination)
    @inlinable
    static func imageDrawText(_ dst: inout Image, _ text: String, _ posX: Int32, _ posY: Int32, _ fontSize: Int32, _ color: Color) {
        text.withCString { cString in
            RaylibC.ImageDrawText(&dst, cString, posX, posY, fontSize, color)
        }
    }
    
    /// Draw text (custom sprite font) within an image (destination)
    @inlinable
    static func imageDrawTextEx(_ dst: inout Image, _ font: Font, _ text: String, _ position: Vector2, _ fontSize: Float, _ spacing: Float, _ tint: Color) {
        text.withCString { cString in
            RaylibC.ImageDrawTextEx(&dst, font, cString, position, fontSize, spacing, tint)
        }
    }
}


//MARK: - Texture loading functions
// NOTE: These functions require GPU access
public extension Raylib {
    /// Load texture from file into GPU memory (VRAM)
    @inlinable
    static func loadTexture(_ fileName: String) -> Texture2D {
        return fileName.withCString { cString in
            return RaylibC.LoadTexture(cString)
        }
    }
    
    /// Load texture from image data
    @inlinable
    static func loadTextureFromImage(_ image: Image) -> Texture2D {
        return RaylibC.LoadTextureFromImage(image)
    }
    
    /// Load cubemap from image, multiple image cubemap layouts supported
    @inlinable
    static func loadTextureCubemap(_ image: Image, _ layout: CubemapLayout) -> TextureCubemap {
        return RaylibC.LoadTextureCubemap(image, layout.rawValue)
    }
    
    /// Load texture for rendering (framebuffer)
    @inlinable
    static func loadRenderTexture(_ width: Int32, _ height: Int32) -> RenderTexture2D {
        return RaylibC.LoadRenderTexture(width, height)
    }
    
    /// Unload texture from GPU memory (VRAM)
    @inlinable
    static func unloadTexture(_ texture: Texture2D) {
        return RaylibC.UnloadTexture(texture)
    }

    /// Check if a render texture is valid (loaded in GPU)
    @inlinable
    static func isRenderTextureValid(_ target: RenderTexture2D) -> Bool {
        let result = RaylibC.IsRenderTextureValid(target)
#if os(Windows)
        return result.rawValue != 0
#else
        return result
#endif
    }
    
    /// Unload render texture from GPU memory (VRAM)
    @inlinable
    static func unloadRenderTexture(_ target: RenderTexture2D) {
        return RaylibC.UnloadRenderTexture(target)
    }
    
    /// Update GPU texture with new data
    @inlinable
    static func updateTexture(_ texture: Texture2D, _ pixels: UnsafeRawPointer!) {
        RaylibC.UpdateTexture(texture, pixels)
    }
    
    /// Update GPU texture rectangle with new data
    @inlinable
    static func updateTextureRec(_ texture: Texture2D, _ rec: Rectangle, _ pixels: UnsafeRawPointer!) {
        RaylibC.UpdateTextureRec(texture, rec, pixels)
    }
}

 
//MARK: - Texture configuration functions
public extension Raylib {
    /// Generate GPU mipmaps for a texture
    @inlinable
    static func genTextureMipmaps(_ texture: inout Texture2D) {
        RaylibC.GenTextureMipmaps(&texture)
    }
    
    /// Set texture scaling filter mode
    @inlinable
    static func setTextureFilter(_ texture: Texture2D, _ filter: TextureFilter) {
        RaylibC.SetTextureFilter(texture, filter.rawValue)
    }
    
    /// Set texture wrapping mode
    @inlinable
    static func setTextureWrap(_ texture: Texture2D, _ wrap: TextureWrap) {
        RaylibC.SetTextureWrap(texture, wrap.rawValue)
    }
}


//MARK: - Texture drawing functions
public extension Raylib {
    /// Draw a Texture2D
    @inlinable
    static func drawTexture(_ texture: Texture2D, _ posX: Int32, _ posY: Int32, _ tint: Color) {
        return RaylibC.DrawTexture(texture, posX, posY, tint)
    }
    
    /// Draw a Texture2D with position defined as Vector2
    @inlinable
    static func drawTextureV(_ texture: Texture2D, _ position: Vector2, _ tint: Color) {
        RaylibC.DrawTextureV(texture, position, tint)
    }
    
    //// Draw a Texture2D with extended parameters
    @inlinable
    static func drawTextureEx(_ texture: Texture2D, _ position: Vector2, _ rotation: Float, _ scale: Float, _ tint: Color) {
        RaylibC.DrawTextureEx(texture, position, rotation, scale, tint)
    }
    
    /// Draw a part of a texture defined by a rectangle
    @inlinable
    static func drawTextureRec(_ texture: Texture2D, _ source: Rectangle, _ position: Vector2, _ tint: Color) {
        RaylibC.DrawTextureRec(texture, source, position, tint)
    }
    
    // TODO: Deprecated
    /// Draw texture quad with tiling and offset parameters
    @inlinable
    static func drawTextureQuad(_ texture: Texture2D, _ tiling: Vector2, _ offset: Vector2, _ quad: Rectangle, _ tint: Color) {
        // RaylibC.DrawTextureQuad(texture, tiling, offset, quad, tint)
    }
    
    // TODO: Deprecated
    /// Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
    @inlinable
    static func drawTextureTiled(_ texture: Texture2D, _ source: Rectangle, _ dest: Rectangle, _ origin: Vector2, _ rotation: Float, _ scale: Float, _ tint: Color) {
        // RaylibC.DrawTextureTiled(texture, source, dest, origin, rotation, scale, tint)
    }
    
    /// Draw a part of a texture defined by a rectangle with 'pro' parameters
    @inlinable
    static func drawTexturePro(_ texture: Texture2D, _ source: Rectangle, _ dest: Rectangle, _ origin: Vector2, _ rotation: Float, _ tint: Color) {
        RaylibC.DrawTexturePro(texture, source, dest, origin, rotation, tint)
    }
    
    /// Draws a texture (or part of it) that stretches or shrinks nicely
    @inlinable
    static func drawTextureNPatch(_ texture: Texture2D, _ nPatchInfo: NPatchInfo, _ dest: Rectangle, _ origin: Vector2, _ rotation: Float, _ tint: Color) {
        RaylibC.DrawTextureNPatch(texture, nPatchInfo, dest, origin, rotation, tint)
    }
    
    // TODO: Deprecated
    /// Draw a textured polygon
    @inlinable
    static func drawTexturePoly(_ texture: Texture2D, _ center: Vector2, _ points: [Vector2], _ texcoords: [Vector2], _ tint: Color) {
        var _points = points
        var _texcoords = texcoords
        // RaylibC.DrawTexturePoly(texture, center, &_points, &_texcoords, Int32(points.count), tint)
    }
}


//MARK: - Color/pixel related functions
public extension Raylib {
    /// Check if two colors are equal
    @inlinable
    static func colorIsEqual(_ col1: Color, _ col2: Color) -> Bool {
        let result = RaylibC.ColorIsEqual(col1, col2)
#if os(Windows)
        return result.rawValue != 0 
#else
        return result
#endif
    }

    /// Get color with alpha applied, alpha goes from 0.0f to 1.0f
    @inlinable
    static func fade(_ color: Color, _ alpha: Float) -> Color {
        return RaylibC.Fade(color, alpha)
    }
    
    /// Get hexadecimal value for a Color
    @inlinable
    static func colorToInt(_ color: Color) -> Int32 {
        return RaylibC.ColorToInt(color)
    }
    
    /// Get Color normalized as float [0..1]
    static func colorNormalize(_ color: Color) -> Vector4 {
        return RaylibC.ColorNormalize(color)
    }
    
    /// Get Color from normalized values [0..1]
    @inlinable
    static func colorFromNormalized(_ normalized: Vector4) -> Color {
        return RaylibC.ColorFromNormalized(normalized)
    }
    
    /// Get HSV values for a Color, hue [0..360], saturation/value [0..1]
    @inlinable
    static func colorToHSV(_ color: Color) -> Vector3 {
        return RaylibC.ColorToHSV(color)
    }
    
    /// Get a Color from HSV values, hue [0..360], saturation/value [0..1]
    @inlinable
    static func colorFromHSV(_ hue: Float, _ saturation: Float, _ value: Float) -> Color {
        return RaylibC.ColorFromHSV(hue, saturation, value)
    }

    /// Get color multiplied with another color
    @inlinable
    static func colorTint(_ color: Color, _ tint: Color) -> Color {
        return RaylibC.ColorTint(color, tint)
    }

    /// Get color with brightness correction, brightness factor goes from -1.0f to 1.0f
    @inlinable
    static func colorBrightness(_ color: Color, _ factor: Float) -> Color {
        return RaylibC.ColorBrightness(color, factor)
    }
    
    /// Get color with contrast correction, contrast values between -1.0f and 1.0f
    @inlinable
    static func ColorContrast(_ color: Color, _ contrast: Float) -> Color {
        return RaylibC.ColorContrast(color, contrast)
    }

    /// Get color with alpha applied, alpha goes from 0.0f to 1.0f
    @inlinable
    static func colorAlpha(_ color: Color, _ alpha: Float) -> Color {
        return RaylibC.ColorAlpha(color, alpha)
    }
    
    /// Get src alpha-blended into dst color with tint
    @inlinable
    static func colorAlphaBlend(_ dst: Color, _ src: Color, _ tint: Color) -> Color {
        return RaylibC.ColorAlphaBlend(dst, src, tint)
    }
    
    /// Get color lerp interpolation between two colors, factor [0.0f..1.0f]
    @inlinable
    static func colorLerp(_ color1: Color, _ color2: Color, _ factor: Float) -> Color {
        return RaylibC.ColorLerp(color1, color2, factor)
    }

    /// Get Color structure from hexadecimal value
    @inlinable
    static func getColor(_ hexValue: UInt32) -> Color {
        return RaylibC.GetColor(hexValue)
    }
    
    /// Get Color from a source pixel pointer of certain format
    @inlinable
    static func getPixelColor(_ srcPtr: UnsafeMutableRawPointer!, _ format: PixelFormat) -> Color {
        return RaylibC.GetPixelColor(srcPtr, format.rawValue)
    }
    
    /// Set color formatted into destination pixel pointer
    @inlinable
    static func setPixelColor(_ dstPtr: UnsafeMutableRawPointer!, _ color: Color, _ format: PixelFormat) {
        return RaylibC.SetPixelColor(dstPtr, color, format.rawValue)
    }
    
    /// Get pixel data size in bytes for certain format
    @inlinable
    static func getPixelDataSize(_ width: Int32, _ height: Int32, _ format: PixelFormat) -> Int32 {
        return RaylibC.GetPixelDataSize(width, height, format.rawValue)
    }
}
