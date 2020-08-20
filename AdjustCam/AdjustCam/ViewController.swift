//
//  ViewController.swift
//  AdjustCam
//
//  Created by 間嶋大輔 on 2020/08/17.
//  Copyright © 2020 daisuke. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        
        setupCaptureSession()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapview))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapview(){
        
    }
    
    @objc func compsave(){
 
    }
    // Capture properties
    var captureSession = AVCaptureSession()
    var previewView = UIView()
    var previewLayer:AVCaptureVideoPreviewLayer?
    let videoDataOutput = AVCaptureVideoDataOutput()
    var count = 0
    var isGettingBuffer = true
    var captureCount = 0
    
    // Interval properties
    var captureTime:TimeInterval = 1 {
        didSet {
            captureTimeLabel.text = "\(floor(captureTime * 100)/100) s"
        }
    }
    var isCapturering = false
    var timer:Timer?
    var videoAspectRatio:CGFloat = 640/480
    
    // Views properties
    var menuView = UIView()
    var captureTimeButton = UISlider()
    var captureButton = UILabel()
    var captureTimeLabel = UILabel()
    
    // Forcusing properties
    var parentOfForcusView = UIView()
    var forcusView = UIView()
    var sizeView = UIView()
    var plusXView = UILabel()
    var minusXView = UILabel()
    var plusYView = UILabel()
    var minusYView = UILabel()
    var longTapTimer:Timer?
    var initialCenter = CGPoint()  // The initial center point of the view.
    
    var aspectX:CGFloat = 0
    var aspectY:CGFloat = 0

    var aspectWidth:CGFloat = 0.5
    var aspectHeight:CGFloat = 0.5

    let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if isCapturering,isGettingBuffer{
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            
            let ciImage = CIImage(cvImageBuffer: pixelBuffer)
            let originalSize = ciImage.extent
            let cropSize = CGRect(x: originalSize.width * aspectX, y: originalSize.height * aspectY, width: originalSize.width * aspectWidth, height: originalSize.height * aspectHeight)
            print(cropSize)
            let cropped = ciImage.cropped(to: cropSize)
            let image = UIImage(ciImage: cropped)
            let data = image.jpegData(compressionQuality: 1)
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo,
                                            data: data!,
                                            options: nil)
            })
            captureCount += 1
            print(captureCount)
            DispatchQueue.main.async {
                self.captureButton.text = "\(self.captureCount)captured"
            }
            isGettingBuffer = false
        }
    }
    
    private func proccessImage(buffer sampleBuffer:CMSampleBuffer){
    }
    
    @objc func capture(){
        if !isCapturering{
            timer = Timer.scheduledTimer(withTimeInterval: captureTime, repeats: true) { (Timer) in
                self.isGettingBuffer = true
            }
            isCapturering = true
            captureButton.textColor = .red
        } else {
            timer?.invalidate()
            isCapturering = false
            captureButton.textColor = .white
            captureButton.text = "capture"
            captureCount = 0
        }
    }
}

