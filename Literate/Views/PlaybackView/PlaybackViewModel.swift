//
//  PlaybackControlsViewModel.swift
//  Literate
//
//  Created by Nathan Teuber on 9/14/22.
//

import Foundation
import AVFAudio
import UIKit

class PlaybackViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var synthesizer: AVSpeechSynthesizer
    @Published var voice = AVSpeechSynthesisVoice(language: "en-US")
    @Published var utteredText: NSMutableAttributedString
    @Published var isPBReady: Bool
    @Published var lineStart: Int
    @Published var lineEnd: Int
    
    var text: String = ""
    var viewText = NSMutableAttributedString(string: "")
    var indexOfLNs: [NSRange] = []
    var curLn: Int = 0
    
    override init() {
        self.synthesizer = AVSpeechSynthesizer()
        self.utteredText = NSMutableAttributedString(string: "")
        self.lineStart = -1
        self.lineEnd = -1
        self.isPBReady = false
        
    }
    
    func pbSetUp(textList: [String]) {
        self.text = textList.joined(separator: " ")
        let txt = text.split(separator: ".")
        var i = 0
        var j = 0
        for str in txt {
            j = str.count + 1
            let rng = NSRange.init(location: i, length: j)
            indexOfLNs.append(rng)
            i += j
            
        }
        loadQueue()
        self.isPBReady = true
    }
    
    
    func playAudio(){
        if(synthesizer.isPaused == true){
            synthesizer.continueSpeaking()
        }
    }
    
    func pauseAudio(){
        if(synthesizer.isPaused == false) {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    func loadQueue(){
        viewText = NSMutableAttributedString(string: text)
        self.lineStart = 0;
        synthesizeText(line: text)
    }
    
    func synthesizeText(line: String) {
        let utterance = AVSpeechUtterance(string: line)
        let voice =  AVSpeechSynthesisVoice(language: "en-US")
        
        utterance.rate = 0.45
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        utterance.voice = voice
        synthesizer.delegate = self
        
        synthesizer.speak(utterance)
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        var curRange = indexOfLNs[curLn]
        if(curRange.upperBound < characterRange.lowerBound) {
            viewText.removeAttribute(.backgroundColor, range: curRange)
            curLn += 1
            curRange = indexOfLNs[curLn]
        }
        let strLen = utterance.speechString.count
        let wrdHiColor = UIColor.init(red: 0.0, green: (107/255), blue: (234/255), alpha: 0.8)
        let lnHiColor = UIColor.init(red: 0.0, green: (115/255), blue: (205/255), alpha: 0.4)
        //let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)

        
        let lnRng = NSRange.init(location: self.lineStart, length: strLen)
        
        viewText.addAttribute(.backgroundColor, value: lnHiColor, range: curRange)
        viewText.addAttribute(.backgroundColor, value: wrdHiColor, range: characterRange)
        
        
        //mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange.init(location: 0, length: strLen))
        //mutableAttributedString.addAttribute(.backgroundColor, value: lnHiColor, range: NSRange.init(location: 0, length: strLen))
        //mutableAttributedString.addAttribute(.backgroundColor, value: wrdHiColor, range: characterRange)
        
        //let attributedText = mutableAttributedString
        self.utteredText = viewText
        
        
        //print(utterance.speechString)
        //print(characterRange)
       
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish: AVSpeechUtterance) {
        print("finished")
        utteredText.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: lineEnd))
    }
    
    
    
    
}

