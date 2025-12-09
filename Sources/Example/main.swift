/**
 * Copyright (c) 2022 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under MIT License
 *
 * http://stregasgate.com
 */

 
// import Raylib

// let width: Int32 = 800
// let height: Int32 = 450
// let config: ConfigFlags = [.vsyncHint, .msaa4xHint, .windowHighDPI]

// Raylib.setConfigFlags(config)
// Raylib.initWindow(width, height, "Simple Spinning 3D Cube")

// var camera = Camera()
// camera.position = Vector3(x: 60.0, y: 60.0, z: 5.0)
// camera.target = Vector3(x: 0.0, y: 0.0, z: 0.0)
// camera.up = Vector3(x: 0.0, y: 1.0, z: 1.0)
// camera.fovy = 20.0
// camera.projection = .perspective

// Raylib.setTargetFPS(60)

// while !Raylib.windowShouldClose {
//     Raylib.updateCamera(&camera, .orbital)
//     Raylib.beginDrawing()
//     Raylib.clearBackground(.black)
//     Raylib.beginMode3D(camera)
//     Raylib.drawCube(Vector3(x: 0.0, y: 0.0, z: 0.0), 10.0, 10.0, 10.0, .green)
//     Raylib.drawCubeWires(Vector3(x: 0.0, y: 0.0, z: 0.0), 10, 10, 10.0, .blue)
//     Raylib.endMode3D()
//     Raylib.drawText("Spinning 3D Cube", 300, 420, 20, .blue)
//     Raylib.endDrawing()
// }

// Raylib.closeWindow()

let game = Core3DCameraSplitScreen()
game.run()