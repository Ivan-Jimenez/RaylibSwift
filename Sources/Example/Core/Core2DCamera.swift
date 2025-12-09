/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylibs's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_2d_camera.c */

import Foundation
import Raylib 

final class Core2DCamera {
    // MARK:-  Global variables
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450
    let maxBuildings = 100

    var player = Rectangle(x: 400, y: 280, width: 40, height: 40)
    var buildings: [Rectangle] = []
    var buildColors: [Color] = []
    var camera = Camera2D()

    // MARK: Game Loop
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")
        Raylib.setTargetFPS(60)
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
        var spacing = 0

        for _ in 0..<maxBuildings {
            let width = Int.random(in: 20...200)
            let height = Int.random(in: 100...800)
            
            let building = Rectangle(
                x: Float(-6_000 + spacing), 
                y: Float(Int(screenHeight) - 130 - height), 
                width: Float(width), 
                height: Float(height)
            )
            buildings.append(building)

            spacing += width

            let color = Color(
                r: UInt8.random(in: 200...240), 
                g: UInt8.random(in: 200...240), 
                b: UInt8.random(in: 200...250), 
                a: 255
            )
            buildColors.append(color)
        }

        camera.target = Vector2(x: player.x + 20.0, y: player.y + 20.0)
        camera.offset = Vector2(x: Float(screenWidth)/2.0, y: Float(screenHeight)/2.0)
        camera.rotation = 0.0
        camera.zoom = 1.0
    }

    // MARK: Update
    func updateGame() {
        // Player movement
        if Raylib.isKeyDown(.right) {
            player.x += 2.0
        } else if Raylib.isKeyDown(.left) {
            player.x -= 2.0
        }

        // Camera target follows player
        camera.target = Vector2(x: player.x  + 20.0, y: player.y + 20.0)

        // Camera rotation controls
        if Raylib.isKeyDown(.letterA) {
            camera.rotation += 1
        } else if Raylib.isKeyDown(.letterS) {
            camera.rotation -= 1
        }

        // Limit Camera rotation to 80 degress (-40 to 40)
        if camera.rotation > 40 {
            camera.rotation = 40
        } else if camera.rotation < -40 {
            camera.rotation = -40
        }

        // Camera zoom controls
        // Uses log scaling to provide consistent zoom speed
        camera.zoom = exp(log(camera.zoom) + (Float(Raylib.getMouseWheelMove()*0.1)))

        if camera.zoom > 3 {
            camera.zoom = 3
        } else if camera.zoom < 0.1 {
            camera.zoom = 0.1
        }

        // Camera reset (zoom and rotation)
        if Raylib.isKeyPressed(.letterR) {
            camera.zoom = 1
            camera.rotation = 0
        }
    }

    // MARK: - Draw
    func drawGame() {
        Raylib.beginDrawing()
        Raylib.clearBackground(.rayWhite)
        
        Raylib.beginMode2D(camera)
        
        Raylib.drawRectangle(-6_000, 320, 13_000, 8_000, .darkGray)

        for (building, color) in zip(buildings, buildColors) {
            Raylib.drawRectangleRec(building, color)
        }

        Raylib.drawRectangleRec(player, .red)

        Raylib.drawLine(Int32(camera.target.x), -screenHeight*10, Int32(camera.target.x), screenHeight*10, .green)
        Raylib.drawLine(-screenWidth*10, Int32(camera.target.y), screenWidth*10, Int32(camera.target.y), .green)

        Raylib.endMode2D()

        Raylib.drawText("SCREEN AREA", 640, 10, 20, .red)

        Raylib.drawRectangle(0, 0, screenWidth, 5, .red);
        Raylib.drawRectangle(0, 5, 5, screenHeight - 10, .red);
        Raylib.drawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, .red);
        Raylib.drawRectangle(0, screenHeight - 5, screenWidth, 5, .red);
        
        Raylib.drawRectangle( 10, 10, 250, 113, Raylib.fade(.skyBlue, 0.5));
        Raylib.drawRectangleLines( 10, 10, 250, 113, .blue);
        
        Raylib.drawText("Free 2d camera controls:", 20, 20, 10, .black);
        Raylib.drawText("- Right/Left to move Offset", 40, 40, 10, .darkGray);
        Raylib.drawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, .darkGray);
        Raylib.drawText("- A / S to Rotate", 40, 80, 10, .darkGray);
        Raylib.drawText("- R to reset Zoom and Rotation", 40, 100, 10, .darkGray);

        Raylib.endDrawing()
    }
}
