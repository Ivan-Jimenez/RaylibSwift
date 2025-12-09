/**
 * Copyright (c) 2025 Ivan Jimenez
 * All Rights Reserved.
 * Licensed under MIT License
 *
 */

/* Raylib's original example https://github.com/raysan5/raylib/blob/master/examples/core/core_2d_camera_platformer.c */

import Raylib

// MARK: - Structs
extension Camera2DPlatformer {
    struct Player {
        static let jumpSpd: Float = 350.0
        static let horSpd: Float = 200.0

        var position: Vector2
        var speed: Float
        var canJump: Bool
    }

    struct EnvItem {
        var rect: Rectangle
        var blocking: Bool
        var color: Color
    }
} 


final class Camera2DPlatformer {
    // MARK:-  Global variables
    let G: Float = 400
    let screenWidth: Int32 = 800
    let screenHeight: Int32 = 450

    let envItems: [EnvItem] = [
        .init(rect: .init(x:   0, y:   0, width: 1000, height: 400), blocking: false, color: .lightGray),
        .init(rect: .init(x:   0, y: 400, width: 1000, height: 200), blocking: true,  color: .gray),
        .init(rect: .init(x: 300, y: 200, width:  400, height:  10), blocking: true,  color: .gray),
        .init(rect: .init(x: 250, y: 300, width:  100, height:  10), blocking: true,  color: .gray),
        .init(rect: .init(x: 650, y: 300, width:  100, height:  10), blocking: true,  color: .gray)
    ]

    var mapBounds: (max: Vector2, min: Vector2) {
        var minX: Float = 0
        var minY: Float = 0
        var maxX: Float = 0
        var maxY: Float = 0

        for item in envItems {
            minX = min(item.rect.x, minX)
            maxX = max(item.rect.x + item.rect.width, maxX)
            minY = min(item.rect.y, minY)
            maxY = max(item.rect.y + item.rect.height, maxY)
        }
    
        return (.init(x: maxX, y: maxY), .init(x: minX, y: minY))
    }

    var cameraUpdaters: [(_ delta: Float) -> Void] = []

    let cameraDescriptions = [
        "Follow player center",
        "Follow player center, but clamp to map edges",
        "Follow player center; smoothed",
        "Follow player center horizontally; update player center vertically after landing",
        "Player push camera on getting too close to screen edge"
    ]

    var player = Player(position: .init(x: 400, y: 280), speed: 0, canJump: false)
    var camera = Camera2D()
    var cameraPosition: Int32 = 0
    var cameraOption = 0

    let minSpeed: Float = 30.0
    let minEffectLength: Float = 10
    let fractionSpeed: Float = 0.8

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
        camera.target = player.position
        camera.offset = .init(x: Float(screenWidth) / 2.0, y: Float(screenHeight) / 2.0)
        camera.rotation = 0
        camera.zoom = 0

        cameraUpdaters = [
            updateCameraCenter,
            updateCameraCenterInsideMap,
            updateCameraCenterSmoothFollow,
            updateCameraEvenOutOnLanding,
            updateCameraPlayerBoundsPush
        ]
    }

    // MARK: Update
    func updateGame() {
        let deltaTime = Raylib.getFrameTime()
        
        // player.update(envItems: envItems, deltaTime: deltaTime)
        updatePlayer(deltaTime)
        
        camera.zoom += Raylib.getMouseWheelMove() * 0.05
        if camera.zoom > 3.0 {
            camera.zoom = 3.0
        } else if camera.zoom < 0.25 {
            camera.zoom = 0.25
        }

        if Raylib.isKeyPressed(.letterR) {
            camera.zoom = 1.0
            player.position = .init(x: 400, y: 280)
        }

        if Raylib.isKeyPressed(.letterC) {
            cameraOption = (cameraOption + 1) % cameraUpdaters.count
        }
        cameraUpdaters[cameraOption](deltaTime)
    }

    // MARK: - Draw
    func drawGame() {
        Raylib.beginDrawing()
        Raylib.clearBackground(.lightGray)
        Raylib.beginMode2D(camera)

        for item in envItems {
            Raylib.drawRectangleRec(item.rect, item.color)
        }

        let playerRect = Rectangle(x: player.position.x - 20, y: player.position.y - 40, width: 40, height: 40)
        Raylib.drawRectangleRec(playerRect, .red)
        Raylib.drawCircleV(player.position, 5, .gold)

        Raylib.drawRectangleLines(Int32(mapBounds.min.x), Int32(mapBounds.min.y), Int32(mapBounds.max.x), Int32(mapBounds.max.y), .red)

        Raylib.endMode2D()

        Raylib.drawText("Controlls", 20, 20, 10, .black)
        Raylib.drawText("- Right/Left to move", 40, 40, 10, .darkGray)
        Raylib.drawText("- Space to jump", 40, 60, 10, .darkGray)
        Raylib.drawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, .darkGray);
        Raylib.drawText("- C to change camera mode", 40, 100, 10, .darkGray);
        Raylib.drawText("Current camera mode:", 20, 120, 10, .black);
        Raylib.drawText(cameraDescriptions[cameraOption], 40, 140, 10, .darkGray);

        Raylib.endDrawing()
    }
}


