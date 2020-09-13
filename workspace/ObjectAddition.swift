//
//  ObjectAddition.swift
//  workspace
//
//  Created by Surya Chappidi on 30/04/20.
//  Copyright © 2020 Surya Chappidi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

var player: AVAudioPlayer?
extension ViewController{
    
    fileprivate func getModel(named name: String) -> SCNNode? {
         var scale: CGFloat
         let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
               guard let model = scene?.rootNode.childNode(withName: "boy", recursively: false) else {return nil}
               model.name = name
        switch name {
            case "dance":         scale = 0.0025
            case "minion":        scale = 0.0004
            case "girl":          scale = 0.0001
            default:                scale = 1
        }
        model.scale = SCNVector3(scale, scale, scale)
        return model
    }
    
    @IBAction func addObjectButtonTapped(_ sender: Any) {
        print("Add button")
           
        guard focusSquare != nil else {return}
        
        let modelName = "minion"
        
         guard let model = getModel(named: modelName) else {
                   print("Unable to load \(modelName) from file")
                   return
               }
               
               let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
               guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else {return}
               model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
               
               sceneView.scene.rootNode.addChildNode(model)
               print("\(modelName) added successfully")
               
               modelsInTheScene.append(model)
        print("Currently have \(modelsInTheScene.count) model(s) in the scene")
        if modelsInTheScene.count == 1{
            playSound(song: "minions_banana_remix")
        }
    }
    
    @IBAction func resetButton(_ sender: Any) {
        print("reset button")
        
        modelsInTheScene.removeAll()
        
        guard focusSquare != nil else {return}
        
        let modelName = "dance"
        guard let model = getModel(named: modelName) else {
            print("Unable to load \(modelName) from file")
            return
        }
        
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent)
        guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else {return}
        model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        sceneView.scene.rootNode.addChildNode(model)
        print("\(modelName) added successfully")
        
        modelsInTheScene.append(model)
        
        print("\(modelName) added successfully")
        
        print("Currently have \(modelsInTheScene.count) model(s) in the scene")
        if modelsInTheScene.count == 1{
            playSound(song: "dance")
        }
    }
    
    func playSound(song: String) {
           guard let url = Bundle.main.url(forResource: song, withExtension: "mp3") else { return }

           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
               try AVAudioSession.sharedInstance().setActive(true)

               /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

               /* iOS 10 and earlier require the following line:
               player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

               guard let player = player else { return }

               player.play()
               player.numberOfLoops = 3

           } catch let error {
               print(error.localizedDescription)
           }
       }
    
}
