//
//  Views.swift
//  AdjustCam
//
//  Created by 間嶋大輔 on 2020/08/19.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func setupViews(){
        previewView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width * videoAspectRatio)
        view.addSubview(previewView)
        
        // menuView
        menuView.frame = CGRect(x: 0, y: previewView.frame.maxY, width: view.bounds.width, height: view.bounds.height - previewView.frame.height)
        view.addSubview(menuView)
        menuView.backgroundColor = .black
        menuView.layer.opacity = 0.5
        
        
        // captureButton
        let buttonWidth = menuView.bounds.width * 0.25
        let buttonHeight = menuView.bounds.height * 0.5
        
        captureButton.frame = CGRect(x: menuView.center.x - (buttonWidth * 0.5), y: 0, width: buttonWidth, height: buttonHeight)
        menuView.addSubview(captureButton)
        captureButton.text = "capture"
        captureButton.textColor = .white
        captureButton.textAlignment = .center
        captureButton.isUserInteractionEnabled = true
        let tapCaptureButton = UITapGestureRecognizer(target: self, action: #selector(capture))
        captureButton.addGestureRecognizer(tapCaptureButton)
        
        // captureTimeButton
        captureTimeButton.frame = CGRect(x: 0, y: captureButton.frame.maxY, width: menuView.bounds.width, height: buttonHeight)
        menuView.addSubview(captureTimeButton)
        captureTimeButton.addTarget(self, action: #selector(sliderDidChangeValue(_:)), for: .valueChanged)
        captureTimeButton.minimumValue = 0.05
        captureTimeButton.maximumValue = 5.0
        captureTimeButton.value = 1
        
        // captureTimeLabel
        captureTimeLabel.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        menuView.addSubview(captureTimeLabel)
        captureTimeLabel.text = "\(captureTime) s"
        captureTimeLabel.textAlignment = .center
        captureTimeLabel.textColor = .white
        
        
        // forcus
        parentOfForcusView.frame = previewView.frame
        view.addSubview(parentOfForcusView)
        view.bringSubviewToFront(parentOfForcusView)
        let forcusViewWidth = parentOfForcusView.bounds.width * 0.5
        let forcusViewHeight = parentOfForcusView.bounds.height * 0.5

        forcusView.frame = CGRect(x: parentOfForcusView.center.x - forcusViewWidth * 0.5, y: parentOfForcusView.center.y - forcusViewHeight * 0.5, width: forcusViewWidth, height: forcusViewHeight)
        aspectX = forcusView.frame.minX / parentOfForcusView.bounds.width
        aspectY = 1 - forcusView.frame.maxY / parentOfForcusView.bounds.height

        parentOfForcusView.addSubview(forcusView)
        forcusView.layer.borderColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)
        forcusView.layer.borderWidth = 1
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panPiece(_:)))
        forcusView.addGestureRecognizer(pan)
        forcusView.isUserInteractionEnabled = true
        
        sizeView.frame = CGRect(x: captureButton.frame.maxX, y: 0, width: buttonWidth, height: buttonHeight)
        menuView.addSubview(sizeView)
        sizeView.addSubview(plusXView)
        sizeView.addSubview(minusXView)
        sizeView.addSubview(plusYView)
        sizeView.addSubview(minusYView)
        plusXView.frame = CGRect(x: 0, y: 0, width: sizeView.bounds.width * 0.5, height: sizeView.bounds.height * 0.5)
        minusXView.frame = CGRect(x: 0, y: sizeView.bounds.height * 0.5, width: sizeView.bounds.width * 0.5, height: sizeView.bounds.height * 0.5)
        plusYView.frame = CGRect(x: sizeView.bounds.width * 0.5, y: 0, width: sizeView.bounds.width * 0.5, height: sizeView.bounds.height * 0.5)
        minusYView.frame = CGRect(x: sizeView.bounds.width * 0.5, y: sizeView.bounds.height * 0.5, width: sizeView.bounds.width * 0.5, height: sizeView.bounds.height * 0.5)
        plusXView.text = "+x"
        minusXView.text = "-x"
        plusYView.text = "+y"
        minusYView.text = "-y"
        plusXView.textColor = .white
        minusXView.textColor = .white
        plusYView.textColor = .white
        minusYView.textColor = .white
        plusXView.textAlignment = .center
        minusXView.textAlignment = .center
        plusYView.textAlignment = .center
        minusYView.textAlignment = .center
        let plusXTap = UILongPressGestureRecognizer(target: self, action: #selector(plusX))
        let minusXTap = UILongPressGestureRecognizer(target: self, action: #selector(minusX))
        let plusYTap = UILongPressGestureRecognizer(target: self, action: #selector(plusY))
        let minusYTap = UILongPressGestureRecognizer(target: self, action: #selector(minusY))
        plusXTap.minimumPressDuration = 0.01
        minusXTap.minimumPressDuration = 0.01
        plusYTap.minimumPressDuration = 0.01
        minusYTap.minimumPressDuration = 0.01
        
        plusXView.addGestureRecognizer(plusXTap)
        minusXView.addGestureRecognizer(minusXTap)
        plusYView.addGestureRecognizer(plusYTap)
        minusYView.addGestureRecognizer(minusYTap)
        plusXView.isUserInteractionEnabled = true
        minusXView.isUserInteractionEnabled = true
        plusYView.isUserInteractionEnabled = true
        minusYView.isUserInteractionEnabled = true
        
        parentOfForcusView.isUserInteractionEnabled = true
    }
    
    @objc func sliderDidChangeValue(_ sender: UISlider) {
        let value = sender.value
        print(value)
        captureTime = TimeInterval(value)
    }
    
    @objc func plusX(_ gestureRecognizer : UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width + 1, height: self.forcusView.frame.height)
            longTapTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width + 1, height: self.forcusView.frame.height)
            })
        case .ended:
            longTapTimer?.invalidate()
            aspectWidth = forcusView.frame.width / parentOfForcusView.bounds.width
            aspectHeight = forcusView.frame.height / parentOfForcusView.bounds.height
        default:
            break
        }
        
    }
    
    @objc func minusX(_ gestureRecognizer : UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width + 1, height: self.forcusView.frame.height)
            longTapTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width - 1, height: self.forcusView.frame.height)
            })
        case .ended:
            longTapTimer?.invalidate()
            aspectWidth = forcusView.frame.width / parentOfForcusView.bounds.width
            aspectHeight = forcusView.frame.height / parentOfForcusView.bounds.height
        default:
            break
        }
    }
    
    @objc func plusY(_ gestureRecognizer : UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width, height: self.forcusView.frame.height + 1)
            longTapTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width, height: self.forcusView.frame.height + 1)
            })
        case .ended:
            longTapTimer?.invalidate()
            aspectWidth = forcusView.frame.width / parentOfForcusView.bounds.width
            aspectHeight = forcusView.frame.height / parentOfForcusView.bounds.height
        default:
            break
        }
    }
    
    @objc func minusY(_ gestureRecognizer : UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
             self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width, height: self.forcusView.frame.height - 1)
            longTapTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                self.forcusView.frame = CGRect(x: self.forcusView.frame.minX, y: self.forcusView.frame.minY, width: self.forcusView.frame.width, height: self.forcusView.frame.height - 1)
            })
        case .ended:
            longTapTimer?.invalidate()
            aspectWidth = forcusView.frame.width / parentOfForcusView.bounds.width
            aspectHeight = forcusView.frame.height / parentOfForcusView.bounds.height
        default:
            break
        }
    }
    
    @objc func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
       guard gestureRecognizer.view != nil else {return}
       let piece = gestureRecognizer.view!
       // Get the changes in the X and Y directions relative to
       // the superview's coordinate space.
       let translation = gestureRecognizer.translation(in: piece.superview)
       if gestureRecognizer.state == .began {
          // Save the view's original position.
          self.initialCenter = piece.center
       }
          // Update the position for the .began, .changed, and .ended states
       if gestureRecognizer.state != .cancelled {
          // Add the X and Y translation to the view's original position.
          let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
          piece.center = newCenter
        aspectX = forcusView.frame.minX / parentOfForcusView.bounds.width
        aspectY = 1 - forcusView.frame.maxY / parentOfForcusView.bounds.height
        print(aspectX,aspectY)
       }
       else {
          // On cancellation, return the piece to its original location.
          piece.center = initialCenter
       }
    }
}


