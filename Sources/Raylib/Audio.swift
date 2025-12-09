/**
 * Copyright (c) 2022 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under MIT License
 *
 * http://stregasgate.com
 */

import RaylibC

//------------------------------------------------------------------------------------
// Audio Loading and Playing Functions (Module: audio)
//------------------------------------------------------------------------------------
//MARK: - Audio device management functions
public extension Raylib {
    /// Initialize audio device and context
    @inlinable
    static func initAudioDevice() {
        RaylibC.InitAudioDevice()
    }

    /// Close the audio device and context
    @inlinable
    static func closeAudioDevice() {
        RaylibC.CloseAudioDevice()
    }

    /// Check if audio device has been initialized successfully
    @inlinable
    static var isAudioDeviceReady: Bool {
        RaylibC.IsAudioDeviceReady()
    }

    /// Set master volume (listener)
    @inlinable
    static func setMasterVolume(_ volume: Float) {
        RaylibC.SetMasterVolume(volume)
    }

    /// Get master volume (listener)
    @inlinable
    static func getMasterVolume() -> Float {
        return RaylibC.GetMasterVolume()
    }
}

//MARK: - Wave/Sound loading/unloading functions
public extension Raylib {
    /// Load wave data from file
    @inlinable
    static func loadWave(_ fileName: String) -> Wave {
        return fileName.withCString { cString in
            return RaylibC.LoadWave(cString)
        }
    }

    /// Load wave from memory buffer, fileType refers to extension: i.e. ".wav"
    @inlinable
    static func loadWaveFromMemory(_ fileType: String, _ fileData: UnsafePointer<UInt8>!, _ dataSize: Int32) -> Wave {
        return fileType.withCString { fileCString in
            return RaylibC.LoadWaveFromMemory(fileCString, fileData, dataSize)
        }
    }

    /// Checks if wave data is valid (data loaded and parameters)
    @inlinable
    static func isWaveValid(_ wave: Wave) -> Bool {
        return RaylibC.IsWaveValid(wave)
    }

    /// Load sound from file
    @inlinable
    static func loadSound(_ fileName: String) -> Sound {
        return fileName.withCString { cString in
            return RaylibC.LoadSound(cString)
        }
    }

    /// Load sound from wave data
    @inlinable
    static func loadSoundFromWave(_ wave: Wave) -> Sound {
        return RaylibC.LoadSoundFromWave(wave)
    }

    /// Create a new sound that shares the same sample data as the source sound, does not own the sound data
    @inlinable
    static func loadSoundAlias(_ source: Sound) -> Sound {
        return RaylibC.LoadSoundAlias(source)
    }

    /// Checks if a sound is valid (data loaded and buffers initialized)
    @inlinable
    static func isSoundValid(_ sound: Sound) -> Bool {
        return RaylibC.IsSoundValid(sound)
    }

    /// Update sound buffer with new data
    @inlinable
    static func updateSound(_ sound: Sound, _ data: UnsafeRawPointer!, _ samplesCount: Int32) {
        return RaylibC.UpdateSound(sound, data, samplesCount)
    }

    /// Unload wave data
    @inlinable
    static func unloadWave(_ wave: Wave) {
        RaylibC.UnloadWave(wave)
    }

    /// Unload sound
    @inlinable
    static func unloadSound(_ sound: Sound) {
        RaylibC.UnloadSound(sound)
    }

    /// Unload a sound alias (does not deallocate sample data)
    @inlinable
    static func unloadSoundAlias(_ alias: Sound) {
        RaylibC.UnloadSoundAlias(alias)
    }

    /// Export wave data to file, returns true on success
    @inlinable
    static func exportWave(_ wave: Wave, _ fileName: String) -> Bool {
        return fileName.withCString { cString in
            RaylibC.ExportWave(wave, cString)
        }
    }

    /// Export wave sample data to code (.h), returns true on success
    @inlinable
    static func exportWaveAsCode(_ wave: Wave, _ fileName: String) -> Bool {
        return fileName.withCString { cString in
            RaylibC.ExportWaveAsCode(wave, cString)
        }
    }
}

//MARK: - Wave/Sound management functions
public extension Raylib {
    /// Play a sound
    @inlinable
    static func playSound(_ sound: Sound) {
        RaylibC.PlaySound(sound)
    }

    /// Stop playing a sound
    @inlinable
    static func stopSound(_ sound: Sound) {
        RaylibC.StopSound(sound)
    }

    /// Pause a sound
    @inlinable
    static func pauseSound(_ sound: Sound) {
        RaylibC.PauseSound(sound)
    }

    /// Resume a paused sound
    @inlinable
    static func resumeSound(_ sound: Sound) {
        RaylibC.ResumeSound(sound)
    }

