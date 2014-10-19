//
//  AVFoundationCameraViewController.swift
//  PhotoFilter
//
//  Created by Shiquan Fu on 10/16/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import QuartzCore

protocol AVFoundationCameraDelegate : class {
    func didTapOnPicture(image : UIImage)
}


class AVFoundationCameraViewController: UIViewController {
    
    @IBOutlet weak var capturePreviewImageView: UIImageView!
    
    var stillImageOutput = AVCaptureStillImageOutput()
    
    weak var delegate: AVFoundationCameraDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add a tap guesture on the imageView picture
        var tapOnCaptured = UITapGestureRecognizer(target: self, action: "tapOnImage:")
        self.capturePreviewImageView.addGestureRecognizer(tapOnCaptured)
        
        
        var captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRectMake(0, 64, self.view.frame.size.width, CGFloat(self.view.frame.size.height * 0.6))
        self.view.layer.addSublayer(previewLayer)
        
        var device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as AVCaptureDeviceInput!
        if input == nil {
            println("bad!")
        }
        captureSession.addInput(input)
        var outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        self.stillImageOutput.outputSettings = outputSettings
        captureSession.addOutput(self.stillImageOutput)
        captureSession.startRunning()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // take the UIGestureREcognizer so we can get the information of tap action
    func tapOnImage (tap: UIGestureRecognizer) {
        
        //println("taped on captured picture")
        if self.capturePreviewImageView.image != nil {
            println("taped on captured picture")
            var image = self.capturePreviewImageView.image
            self.delegate?.didTapOnPicture(image!)
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    
    
    @IBAction func capturePressed(sender: AnyObject) {
        
        var videoConnection : AVCaptureConnection?
        for connection in self.stillImageOutput.connections {
            if let cameraConnection = connection as? AVCaptureConnection {
                for port in cameraConnection.inputPorts {
                    if let videoPort = port as? AVCaptureInputPort {
                        if videoPort.mediaType == AVMediaTypeVideo {
                            videoConnection = cameraConnection
                            break;
                        }
                    }
                }
            }
            if videoConnection != nil {
                break;
            }
        }
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(buffer : CMSampleBuffer!, error : NSError!) -> Void in
            var data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            var image = UIImage(data: data)
            self.capturePreviewImageView.image = image
            println(image.size)
        })
        
        
    }
    
}
