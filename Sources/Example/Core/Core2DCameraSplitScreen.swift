/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylibs's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_2d_camera_split_screen.c */

import Raylib

final class Core2DCameraSplitScreen {
    // MARK:- Global variables
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 440
    let playerSize: Float =  40

    var player1 = Rectangle()
    var player2 = Rectangle()

    var camera1 = Camera2D()
    var camera2 = Camera2D()

    var screenCamera1 = RenderTexture()
    var screenCamera2 = RenderTexture()

    var splitScreenRect = Rectangle()

    // MARK: - Game Loop
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera split screen")
        Raylib.setTargetFPS(60)
        gameSetup()

        while !Raylib.windowShouldClose {
            updateGame()
            drawGame()
        }

        Raylib.closeWindow()
    }

    // MARK: - Setup
    func gameSetup() {
        player1 = .init(x: 200, y:200, width: playerSize, height: playerSize)
        player2 = .init(x: 250, y: 200, width: playerSize, height: playerSize)

        camera1.target = Vector2(x: player1.x, y: player1.y)
        camera1.offset = Vector2(x: 200.0, y: 200.0)
        camera1.rotation = 0.0
        camera1.zoom = 1.0

        camera2.target = Vector2(x: player2.x, y: player2.y)
        camera2.offset = Vector2(x: 200.0, y: 200.0)
        camera2.rotation = 0.0
        camera2.zoom = 1.0

        screenCamera1 = Raylib.loadRenderTexture(screenWidth/2, screenHeight)
        screenCamera2 = Raylib.loadRenderTexture(screenWidth/2, screenHeight)

        // Build a flipped rectangle the size of the split view to use for drawing later
        splitScreenRect = .init(
            x: 0.0, 
            y: 0.0, 
            width: Float(screenCamera1.texture.width), 
            height: Float(-screenCamera1.texture.height)
        )
    }

    // MARK: - Update
    func updateGame() {
        if Raylib.isKeyDown(.letterS) {
            player1.y += 3.0
        } else if Raylib.isKeyDown(.letterW) {
            player1.y -= 3.0
        }
        if Raylib.isKeyDown(.letterD) {
            player1.x += 3.0
        } else if Raylib.isKeyDown(.letterA) {
            player1.x -= 3.0
        }

        if Raylib.isKeyDown(.up) {
            player2.y -= 3.0
        } else if Raylib.isKeyDown(.down) {
            player2.y += 3.0
        }
        if Raylib.isKeyDown(.right) {
            player2.x += 3.0 
        } else if Raylib.isKeyDown(.left) {
            player2.x -= 3.0
        }

        camera1.target = Vector2(x: player1.x, y: player1.y)
        camera2.target = Vector2(x: player2.x, y: player2.y)
    }

    // MARK: - Draw
    func drawGame() {
        Raylib.beginTextureMode(screenCamera1)
            Raylib.clearBackground(.rayWhite)
            
            Raylib.beginMode2D(camera1)
            
                // Draw full scene with first camera
                for i in 0..<screenWidth/Int32(playerSize) + 1 {
                    Raylib.drawLineV(
                        Vector2(x: playerSize*Float(i), y: 0), 
                        Vector2(x: playerSize*Float(i), y: Float(screenHeight)), 
                        .lightGray
                    )
                }

                for i in 0..<screenHeight/Int32(playerSize) {
                    Raylib.drawLineV(
                        Vector2(x: 0, y: playerSize*Float(i)), 
                        Vector2(x: Float(screenWidth), y: playerSize*Float(i)), 
                        .lightGray
                    )
                }

                for i in 0..<screenWidth/Int32(playerSize) {
                    for j in 0..<screenHeight/Int32(playerSize) {
                        Raylib.drawText(
                            String(format: "[%i,%i]", i, j), 
                            10 + Int32(playerSize)*i, 
                            15 + Int32(playerSize)*j, 
                            10, 
                            .lightGray
                        )
                    }
                }

                Raylib.drawRectangleRec(player1, .red)
                Raylib.drawRectangleRec(player2, .blue)
            Raylib.endMode2D()
            
            Raylib.drawRectangle(0, 0, Raylib.getScreenWidth()/2, 30, Raylib.fade(.rayWhite, 0.6))
            Raylib.drawText("PLAYER1: W/S/A/D to move", 10, 10, 10, .maroon)
            
        Raylib.endTextureMode()

        Raylib.beginTextureMode(screenCamera2)
            Raylib.clearBackground(.rayWhite)
            
            Raylib.beginMode2D(camera2)
            
                // Draw full scene with second camera
                for i in 0..<screenWidth/Int32(playerSize) {
                    Raylib.drawLineV(
                        Vector2(x: playerSize*Float(i), y: 0), 
                        Vector2(x: playerSize*Float(i), y: Float(screenHeight)), 
                        .lightGray
                    )
                }

                for i in 0..<screenHeight/Int32(playerSize) {
                    Raylib.drawLineV(
                        Vector2(x: 0, y: playerSize*Float(i)), 
                        Vector2(x: Float(screenWidth), y: playerSize*Float(i)), 
                        .lightGray
                    )
                }

                for i in 0..<screenWidth/Int32(playerSize) {
                    for j in 0..<screenHeight/Int32(playerSize) {
                        Raylib.drawText(
                            String(format: "[%i,%i]", i, j), 
                            10 + Int32(playerSize)*i, 
                            15 + Int32(playerSize)*j, 
                            10, .lightGray
                        )
                    }
                }

                Raylib.drawRectangleRec(player1, .red)
                Raylib.drawRectangleRec(player2, .blue)
                
            Raylib.endMode2D()
            
            Raylib.drawRectangle(0, 0, Raylib.getScreenWidth()/2, 30, Raylib.fade(.rayWhite, 0.6))
            Raylib.drawText("PLAYER2: UP/DOWN/LEFT/RIGHT to move", 10, 10, 10, .darkBlue)
            
        Raylib.endTextureMode()

        // Draw both views render textures to the screen side by side
        Raylib.beginDrawing();
            Raylib.clearBackground(.black);
            
            Raylib.drawTextureRec(screenCamera1.texture, splitScreenRect, Vector2(x: 0, y: 0), .white)
            Raylib.drawTextureRec(screenCamera2.texture, splitScreenRect, Vector2(x: Float(screenWidth)/2.0, y: 0), .white)
            
            Raylib.drawRectangle(Raylib.getScreenWidth()/2 - 2, 0, 4, Raylib.getScreenHeight(), .lightGray)
        Raylib.endDrawing()
    }

    // MARK: - De-Initialization
    deinit {
        Raylib.unloadRenderTexture(screenCamera1); // Unload render texture
        Raylib.unloadRenderTexture(screenCamera2); // Unload render texture
    }
}