    /// Check if a sound is currently playing
    @inlinable
    static func isSoundPlaying(_ sound: Sound) -> Bool {
        let result = RaylibC.IsSoundPlaying(sound)
        return result
    }

    /// Set volume for a sound (1.0 is max level)
    @inlinable
    static func setSoundVolume(_ sound: Sound, _ volume: Float) {
        RaylibC.SetSoundVolume(sound, volume)
    }

    /// Set pitch for a sound (1.0 is base level)
    @inlinable
    static func setSoundPitch(_ sound: Sound, _ pitch: Float) {
        RaylibC.SetSoundPitch(sound, pitch)
    }

    /// Set pan for a sound (0.5 is center)
    @inlinable
    static func setSoundPan(_ sound: Sound, _ pan: Float) {
        RaylibC.SetSoundPan(sound, pan)
    }

    /// Convert wave data to desired format
    @inlinable
    static func waveFormat(_ wave: inout Wave, _ sampleRate: Int32, _ sampleSize: Int32, _ channels: Int32) {
        RaylibC.WaveFormat(&wave, sampleRate, sampleSize, channels)
    }

    /// Copy a wave to a new wave
    @inlinable
    static func waveCopy(_ wave: Wave) -> Wave {
        return RaylibC.WaveCopy(wave)
    }

    /// Crop a wave to defined samples range
    @inlinable
    static func waveCrop(_ wave: inout Wave, _ initSample: Int32, _ finalSample: Int32) {
        RaylibC.WaveCrop(&wave, initSample, finalSample)
    }

    /// Load samples data from wave as a floats array
    @inlinable
    static func loadWaveSamples(_ wave: Wave) -> [Float] {
        let buffer = UnsafeMutableBufferPointer(start: RaylibC.LoadWaveSamples(wave), count: Int(wave.frameCount))
        let array = Array(buffer)
        RaylibC.UnloadWaveSamples(buffer.baseAddress)
        return array
    }

    /// Unload samples data loaded with LoadWaveSamples()
    @inlinable
    @available(*, unavailable, message: "Swift manages memory. There's no need to call this.")
    static func unloadWaveSamples(_ samples: [Float]) {
        var samples = samples
        RaylibC.UnloadWaveSamples(&samples)
    }
}

//MARK: - Music management functions
public extension Raylib {
    /// Load music stream from file
    @inlinable
    static func loadMusicStream(_ fileName: String) -> Music {
        return fileName.withCString { cString in
            return RaylibC.LoadMusicStream(cString)
        }
    }

    /// Load music stream from data
    @inlinable
    static func loadMusicStreamFromMemory(_ fileType: String, _ data: UnsafeMutablePointer<UInt8>!, _ dataSize: Int32) -> Music {
        return fileType.withCString { fileCString in
            return RaylibC.LoadMusicStreamFromMemory(fileCString, data, dataSize)
        }
    }

    /// Checks if a music stream is valid (context and buffers initialized)
    @inlinable
    static func isMusicValid(_ music: Music) -> Bool {
        let result = RaylibC.IsMusicValid(music)
        return result
    }

    /// Unload music stream
    @inlinable
    static func unloadMusicStream(_ music: Music) {
        RaylibC.UnloadMusicStream(music)
    }

    /// Start music playing
    @inlinable
    static func playMusicStream(_ music: Music) {
        RaylibC.PlayMusicStream(music)
    }

    /// Check if music is playing
    @inlinable
    static func isMusicStreamPlaying(_ music: Music) -> Bool {
        let result = RaylibC.IsMusicStreamPlaying(music)
        return result
    }

    /// Updates buffers for music streaming
    @inlinable
    static func updateMusicStream(_ music: Music) {
        RaylibC.UpdateMusicStream(music)
    }

    /// Stop music playing
    @inlinable
    static func stopMusicStream(_ music: Music) {
        RaylibC.StopMusicStream(music)
    }

    /// Pause music playing
    @inlinable
    static func pauseMusicStream(_ music: Music) {
        RaylibC.PauseMusicStream(music)
    }

    /// Resume playing paused music
    @inlinable
    static func resumeMusicStream(_ music: Music) {
        RaylibC.ResumeMusicStream(music)
    }

    /// Seek music to a position (in seconds)
    @inlinable
    static func seekMusicStream(_ music: Music, _ position: Float) {
        RaylibC.SeekMusicStream(music, position)
    }

    /// Set volume for music (1.0 is max level)
    @inlinable
    static func setMusicVolume(_ music: Music, _ volume: Float) {
        RaylibC.SetMusicVolume(music, volume)
    }

    /// Set pitch for a music (1.0 is base level)
    @inlinable
    static func setMusicPitch(_ music: Music, _ pitch: Float) {
        RaylibC.SetMusicPitch(music, pitch)
    }

