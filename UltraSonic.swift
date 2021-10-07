//
//  UltraSonic.swift
//
//  Created by aba097 on 2021/10/07.
//

import Foundation
import AVFoundation

class UltraSonic {

    let volume: Double = 1.0
    let hz: Double = 20000.0
    let sampleRate = 44100.0
    
    private let audioEngine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    let session = AVAudioSession.sharedInstance()

    init() {
        
    }

    deinit {
        stopSound()
    }

    private func makeBuffer() -> AVAudioPCMBuffer {
    
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)
        
        guard let buf = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: AVAudioFrameCount(sampleRate)) else{
            fatalError("Error initializing AVAudioPCMBuffer")
        }
        let data = buf.floatChannelData?[0]
        var theta = 0.0
        let plus = 2.0 * .pi * self.hz / self.sampleRate
        let numberFrames = buf.frameCapacity
        buf.frameLength = numberFrames
        
        for frame in 0..<Int(numberFrames) {
            data?[frame] = Float32(sin(theta) * volume)
            
            theta += plus
            if theta > 2.0 * .pi {
                theta -= 2.0 * .pi
            }
        }
    
        return buf
    }

    func startSound() {
        // Audio Sessionを再生モードに変更
        try! session.setCategory(AVAudioSession.Category.playback)
        try! session.setActive(true)

        //再生音作成
        let buffer = makeBuffer()
        //Nodeを追加
        audioEngine.attach(player)
        //Format定義
        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)
        // Nodeを接続（Player -> outputnode）
        audioEngine.connect(player, to: audioEngine.outputNode, format: audioFormat)

        
        // 再生開始
        audioEngine.prepare()
        try! audioEngine.start()
        
        if !player.isPlaying {
            player.play()
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        }
        
        }

        func stopSound() {
            // 再生停止
            if player.isPlaying {
                player.stop()
            }
            if audioEngine.isRunning {
                audioEngine.stop()
                // Audio sessionを停止
                try! session.setActive(false)
            }
        }


}