// MARK: - Player
extension Camera2DPlatformer {
    func updatePlayer(_ delta: Float) {
        if Raylib.isKeyDown(.left) {
            player.position.x -= Player.horSpd * delta
        }

        if Raylib.isKeyDown(.right) {
            player.position.x += Player.horSpd * delta
        }

        if Raylib.isKeyPressed(.space) {
            player.speed = -Player.jumpSpd
            player.canJump = false
        }

        if player.position.x > mapBounds.max.x {
            player.position.x = mapBounds.max.x
        }

        if player.position.x < mapBounds.min.x {
            player.position.x = mapBounds.min.x
        }

        if player.position.y > mapBounds.max.y {
            player.position.y = mapBounds.max.y
        }

        if player.position.y < mapBounds.min.y {
            player.position.y = mapBounds.min.y
        }

        var hitObstacle = false
        for item in envItems {
            let pos = player.position
            if item.blocking,
               item.rect.x <= pos.x,
               item.rect.x + item.rect.width >= pos.x,
               item.rect.y >= pos.y,
               item.rect.y <= pos.y + player.speed * delta {
                hitObstacle = true
                player.speed = 0
                player.position.y = item.rect.y
                break
            }
        }

        if !hitObstacle {
            player.position.y += player.speed*delta
            player.speed += G * delta
            player.canJump = false
        } else {
            player.canJump = true
        }
    }
}

// MARK: - Camera
extension Camera2DPlatformer {
    func updateCameraCenter(_ delta: Float) {
        camera.offset = Vector2(x: Float(screenWidth)/2, y: Float(screenHeight/2))
        camera.target = player.position
    }

    func updateCameraCenterInsideMap(_ delta: Float) {
        let width = Float(screenWidth)
        let height = Float(screenHeight)

        camera.target = player.position
        camera.offset = Vector2(x: width/2, y: height/2)
        
        let max = Raylib.getWorldToScreen2D(Vector2(x: mapBounds.max.x, y: mapBounds.max.y), camera)
        let min = Raylib.getWorldToScreen2D(Vector2(x: mapBounds.min.x, y: mapBounds.min.y), camera)

        if max.x < width { 
            camera.offset.x = width - (max.x - width/2) 
        }
        
        if max.y < height { 
            camera.offset.y = height - (max.y - height/2) 
        }
        
        if min.x > 0 { 
            camera.offset.x = width/2 - min.x
        }

        if min.y > 0 { 
            camera.offset.y = height/2 - min.y 
        }
    }

    func updateCameraCenterSmoothFollow(_ delta: Float) {
        let width = Float(screenWidth)
        let height = Float(screenHeight)

        camera.offset = Vector2(x: width/2, y: height/2)
        let diff = player.position - camera.target
        
        if diff.length > minEffectLength {
            let speed = max(fractionSpeed*diff.length, minSpeed)
            camera.target = camera.target + diff.scale(speed*delta/diff.length)
        }
    }

    func updateCameraEvenOutOnLanding(_ delta: Float) {
        let width = Float(screenWidth)
        let height = Float(screenHeight)
        
        let evenOutSpeed: Float = 700
        var eveningOut = false;
        var evenOutTarget: Float = 0

        camera.offset = Vector2(x: width/2.0, y: height/2.0)
        camera.target.x = player.position.x

        if eveningOut {
            if evenOutTarget > camera.target.y {
                camera.target.y += evenOutSpeed*delta;

                if camera.target.y > evenOutTarget {
                    camera.target.y = evenOutTarget
                    eveningOut = false
                }
            } else {
                camera.target.y -= evenOutSpeed*delta;

                if camera.target.y < evenOutTarget {
                    camera.target.y = evenOutTarget
                    eveningOut = false
                }
            }
        } else {
            if player.canJump && (player.speed == 0) && (player.position.y != camera.target.y) {
                eveningOut = true
                evenOutTarget = player.position.y
            }
        }
    }

    func updateCameraPlayerBoundsPush(_ delta: Float) {
        let width = Float(screenWidth)
        let height = Float(screenHeight)
        let bbox = Vector2(x: 0.2, y: 0.2 )

        let bboxWorldMin = Raylib.getScreenToWorld2D(Vector2(x: (1 - bbox.x) * 0.5*width, y: (1 - bbox.y) * 0.5*height), camera)
        let bboxWorldMax = Raylib.getScreenToWorld2D(Vector2(x: (1 + bbox.x) * 0.5*width, y: (1 + bbox.y) * 0.5*height), camera)
        camera.offset = Vector2(x: (1 - bbox.x) * 0.5*width, y: (1 - bbox.y) * 0.5*height)

        if player.position.x < bboxWorldMin.x { 
            camera.target.x = player.position.x 
        }
        
        if player.position.y < bboxWorldMin.y { 
            camera.target.y = player.position.y 
        }

        if player.position.x > bboxWorldMax.x { 
            camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x) 
        }
        
        if player.position.y > bboxWorldMax.y { 
            camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y) 
        }
    }
}
