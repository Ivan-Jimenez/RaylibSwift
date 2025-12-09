/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylib's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_free.c */

import Raylib

final class Core3DCameraFree {
    // MARK: - Global variables
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450

    var  camera = Camera3D()    
    var cubePosition = Vector3(x: 0.0, y: 0.0, z: 0.0)

    // MARK: - Game Loop
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free")
        Raylib.setTargetFPS(60)    // Set our game to run at 60 frames-per-second 
        Raylib.disableCursor()     // Limit cursor to relative movement inside the window
        setupGame()               

        while !Raylib.windowShouldClose {
            updateGame()
            drawGame()
        }

        Raylib.closeWindow()
    }

    // MARK: - Setup
    func setupGame() {
        // Define the camera to look into our 3d world
        camera.position = Vector3(x: 10.0, y: 10.0, z: 10.0) // Camera position
        camera.target = Vector3(x: 0.0, y: 0.0, z: 0.0)      // Camera looking at point
        camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0)          // Camera up vector (rotation towards target)
        camera.fovy = 45.0                                   // Camera field-of-view Y
        camera.projection = .perspective                     // Camera projection type
    }

    // MARK: - Update
    func updateGame() {
        Raylib.updateCamera(&camera, .free)

        if Raylib.isKeyPressed(.letterZ) {
            camera.target = Vector3(x: 0.0, y: 0.0, z: 0.0)
        }
    }

    // MARK: - Draw
    func drawGame() {
        Raylib.beginDrawing()

            Raylib.clearBackground(.rayWhite)

            Raylib.beginMode3D(camera);

                Raylib.drawCube(cubePosition, 2.0, 2.0, 2.0, .red)
                Raylib.drawCubeWires(cubePosition, 2.0, 2.0, 2.0, .maroon)

                Raylib.drawGrid(10, 1.0)

            Raylib.endMode3D()

            Raylib.drawRectangle( 10, 10, 320, 93, Raylib.fade(.skyBlue, 0.5))
            Raylib.drawRectangleLines( 10, 10, 320, 93, .blue)

            Raylib.drawText("Free camera default controls:", 20, 20, 10, .black)
            Raylib.drawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, .darkGray)
            Raylib.drawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, .darkGray)
            Raylib.drawText("- Z to zoom to (0, 0, 0)", 40, 80, 10, .darkGray)

        Raylib.endDrawing()
    }
}
