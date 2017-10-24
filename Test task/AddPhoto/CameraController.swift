//
//  CameraController.swift
//  Test task
//
//  Created by leanid niadzelin on 08.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import AVFoundation
import UIKit
import CoreLocation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var currentLocation: CLLocationCoordinate2D?
    weak var homeController: HomeController?
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhotoButton), for: .touchUpInside)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupButtons()        
    }
    
    
    @objc func handleCapturePhotoButton() {
        
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.__availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
        
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let previewImage = UIImage(data: imageData) else { return }
        
        let containerView = PreviewPhotoContainerView()
        containerView.imageView.image = previewImage
        containerView.homeController = homeController
        containerView.currentLocation = currentLocation
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc fileprivate func handleBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupButtons() {
        view.addSubview(capturePhotoButton)
        view.addSubview(backButton)
        
        capturePhotoButton.anchor(top: nil , left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    let output = AVCapturePhotoOutput()
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Failed setup camera:", err)
        }
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}

