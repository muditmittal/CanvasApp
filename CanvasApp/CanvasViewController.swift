//
//  CanvasViewController.swift
//  CanvasApp
//
//  Created by Mudit Mittal on 2/16/16.
//  Copyright © 2016 Mudit Mittal. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    @IBOutlet weak var trayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 160
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            trayOriginalCenter = trayView.center
        
        } else if sender.state == UIGestureRecognizerState.Changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            let velocity = sender.velocityInView(view)
            if velocity.y > 0 {
                UIView.animateWithDuration(0.4, animations: {
                    self.trayView.center = self.trayDown
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat (180 * M_PI / 180))
                    }, completion: { (Bool) -> Void in
                })
                
            } else if velocity.y < 0 {
                UIView.animateWithDuration(0.4, animations: {
                    self.trayView.center = self.trayUp
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat (360 * M_PI / 180))
                    }, completion: { (Bool) -> Void in
                })
                
            }
            
            
        }
    }

    func onCustomPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(view)
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            
        }
    }

    func onCustomPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
        sender.scale = 1
    }
    
    func onCustomRotate(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform = CGAffineTransformRotate(imageView.transform, rotation)
        sender.rotation = 0
    }
    
    func onDoubleTap(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
    
    
    @IBAction func didPanFace(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began{
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.userInteractionEnabled = true
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: "onCustomPinch:")
            let rotateGestureRecognizer = UIRotationGestureRecognizer (target: self, action:"onCustomRotate:")
            let doubleTapRecognizer = UITapGestureRecognizer (target: self, action: "onDoubleTap:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            pinchGestureRecognizer.delegate = self;
            newlyCreatedFace.userInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(doubleTapRecognizer)

            UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(1.5, 1.5)}, completion: nil)
            
            
        }else if sender.state == UIGestureRecognizerState.Changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }else if sender.state == UIGestureRecognizerState.Ended{
            UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: { () -> Void in
                self.newlyCreatedFace.transform = CGAffineTransformMakeScale(3, 3)}, completion: nil)
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
