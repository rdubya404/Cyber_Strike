import SpriteKit
import AVFoundation

class AudioManager {
    
    // MARK: - Singleton
    static let shared = AudioManager()
    
    // MARK: - Audio Players
    var backgroundMusicPlayer: AVAudioPlayer?
    var soundEffectPlayers: [AVAudioPlayer] = []
    
    // MARK: - Settings
    var isMusicEnabled: Bool = true
    var isSoundEnabled: Bool = true
    var musicVolume: Float = 0.5
    var soundVolume: Float = 0.7
    
    // MARK: - Sound Names
    struct SoundNames {
        static let machineGun = "machine_gun"
        static let missile = "missile"
        static let laser = "laser"
        static let explosion = "explosion"
        static let hit = "hit"
        static let powerUp = "powerup"
        static let engine = "engine"
        static let alert = "alert"
    }
    
    // MARK: - Initialization
    private init() {
        setupAudioSession()
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // MARK: - Background Music
    func playBackgroundMusic(filename: String, fileExtension: String = "mp3") {
        guard isMusicEnabled else { return }
        
        // Stop current music
        backgroundMusicPlayer?.stop()
        
        // In a real implementation, load from bundle
        // For now, this is a placeholder
        print("Playing background music: \(filename)")
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        guard isMusicEnabled else { return }
        backgroundMusicPlayer?.play()
    }
    
    // MARK: - Sound Effects
    func playSoundEffect(named name: String) {
        guard isSoundEnabled else { return }
        
        // In a real implementation, load and play sound
        // For now, this is a placeholder
        print("Playing sound effect: \(name)")
    }
    
    func playMachineGunSound() {
        playSoundEffect(named: SoundNames.machineGun)
    }
    
    func playMissileSound() {
        playSoundEffect(named: SoundNames.missile)
    }
    
    func playLaserSound() {
        playSoundEffect(named: SoundNames.laser)
    }
    
    func playExplosionSound() {
        playSoundEffect(named: SoundNames.explosion)
    }
    
    func playHitSound() {
        playSoundEffect(named: SoundNames.hit)
    }
    
    func playPowerUpSound() {
        playSoundEffect(named: SoundNames.powerUp)
    }
    
    func playAlertSound() {
        playSoundEffect(named: SoundNames.alert)
    }
    
    // MARK: - Settings
    func setMusicEnabled(_ enabled: Bool) {
        isMusicEnabled = enabled
        if enabled {
            resumeBackgroundMusic()
        } else {
            pauseBackgroundMusic()
        }
    }
    
    func setSoundEnabled(_ enabled: Bool) {
        isSoundEnabled = enabled
    }
    
    func setMusicVolume(_ volume: Float) {
        musicVolume = max(0, min(1, volume))
        backgroundMusicPlayer?.volume = musicVolume
    }
    
    func setSoundVolume(_ volume: Float) {
        soundVolume = max(0, min(1, volume))
    }
}
