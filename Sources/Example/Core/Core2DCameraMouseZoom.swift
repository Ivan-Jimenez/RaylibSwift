/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylibs's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_2d_camera_mouse_zoom.c */

import Foundation
import Raylib
import RaylibC

final class Core2DCameraMouseZoom {
    // MARK: - Global variables
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450

    var camera = Camera2D()
    var zoomMode = 0;       // 0-Mouse Wheel, 1-Mouse Move

    // MARK: - Game Loop
    func run() {
        Raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera mouse zoom")
        Raylib.setTargetFPS(60)       // Set our game to run at 60 frames-per-second
        setupGame()

        while !Raylib.windowShouldClose {
            updateGame()
            drawGame()
        }

        Raylib.closeWindow()
    }

    // MARK: - Setup
    func setupGame() {
        camera.zoom = 1
    }

    // MARK: - Update
    func updateGame() {
        if Raylib.isKeyPressed(.number1) {
            zoomMode = 0
        } else if Raylib.isKeyPressed(.number2) {
            zoomMode = 1
        }

        // Translate based on mouse right click
        if Raylib.isMouseButtonDown(.left) {
            var delta = Raylib.getMouseDelta()
            delta = delta.scale(-1.0/camera.zoom)
            camera.target = camera.target + delta
        }

        if zoomMode == 0 {
            // Zoom based on mouse wheel
            let wheel = Raylib.getMouseWheelMove()
            if wheel != 0 {
                // Get the world point that is under the mouse
                let mouseWorldPos = Raylib.getScreenToWorld2D(Raylib.getMousePosition(), camera)

                // Set the offset to where the mouse is
                camera.offset = Raylib.getMousePosition()

                // Set the target to match, so that the camera maps the world space point
                // under the cursor to the screen space point under the cursor at any zoom
                camera.target = mouseWorldPos

                // Zoom increment
                // Uses log scaling to provide consistent zoom speed
                let scale = 0.2 * wheel
                camera.zoom = Raylib.clamp(exp(log(camera.zoom)+scale), 0.125, 64.0)
            }
        } else {
            // Zoom based on mouse right click
            if Raylib.isMouseButtonPressed(.right) {
                // Get the world point that is under the mouse
                let  mouseWorldPos = Raylib.getScreenToWorld2D(Raylib.getMousePosition(), camera)

                // Set the offset to where the mouse is
                camera.offset = Raylib.getMousePosition()

                // Set the target to match, so that the camera maps the world space point
                // under the cursor to the screen space point under the cursor at any zoom
                camera.target = mouseWorldPos
            }

            if Raylib.isMouseButtonDown(.right) {
                // Zoom increment
                // Uses log scaling to provide consistent zoom speed
                let deltaX = Raylib.getMouseDelta().x
                let scale = 0.005*deltaX
                camera.zoom = Raylib.clamp(exp(log(camera.zoom)+scale), 0.125, 64.0)
            }
        }
    }

    // MARK: - Draw
    func drawGame() {
        Raylib.beginDrawing()
            Raylib.clearBackground(.rayWhite)

            Raylib.beginMode2D(camera)
                // Draw the 3d grid, rotated 90 degrees and centered around 0,0
                // just so we have something in the XY plane
                rlPushMatrix()
                    rlTranslatef(0, 25*50, 0)
                    rlRotatef(90, 1, 0, 0)
                    Raylib.drawGrid(100, 50)
                rlPopMatrix()

                // Draw a reference circle
                Raylib.drawCircle(Raylib.getScreenWidth()/2, Raylib.getScreenHeight()/2, 50, .maroon)
            Raylib.endMode2D()

            // Draw mouse reference
            //Vector2 mousePos = GetWorldToScreen2D(GetMousePosition(), camera)
            Raylib.drawCircleV(Raylib.getMousePosition(), 4, .darkGray);
            Raylib.drawTextEx(
                Raylib.getFontDefault(), 
                String(format: "[%i, %i]", Raylib.getMouseX(), Raylib.getMouseY()),
                Raylib.getMousePosition() + Vector2(x: -44, y: -24), 20, 2, 
                .black
            )

            Raylib.drawText("[1][2] Select mouse zoom mode (Wheel or Move)", 20, 20, 20, .darkGray)
            if zoomMode == 0 {
                Raylib.drawText("Mouse left button drag to move, mouse wheel to zoom", 20, 50, 20, .darkGray)
            } else {
                Raylib.drawText("Mouse left button drag to move, mouse press and move to zoom", 20, 50, 20, .darkGray)
            }

        Raylib.endDrawing()
    }
}