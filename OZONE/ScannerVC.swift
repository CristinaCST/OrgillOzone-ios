//
//  scanner.swift
//  WEATCB
//
//  Created by Diego Cando on 3/25/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//
import AVFoundation
import UIKit

protocol ScannerReturnProtocol {
    func ReturnValue(value: String)
    func ShowCameraPermissionPopUp()
    func onCameraPermissionAllow()
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var scannerImage: UIImageView!
    
    var scannerReturns: ScannerReturnProtocol?
    var scanAreaFrame: CGRect!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = doneButton
        
        checkCameraPermission()
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupCaptureSession()
                        self.scannerReturns?.onCameraPermissionAllow()
                    } else {
                        self.scannerReturns?.ShowCameraPermissionPopUp()
                    }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.scannerReturns?.ShowCameraPermissionPopUp()
            }
        @unknown default:
            fatalError("Unknown camera authorization status.")
        }
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showSetupError()
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showSetupError()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code93, .code39, .code128, .code39Mod43, .upce, .ean13, .ean8, .pdf417]
        } else {
            showSetupError()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // Add scanner overlay
        addScannerOverlay()
        
        // Define scan area frame
        let scanAreaWidth = view.frame.width * 0.8
        let scanAreaHeight: CGFloat = 2.0
        let scanAreaX = view.frame.width / 2 - scanAreaWidth / 2
        let scanAreaY = view.frame.height / 2 - scanAreaHeight / 2
        scanAreaFrame = CGRect(x: scanAreaX, y: scanAreaY, width: scanAreaWidth, height: scanAreaHeight)
        
        captureSession.startRunning()
    }

    func showSetupError() {
        let ac = UIAlertController(title: "Setup Error", message: "There was an issue setting up the scanner. Please try again or use a different device.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }

            // Convert the barcode's bounds to the view's coordinate system
            let transformedMetadataObject = previewLayer.transformedMetadataObject(for: readableObject)
            
            // Check if the barcode's bounds intersect with the scan area
            if let barcodeBounds = transformedMetadataObject?.bounds {
                if scanAreaFrame.intersects(barcodeBounds) {
                    print("Barcode is aligned with the red line.")
                    captureSession.stopRunning()
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    found(code: stringValue)
                    dismiss(animated: true)
                } else {
                    print("Barcode is not aligned with the red line.")
                }
            }
        }
    }

    func found(code: String) {
        scannerReturns?.ReturnValue(value: code)
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private func addScannerOverlay() {
        let imageLayer = CALayer()
        let layerHeight = view.frame.height * 0.4
        let layerWidth = view.frame.width * 0.6
        let layerX = view.frame.width / 2 - layerWidth / 2
        let layerY = view.frame.height / 2 - layerHeight / 2
        imageLayer.frame = CGRect(x: layerX, y: layerY, width: layerWidth, height: layerHeight)
        imageLayer.contents = UIImage(named: "ipad")?.cgImage
        imageLayer.contentsGravity = .resizeAspectFill
        view.layer.addSublayer(imageLayer)
        
        let redline = CALayer()
        let redlineWidth = view.frame.width * 0.8
        let redlineX = view.frame.width / 2 - redlineWidth / 2
        let redlineY = view.frame.height / 2
        redline.frame = CGRect(x: redlineX, y: redlineY, width: redlineWidth, height: 2)
        redline.borderColor = UIColor.systemRed.cgColor
        redline.borderWidth = 2.0
        view.layer.addSublayer(redline)
    }
}
