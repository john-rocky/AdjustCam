//
//  AVSessionSetting.swift
//  AdjustCam
//
//  Created by 間嶋大輔 on 2020/08/19.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

extension ViewController {
    func setupCaptureSession(){
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let videoInput = try! AVCaptureDeviceInput.init(device: videoDevice!)
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480 // Model image size is smaller.
        
        captureSession.addInput(videoInput)
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        captureSession.addOutput(videoDataOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer!)
        captureSession.commitConfiguration()
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.videoOrientation = .portrait
        // Always process the frames
        captureConnection?.isEnabled = true
        captureSession.startRunning()
    }
}
