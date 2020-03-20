//
//  RecordingScreenViewController.swift
//  Pitch-Perfect
//
//  Created by David Zeeman on 2/18/20.
//  Copyright © 2020 David Zeeman. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingScreenViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordAudio: AVAudioRecorder!

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    //MARK: Recording Button Pressed
    @IBAction func recordButtonPressed(_ sender: Any) {
        recordLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! recordAudio = AVAudioRecorder(url: filePath!, settings: [:])
        recordAudio.delegate = self
        recordAudio.isMeteringEnabled = true
        recordAudio.prepareToRecord()
        recordAudio.record()
    }
    
    //MARK: Recording Button Stopped
    @IBAction func stopRecording(_ sender: Any) {
        recordLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        recordAudio.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: recordAudio.url)
        } else {
            print("recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}
    

