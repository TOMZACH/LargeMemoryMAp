//
//  AppleClusterAnnotationView.swift
//  CustomMapAnnotationViewClusteringFix
//
//  Created by 123456 on 8/28/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import MapKit

class AppleClusterAnnotationView: MKAnnotationView {
    
    weak var customCallOutView: UIView?//ListClusterTagsView?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultLow
        //collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
        self.canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            customCallOutView?.removeFromSuperview()
            if let cluster = newValue as? MKClusterAnnotation {
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
                let count = cluster.memberAnnotations.count
                let uniCount = cluster.memberAnnotations.count
                image = renderer.image { _ in
                    // Fill full circle with tricycle color
                    UIColor(red: 52/255, green: 131/255, blue: 223/255, alpha: 0.22).setFill()
                    UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
                    
                    // Fill pie with unicycle color
                    UIColor(red: 52/255, green: 131/255, blue: 223/255, alpha: 0.22).setFill()
                    let piePath = UIBezierPath()
                    piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                                   startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(uniCount)) / CGFloat(count),
                                   clockwise: true)
                    piePath.addLine(to: CGPoint(x: 20, y: 20))
                    piePath.close()
                    piePath.fill()
                    
                    // Fill inner circle with white color
                    UIColor.white.setFill()
                    UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
                    
                    // Finally draw count text vertically and horizontally centered
                    let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                                       NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
                    let text = "\(count)"
                    let size = text.size(withAttributes: attributes)
                    let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                    text.draw(in: rect, withAttributes: attributes)
                    
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("cluster selected")
        if selected { // 2
            self.customCallOutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                print("add subview called")
                self.customCallOutView = newCustomCalloutView
                self.bringSubviewToFront(newCustomCalloutView)
                // animate presentation
                if animated {
                    self.customCallOutView!.alpha = 0.0
                    UIView.animate(withDuration: 1.0, animations: {
                        self.customCallOutView!.alpha = 1.0
                    })
                }
            }
        } else { // 3
            if customCallOutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: 1.0, animations: {
                        self.customCallOutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCallOutView?.removeFromSuperview()
                    })
                } else { self.customCallOutView?.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadPersonDetailMapView() -> UIView? { // 4
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 280))
        return view
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCallOutView?.removeFromSuperview()
    }
    
}
