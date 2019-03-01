//
//  ViewController.swift
//  mask_layer
//
//  Created by teppei zaima on 2019/03/01.
//  Copyright © 2019 macoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    ///masked layer
    let target = CALayer()
    ///mask layer
    let shapeLayer = CAShapeLayer()
    ///check masked
    var isMaskedNow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createImage()
        createButton()
    }
    
    func createImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        imageView.center = self.view.center
        imageView.image = UIImage(named: "image1")
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
    }
    
    func createButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 250)
        button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        button.backgroundColor = .gray
        button.setTitle("mask", for: .normal)
        self.view.addSubview(button)
    }
    
    @objc func onTapped(){
        if isMaskedNow{return}
        isMaskedNow = true
        appearAnimation(appearRect: CGRect(x: 265, y: 245, width: 100, height: 100), duration: 1.0)
    }
    
    ///appear layer animation
    func appearAnimation(appearRect: CGRect, duration:Double){
        target.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        target.backgroundColor = UIColor.black.cgColor
        shapeLayer.fillRule = .evenOdd
        target.mask = shapeLayer
        self.view.layer.addSublayer(target)
        
        //light animation begin path
        var begin =  appearRect
        begin.size = CGSize(width: 0, height: 0)
        let path =  UIBezierPath(ovalIn: begin)
        path.append(UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)))
        let beginPath = path.cgPath
        //light animation end path
        var end = appearRect
        end.origin = CGPoint(x:end.origin.x - end.size.width/2, y:end.origin.y - end.size.height/2)
        let path2 = UIBezierPath(ovalIn: end)
        path2.append(UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)))
        let endPath = path2.cgPath
        ///expand light animation
        let lightAnimation = CABasicAnimation(keyPath: "path")
        lightAnimation.fromValue = beginPath
        lightAnimation.toValue = endPath
        ///fade in animation
        let backgroundOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        backgroundOpacityAnimation.fromValue = 0
        backgroundOpacityAnimation.toValue = 0.6
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = 0
        animationGroup.animations = [backgroundOpacityAnimation, lightAnimation]
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        shapeLayer.add(animationGroup, forKey: nil)
    }
    
    ///fade out layer
    func fadeOutAnimation(duration: Double) {
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.toValue = 0
        fadeOut.duration = duration
        fadeOut.fillMode = .forwards
        fadeOut.isRemovedOnCompletion = false
        shapeLayer.add(fadeOut, forKey: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let point = touch.location(in: self.view)
        //if point is inside of the circle, fade out mask and make isMaskedNow true
        if isMaskedNow{
            if !(CGRect(x: 265 - 100/2, y: 245 - 100/2, width: 100, height: 100).contains(point)) {
                return
            }
            fadeOutAnimation(duration: 0.3)
            isMaskedNow = false
        }
    }
}

