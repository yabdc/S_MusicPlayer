//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Richard on 2015/12/17.
//  Copyright © 2015年 Richard. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , AVAudioPlayerDelegate{
    
    @IBOutlet weak var m_currentTimeLabel: UILabel!
    @IBOutlet weak var m_totalTimeLabel: UILabel!
    @IBOutlet weak var m_volumnSlider: UISlider!
    @IBOutlet weak var m_musicProgressSlider: UISlider!
    
    
    var audioPlayer : AVAudioPlayer!
    //音樂資料
    let myAssetSound =  NSDataAsset(name: "Demo")
    
    //    let musicURL:NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Demo.mda", ofType: nil)!)
    
    //MARK: viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            //        audioPlayer = try AVAudioPlayer(contentsOfURL: musicURL)
            audioPlayer = try AVAudioPlayer(data: myAssetSound!.data)
        }catch{
            print("Dim background error \(error)")
        }
        audioPlayer.delegate = self
        
        audioPlayer.volume = m_volumnSlider.value
        
        m_totalTimeLabel.text = NSTimeIntervalToString(audioPlayer.duration)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: musicButton
    @IBAction func playorpause(sender: UIButton) {
        if(sender.selected){
            audioPlayer.pause()
        }else{
            audioPlayer.play()
            
            
        }
        sender.selected = !sender.selected;
    }
    
    @IBAction func adjustVolume(sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    @IBAction func adjustMusicProgress(sender: UISlider) {
        changeProgress()
    }
    
    func progress() -> Float{
        let totalTime = NSNumber(double:audioPlayer.duration)
        let currentTime = NSNumber(double:audioPlayer.currentTime)
        let progress:Float = currentTime.floatValue / totalTime.floatValue
        return progress
    }
    
    func changeProgress(){
        audioPlayer.stop()
        audioPlayer.currentTime = Double(m_musicProgressSlider.value) * audioPlayer.duration
        audioPlayer.play()
    }
    
    func updateProgress(){
        m_musicProgressSlider.value = progress()
        m_currentTimeLabel.text = NSTimeIntervalToString(audioPlayer.currentTime)
    }
    
    func NSTimeIntervalToString(time: NSTimeInterval) ->String{
        let str = String(format: "%02li:%02li:%02li",
            lround(floor(time / 3600)) % 100,
            lround(floor(time / 60)) % 60,
            lround(floor(time)) % 60)
        return str
    }
    
    //MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
    }
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        print("audioPlayerBeginInterruption")
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer, withOptions flags: Int) {
        print("audioPlayerEndInterruption")
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("audioPlayerDecodeErrorDidOccur")
    }
    
}

