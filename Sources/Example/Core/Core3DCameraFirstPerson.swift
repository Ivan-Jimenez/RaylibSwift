/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylibs's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_first_person.c */
import Raylib
import Foundation

final class Core3DCameraFirstPerson {
    // MARK: - Global variables
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450
    let maxColumns = 20

    var camera = Camera()
    var cameraMode: CameraMode = .firstPerson 

    var heights = [Float]()
    var positions = [Vector3]()
    var colors = [Color]()

    // MARK: - Game Loop
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person")
        Raylib.setTargetFPS(60)
        Raylib.disableCursor()    // Limit cursor to relative movement inside the window
        setupGame()

        // Main game loop
        while !Raylib.windowShouldClose {
            updateGame()
            drawGame()
        }

        Raylib.closeWindow()
    }

    // MARK: - Setup
    func setupGame() {
        // Define the camera to look into our 3d world (position, target, up vector)
        camera.position = Vector3(x: 0.0, y: 2.0, z: 4.0)    // Camera position
        camera.target = Vector3(x: 0.0, y: 2.0, z: 0.0)      // Camera looking at point
        camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0)          // Camera up vector (rotation towards target)
        camera.fovy = 60.0                                   // Camera field-of-view Y
        camera.projection = .perspective                     // Camera projection type

        // Generates some random columns
        for _ in 0..<maxColumns {
            let height = Float(Int32.random(in: 1...12))
            heights.append(height)
            positions.append(
                Vector3(x: Float(Int32.random(in: -15...15)), y: height/2.0, z: Float(Int32.random(in: -15...15)))
            )
            colors.append(Color(r: UInt8.random(in: 20...255), g: UInt8.random(in: 10...55), b: 30, a: 255))
        }
    }

    // MARK: - Update
    func updateGame() {
        // Switch camera mode
        if Raylib.isKeyPressed(.number1) {
            cameraMode = .free
            camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0) // Reset roll
        }

        if Raylib.isKeyPressed(.number2) {
            cameraMode = .firstPerson
            camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0) // Reset roll
        }

        if Raylib.isKeyPressed(.number3) {
            cameraMode = .thridPerson
            camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0) // Reset roll
        }

        if Raylib.isKeyPressed(.number4) {
            cameraMode = .orbital
            camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0) // Reset roll
        }

        // Switch camera projection
        if Raylib.isKeyPressed(.letterP) {
            if camera.projection == .perspective {
                // Create isometric view
                cameraMode = .thridPerson
                // Note: The target distance is related to the render distance in the orthographic projection
                camera.position = Vector3(x: 0.0, y: 2.0, z: -100.0)
                camera.target = Vector3(x: 0.0, y: 2.0, z: 0.0)
                camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0)
                camera.projection = .orthographic
                camera.fovy = 20.0 // near plane width in CAMERA_ORTHOGRAPHIC
                let deg2rad = Float.pi/180.0
                Raylib.cameraYaw(&camera, -135 * deg2rad, true) 
                Raylib.cameraPitch(&camera, -45 * deg2rad, true, true, false)
            } else if camera.projection == .orthographic {
                // Reset to default view
                cameraMode = .thridPerson
                camera.position = Vector3(x: 0.0, y: 2.0, z: 10.0)
                camera.target = Vector3(x: 0.0, y: 2.0, z: 0.0)
                camera.up = Vector3(x: 0.0, y: 1.0, z: 0.0)
                camera.projection = .perspective
                camera.fovy = 60.0
            }
        }

        // Update camera computes movement internally depending on the camera mode
        // Some default standard keyboard/mouse inputs are hardcoded to simplify use
        // For advance camera controls, it's reecommended to compute camera movement manually
        Raylib.updateCamera(&camera, cameraMode)                  // Update camera
    }

    // MARK: - Draw
    func drawGame() {
        Raylib.beginDrawing()

            Raylib.clearBackground(.rayWhite)

            Raylib.beginMode3D(camera)

                Raylib.drawPlane(Vector3(x: 0.0, y: 0.0, z: 0.0), Vector2(x: 32.0, y: 32.0), .lightGray) // Draw ground
                Raylib.drawCube(Vector3(x: -16.0, y: 2.5, z: 0.0), 1.0, 5.0, 32.0, .blue);     // Draw a blue wall
                Raylib.drawCube(Vector3(x: 16.0, y: 2.5, z: 0.0), 1.0, 5.0, 32.0, .lime);      // Draw a green wall
                Raylib.drawCube(Vector3(x: 0.0, y: 2.5, z: 16.0), 32.0, 5.0, 1.0, .gold);      // Draw a yellow wall

                // Draw some cubes around
                for i in 0..<maxColumns {
                    Raylib.drawCube(positions[i], 2.0, heights[i], 2.0, colors[i])
                    Raylib.drawCubeWires(positions[i], 2.0, heights[i], 2.0, .maroon)
                }

                // Draw player cube
                if (cameraMode == .thridPerson) {
                    Raylib.drawCube(camera.target, 0.5, 0.5, 0.5, .purple)
                    Raylib.drawCubeWires(camera.target, 0.5, 0.5, 0.5, .darkPurple)
                }

            Raylib.endMode3D()

            // Draw info boxes
            Raylib.drawRectangle(5, 5, 330, 100, Raylib.fade(.skyBlue, 0.5))
            Raylib.drawRectangleLines(5, 5, 330, 100, .blue)

            Raylib.drawText("Camera controls:", 15, 15, 10, .black)
            Raylib.drawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, .black)
            Raylib.drawText("- Look around: arrow keys or mouse", 15, 45, 10, .black)
            Raylib.drawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, .black)
            Raylib.drawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, .black)
            Raylib.drawText("- Camera projection key: P", 15, 90, 10, .black)

            Raylib.drawRectangle(600, 5, 195, 100, Raylib.fade(.skyBlue, 0.5))
            Raylib.drawRectangleLines(600, 5, 195, 100, .blue)

            Raylib.drawText("Camera status:", 610, 15, 10, .black)
            Raylib.drawText(String(format: "- Mode: %@", cameraMode.description), 610, 30, 10, .black)
            Raylib.drawText(String(format: "- Projection: %@", camera.projection.description), 610, 45, 10, .black)
            Raylib.drawText(String(format: "- Position: (%06.3f, %06.3f, %06.3f)", camera.position.x, camera.position.y, camera.position.z), 610, 60, 10, .black)
            Raylib.drawText(String(format: "- Target: (%06.3f, %06.3f, %06.3f)", camera.target.x, camera.target.y, camera.target.z), 610, 75, 10, .black)
            Raylib.drawText(String(format: "- Up: (%06.3f, %06.3f, %06.3f)", camera.up.x, camera.up.y, camera.up.z), 610, 90, 10, .black)

        Raylib.endDrawing()
    }
}

// MARK: - Extensions
private extension CameraMode {
    var description: String {
        switch self {
        case .free:        "FREE"
        case .firstPerson: "FIRST_PERSON"
        case .thridPerson: "THIRD_PERSON"
        case .orbital:     "ORBITAL"
        case .custom:      "CUSTOM"
        }
    }
}

private extension CameraProjection {
    var description: String {
        switch self {
        case .perspective:  "PERSPECTIVE"
        case .orthographic: "ORTHOGRAPHIC"
        }
    }
}
