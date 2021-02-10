//
//  RecordingSoundViewController.swift
//  Pitch Perfect
//
//  Created by Asma  on 12/30/20.
//

import UIKit
import AVFoundation

class RecordingSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    
    //MARK: IBOutlets
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false    }

    //MARK: Audio Recording function
    @IBAction func recordAudio(_ sender: Any) {
        updateUI(enableRecording: false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //MARK: Stop recording function
    @IBAction func stopRecording(_ sender: Any) {
        updateUI(enableRecording: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    //MARK: Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag==true){
            performSegue(withIdentifier:"stopRecording", sender: audioRecorder.url)
        }else{
            print("Recording was not successful")
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="stopRecording"){
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedSoundURL = sender as! URL
            playSoundVC.recordedAudioURL=recordedSoundURL
            
        }
    }
    
    //MARK: Updating UI function
    func updateUI(enableRecording:Bool){
        if enableRecording{
            stopRecordingButton.isEnabled=false
            recordingLabel.text="Tap to record"
            recordButton.isEnabled=true
            
        }else{
            stopRecordingButton.isEnabled=true
            recordingLabel.text="Recording in progress"
            recordButton.isEnabled=false        }
    }
}

