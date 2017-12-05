//
//  LoadingView.swift
//   
//
//  Created by vlaghane on 12/3/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    var spinner = UIActivityIndicatorView()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawBorder(parentRect : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSpinner(){
        DispatchQueue.main.async {
        self.spinner.startAnimating()
        }
    }
    
    func stopSpinner(){
        DispatchQueue.main.async {
        self.spinner.stopAnimating()
        }
        
    }
    
    func drawBorder(parentRect: CGRect){
        
        let viewWidth = 240
        let viewHeight = 90
        
        var rect        = CGRect(x: 100, y: 100, width: 240, height: 90)
        let parentFrame = parentRect
        let viewX       = (parentFrame.size.width - CGFloat( viewWidth))/2
        let viewY       = (parentFrame.size.height - CGFloat(viewHeight))/2 - 40
        
        rect = CGRect(x: viewX, y: viewY, width: CGFloat( viewWidth), height: CGFloat( viewHeight) )
        
//        if (parentFrame.size.width > parentFrame.size.height){
//            rect = CGRect(x: 150, y: 100, width: 240, height: 90)
//        }else{
//            rect = CGRect(x: 100, y: 150, width: 240, height: 90)
//        }
        
        self.frame = rect
        self.layer.cornerRadius = 7
        self.layer.shadowColor = UIColor.magenta.cgColor
        
        let spinnerW = CGFloat( 20)
        let spinnerH = CGFloat( 20)
        
        let bounds = self.bounds
        let spinnerY = (bounds.height/2) - CGFloat(spinnerH/2)
        let spinnerX = (bounds.width/2) - CGFloat(spinnerW/2)
        
        spinner = UIActivityIndicatorView(frame: CGRect(x: spinnerX, y: spinnerY , width: spinnerW, height: spinnerH))
        spinner.color = UIColor.gray
 
        self.addSubview(spinner)
        self.startSpinner()
        self.backgroundColor =  UIColor.white
        
    }
}
