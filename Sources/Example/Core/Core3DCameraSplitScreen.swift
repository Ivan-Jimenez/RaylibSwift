/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylib's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_split_screen.c */

import Raylib

final class Core3DCameraSplitScreen {
    // MARK: - Global Variables
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450

    var cameraPlayer1 = Camera()
    var screenPlayer1 = RenderTexture()

    var cameraPlayer2 = Camera()
    var screenPlayer2 = RenderTexture()

    var splitScreenRect = Rectangle()

    // Grid data
    let count = 5
    let spacing = 4

    // MARK: - Game Loop
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera split screen")
        Raylib.setTargetFPS(60)
        setupGame()

        while !Raylib.windowShouldClose {
            updateGame()
            drawGame()
        }

        Raylib.closeWindow()
    }

    // MARK: Setup
    func setupGame() {
        // Setup player 1 camera and screen
        cameraPlayer1.fovy = 45.0
        cameraPlayer1.up.y = 1.0
        cameraPlayer1.target.y = 1.0
        cameraPlayer1.position.z = -3.0
        cameraPlayer1.position.y = 1.0
        
        screenPlayer1 = Raylib.loadRenderTexture(screenWidth/2, screenHeight)

        // Setup player two camera and screen
        cameraPlayer2.fovy = 45.0
        cameraPlayer2.up.y = 1.0
        cameraPlayer2.target.y = 3.0
        cameraPlayer2.position.x = -3.0
        cameraPlayer2.position.y = 3.0

        screenPlayer2 = Raylib.loadRenderTexture(screenWidth / 2, screenHeight)

        // Build a flipped rectangle the size of the split view to use for drawing later
        splitScreenRect = Rectangle(
            x: 0.0, 
            y: 0.0, 
            width: Float(screenPlayer1.texture.width), 
            height: Float(-screenPlayer1.texture.height)
        )
    }

    // MARK: - Update
    func updateGame() {
        // If anyone moves this frame, how far will they move based on the time since the last frame
        // this moves thigns at 10 world units per second, regardless of the actual FPS
        let offsetThisFrame = 10.0*Raylib.getFrameTime()

        // Move Player1 forward and backwards (no turning)
        if Raylib.isKeyDown(.letterW) {
            cameraPlayer1.position.z += offsetThisFrame;
            cameraPlayer1.target.z += offsetThisFrame;
        } else if Raylib.isKeyDown(.letterS) {
            cameraPlayer1.position.z -= offsetThisFrame;
            cameraPlayer1.target.z -= offsetThisFrame;
        }

        // Move Player2 forward and backwards (no turning)
        if Raylib.isKeyDown(.up) {
            cameraPlayer2.position.x += offsetThisFrame;
            cameraPlayer2.target.x += offsetThisFrame;
        } else if Raylib.isKeyDown(.down) {
            cameraPlayer2.position.x -= offsetThisFrame;
            cameraPlayer2.target.x -= offsetThisFrame;
        }
    }

    // MARK: - Draw
    func drawGame() {
        // Draw Player1 view to the render texture
        Raylib.beginTextureMode(screenPlayer1)
            Raylib.clearBackground(.skyBlue)
            
            Raylib.beginMode3D(cameraPlayer1)
            
                // Draw scene: grid of cube trees on a plane to make a "world"
                Raylib.drawPlane(Vector3(x: 0, y: 0, z: 0), Vector2(x: 50, y: 50), .beige) // Simple world plane

                for x in stride(from: -count*spacing, to: count*spacing, by: spacing) {
                    for z in stride(from: -count*spacing, to: count*spacing, by: spacing) {
                        Raylib.drawCube(Vector3(x: Float(x), y: 1.5, z: Float(z)), 1, 1, 1, .lime)
                        Raylib.drawCube(Vector3(x: Float(x), y: 0.5, z: Float(z)), 0.25, 1, 0.25, .brown)
                    }
                }

                // Draw a cube at each player's position
                Raylib.drawCube(cameraPlayer1.position, 1, 1, 1, .red)
                Raylib.drawCube(cameraPlayer2.position, 1, 1, 1, .blue)
                
            Raylib.endMode3D()
            
            Raylib.drawRectangle(0, 0, Raylib.getScreenWidth()/2, 40, Raylib.fade(.rayWhite, 0.8))
            Raylib.drawText("PLAYER1: W/S to move", 10, 10, 20, .maroon)
            
        Raylib.endTextureMode()

        // Draw Player2 view to the render texture
        Raylib.beginTextureMode(screenPlayer2)
            Raylib.clearBackground(.skyBlue)
            
            Raylib.beginMode3D(cameraPlayer2)
            
                // Draw scene: grid of cube trees on a plane to make a "world"
                Raylib.drawPlane(Vector3(x: 0, y: 0, z: 0), Vector2(x: 50, y: 50), .beige) // Simple world plane

                for x in stride(from: -count*spacing, to: count*spacing, by: spacing) {
                    for z in stride(from: -count*spacing, to: count*spacing, by: spacing) {
                        Raylib.drawCube(Vector3(x: Float(x), y: 1.5, z: Float(z)), 1, 1, 1, .lime)
                        Raylib.drawCube(Vector3(x: Float(x), y: 0.5, z: Float(z)), 0.25, 1, 0.25, .brown)
                    }
                }

                // Draw a cube at each player's position
                Raylib.drawCube(cameraPlayer1.position, 1, 1, 1, .red)
                Raylib.drawCube(cameraPlayer2.position, 1, 1, 1, .blue)
                
            Raylib.endMode3D()
            
            Raylib.drawRectangle(0, 0, Raylib.getScreenWidth()/2, 40, Raylib.fade(.rayWhite, 0.8))
            Raylib.drawText("PLAYER2: UP/DOWN to move", 10, 10, 20, .darkBlue)
            
        Raylib.endTextureMode()

        // Draw both views render textures to the screen side by side
        Raylib.beginDrawing()
            Raylib.clearBackground(.black)
            
            Raylib.drawTextureRec(screenPlayer1.texture, splitScreenRect, Vector2(x: 0, y: 0), .white)
            Raylib.drawTextureRec(screenPlayer2.texture, splitScreenRect, Vector2(x: Float(screenWidth)/2.0, y: 0), .white)
            
            Raylib.drawRectangle(Raylib.getScreenWidth()/2 - 2, 0, 4, Raylib.getScreenHeight(), .lightGray)
        Raylib.endDrawing()
    }

    // MARK: - De-Initialization
    deinit {
        Raylib.unloadRenderTexture(screenPlayer1) // Unload render texture
        Raylib.unloadRenderTexture(screenPlayer2) // Unload render texture
    }
}
