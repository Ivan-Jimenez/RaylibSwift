/**
 * Copyright (c) 2022 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under MIT License
 *
 * http://stregasgate.com
 */

import RaylibC

public extension Camera {    
    var projection: CameraProjection {
        get {
            return CameraProjection(rawValue: _projection)!
        }
        set {
            _projection = newValue.rawValue
        }
    }
}

extension Raylib {
    //------------------------------------------------------------------------------------
    // Camera System Functions (Module: camera)
    //------------------------------------------------------------------------------------

    /// Update camera position for selected mode
    @inlinable
    public static func updateCamera(_ camera: inout Camera, _ mode: CameraMode) {
        RaylibC.UpdateCamera(&camera, mode.rawValue)
    }

    /// Update camera movement/rotation
    @inlinable
    public static func updateCameraPro(
        _ camera: inout Camera, _ movement: Vector3, _ rotation: Vector3, _ zoom: Float
    ) {
        RaylibC.UpdateCameraPro(&camera, movement, rotation, zoom)
    }
}

// MARK: - Camera movement
extension Raylib {
    @inlinable
    public static func getCameraForward(_ camera: inout Camera) -> Vector3 {
        RaylibC.GetCameraForward(&camera)
    }

    @inlinable
    public static func getCameraUp(_ camera: inout Camera) -> Vector3 {
        RaylibC.GetCameraUp(&camera)
    }

    @inlinable
    public static func getCameraRight(_ camera: inout Camera) -> Vector3 {
        RaylibC.GetCameraRight(&camera)
    }

    @inlinable
    public static func cameraMoveForward(_ camera: inout Camera, _ distance: Float, _ moveInWorldPlane: Bool) {
        RaylibC.CameraMoveForward(&camera, distance, moveInWorldPlane)
    }

    @inlinable
    public static func cameraMoveUp(_ camera: inout Camera, _ distance: Float) {
        RaylibC.CameraMoveUp(&camera, distance)
    }

    @inlinable 
    public static func cameraMoveRight(_ camera: inout Camera, _ distance: Float, moveInWorldPlane: Bool) {
        RaylibC.CameraMoveRight(&camera, distance, moveInWorldPlane)
    }

    @inlinable
    public static func cameraMoveToTarget(_ camera: inout Camera, _ delta: Float) {
        RaylibC.CameraMoveToTarget(&camera, delta)
    }
}

// MARK: - Camera rotation
extension Raylib {
    @inlinable
    public static func cameraYaw(_ camera: inout Camera, _ angle: Float, _ rotateAroundTarget: Bool) {
        RaylibC.CameraYaw(&camera, angle, rotateAroundTarget)
    }

    @inlinable
    public static func cameraPitch(_ camera: inout Camera, _ angle: Float, _ lockView: Bool, _ rotateAroundTarget: Bool, _ rotateUp: Bool) {
        RaylibC.CameraPitch(&camera, angle, lockView, rotateAroundTarget, rotateUp)
    }

    @inlinable
    public static func cameraRoll(_ camera: inout Camera, _ angle: Float) {
        RaylibC.CameraRoll(&camera, angle)
    }

    @inlinable
    public func getCameraViewMatrix(_ camera: inout Camera) -> Matrix {
        RaylibC.GetCameraViewMatrix(&camera)
    }

    @inlinable
    public func getCameraProjectionMatrix(_ camera: inout Camera, _ aspect: Float) -> Matrix {
        RaylibC.GetCameraProjectionMatrix(&camera, aspect)
    }
}