    /// Set pan for a music (0.5 is center)
    @inlinable
    static func setMusicPan(_ music: Music, _ pan: Float) {
        RaylibC.SetMusicPan(music, pan)
    }

    /// Get music time length (in seconds)
    @inlinable
    static func getMusicTimeLength(_ music: Music) -> Float {
        return RaylibC.GetMusicTimeLength(music)
    }

    /// Get current music time played (in seconds)
    @inlinable
    static func getMusicTimePlayed(_ music: Music) -> Float {
        return RaylibC.GetMusicTimeLength(music)
    }
}

//MARK: - AudioStream management functions
public extension Raylib {
    /// Init audio stream (to stream raw audio pcm data)
    @inlinable
    static func loadAudioStream(_ sampleRate: UInt32, _ sampleSize: UInt32, _ channels: UInt32) -> AudioStream {
        return RaylibC.LoadAudioStream(sampleRate, sampleSize, channels)
    }

    /// Checks if an audio stream is valid (buffers initialized)
    @inlinable
    static func isAudioStreamValid(_ stream: AudioStream) -> Bool {
        let result = RaylibC.IsAudioStreamValid(stream)
        return result
    }

    /// Unload audio stream and free memory
    @inlinable
    static func unloadAudioStream(_ stream: AudioStream) {
        RaylibC.UnloadAudioStream(stream)
    }

    /// Update audio stream buffers with data
    @inlinable
    static func updateAudioStream(_ stream: AudioStream, _ data: UnsafeRawPointer!, _ samplesCount: Int32) {
        RaylibC.UpdateAudioStream(stream, data, samplesCount)
    }

    /// Check if any audio stream buffers requires refill
    @inlinable
    static func isAudioStreamProcessed(_ stream: AudioStream) -> Bool {
        RaylibC.IsAudioStreamPlaying(stream)
    }

    /// Play audio stream
    @inlinable
    static func playAudioStream(_ stream: AudioStream) {
        RaylibC.PlayAudioStream(stream)
    }

    /// Pause audio stream
    @inlinable
    static func pauseAudioStream(_ stream: AudioStream) {
        RaylibC.PauseAudioStream(stream)
    }

    /// Resume audio stream
    @inlinable
    static func resumeAudioStream(_ stream: AudioStream) {
        RaylibC.ResumeAudioStream(stream)
    }

    /// Check if audio stream is playing
    @inlinable
    static func isAudioStreamPlaying(_ stream: AudioStream) -> Bool {
        RaylibC.IsAudioStreamPlaying(stream)
    }

    /// Stop audio stream
    @inlinable
    static func stopAudioStream(_ stream: AudioStream) {
        RaylibC.StopAudioStream(stream)
    }

    /// Set volume for audio stream (1.0 is max level)
    @inlinable
    static func setAudioStreamVolume(_ stream: AudioStream, _ volume: Float) {
        RaylibC.SetAudioStreamVolume(stream, volume)
    }

    /// Set pitch for audio stream (1.0 is base level)
    @inlinable
    static func setAudioStreamPitch(_ stream: AudioStream, _ pitch: Float) {
        RaylibC.SetAudioStreamPitch(stream, pitch)
    }

    /// Set pan for audio stream (0.5 is centered)
    @inlinable
    static func setAudioStreamPan(_ stream: AudioStream, _ pan: Float) {
        RaylibC.SetAudioStreamPan(stream, pan)
    }

    /// Default size for new audio streams
    @inlinable
    static func setAudioStreamBufferSizeDefault(_ size: Int32) {
        RaylibC.SetAudioStreamBufferSizeDefault(size)
    }

    /// Audio thread callback to request new data
    @inlinable
    static func setAudioStreamCallback(_ stream: AudioStream, _ callback: AudioCallback) {
        RaylibC.SetAudioStreamCallback(stream, callback)
    }

    /// Attach audio stream processor to stream, receives the samples as `Float`
    @inlinable
    static func attachAudioStreamProcessor(_ stream: AudioStream, _ processor: AudioCallback)
    {
        RaylibC.AttachAudioStreamProcessor(stream, processor)
    }

    /// Detach audio stream processor from stream
    @inlinable
    static func detachAudioStreamProcessor(_ stream: AudioStream, _ processor: AudioCallback)
    {
        RaylibC.DetachAudioStreamProcessor(stream, processor)
    }

    /// Attach audio stream processor to the entire audio pipeline, receives the samples as `Float`
    @inlinable
    static func attachAudioMixedProcessor(_ processor: AudioCallback) {
        RaylibC.AttachAudioMixedProcessor(processor)
    }

    /// Detach audio stream processor from the entire audio pipeline
    @inlinable
    static func detachAudioMixedProcessor(_ processor: AudioCallback) {
        RaylibC.DetachAudioMixedProcessor(processor)
    }
}
