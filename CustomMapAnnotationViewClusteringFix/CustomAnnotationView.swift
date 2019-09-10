//
//  CustomAnnotationView.swift
//  CustomMapAnnotationViewClusteringFix
//
//  Created by 123456 on 8/28/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    static let reuseIdentifier:String = "CustomAnnotationViewReuseIdentifier"

    override var alignmentRectInsets: UIEdgeInsets{
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    var testView:UIView = {
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        testView.backgroundColor = UIColor.black
        testView.layer.cornerRadius = 27/5
        testView.layer.masksToBounds = true
        testView.translatesAutoresizingMaskIntoConstraints = false
        return testView
    }()
    
    var testLabel:UILabel = {
        let testLabel = UILabel()
        //        testLabel.text = annotation?.title ?? "no title yet"
        testLabel.textAlignment = .center
        testLabel.backgroundColor = .green
        testLabel.textColor = UIColor.white
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testLabel.layer.cornerRadius = 27/5
        return testLabel
    }()
    
    var testImageView:UIImageView = {
        let testImageView = UIImageView()
        testImageView.translatesAutoresizingMaskIntoConstraints = false
        testImageView.layer.cornerRadius = 27/5
        testImageView.layer.masksToBounds = true
        testImageView.backgroundColor = UIColor.red
        testImageView.contentMode = .scaleAspectFill
        return testImageView
    }()
    
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame.size = CGSize.zero
        self.displayPriority = .defaultLow

        backgroundColor = UIColor.clear
//        translatesAutoresizingMaskIntoConstraints = false
        
       
        
        self.layer.cornerRadius = 27/5

        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        testView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var annotation: MKAnnotation?{
        willSet{
            if annotation == nil{
                return
            }
            print("annotation is not nil: \(annotation?.title)")
            self.frame.size = CGSize(width: 150, height: 150)
            self.addSubview(testView)
            
            testView.addSubview(testImageView)
            
            testView.addSubview(testLabel)
            NSLayoutConstraint.activate([
                testView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                testView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                testView.heightAnchor.constraint(equalToConstant: self.bounds.width - 10),
                testView.widthAnchor.constraint(equalToConstant: self.bounds.height - 10),
                
                testImageView.topAnchor.constraint(equalTo: testView.topAnchor, constant: 0),
                testImageView.leadingAnchor.constraint(equalTo: testView.leadingAnchor, constant: 0),
                testImageView.trailingAnchor.constraint(equalTo: testView.trailingAnchor, constant: 0),
                testImageView.heightAnchor.constraint(equalToConstant: self.bounds.height - 40),
                
                testLabel.bottomAnchor.constraint(equalTo: testView.bottomAnchor, constant: 0),
                testLabel.leadingAnchor.constraint(equalTo: testView.leadingAnchor, constant: 0),
                testLabel.trailingAnchor.constraint(equalTo: testView.trailingAnchor, constant: 0),
                testLabel.heightAnchor.constraint(equalToConstant: 30)
                ])
             makeMapDot()
        }
    }
    
    @objc func viewTapped(){
        print("view tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        testImageView.image = nil
        testLabel.text = nil
        testLabel.isHidden = true
        testImageView.isHidden = true
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let annotation = annotation as? ImageAnnotation {
            self.frame.size = CGSize(width: 150, height: 150)
            testLabel.text = annotation.title

        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
        
        let contentSize = intrinsicContentSize
        centerOffset = CGPoint(x: 0, y: -contentSize.height/2 - 10) 
        setNeedsDisplay()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func makeMapDot(){
        print("Ive been called")
//        let rect =  CGRect(x: 0.0, y:0.0, width: 150, height: 150)
//        let path2 = UIBezierPath(ovalIn: CGRect(x: rect.width/2, y: rect.height - 10, width: 10, height: 10))
//
//        let shapeLayer2 = CAShapeLayer()
//        shapeLayer2.path = path2.cgPath
//        shapeLayer2.fillColor = UIColor.purple.cgColor
//        shapeLayer2.strokeColor = UIColor.white.cgColor
//        shapeLayer2.lineWidth = 1
//
//        layer.addSublayer(shapeLayer2)
//        shapeLayer2.position = CGPoint(x: -10, y: 15)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path2 = UIBezierPath(ovalIn: CGRect(x: rect.width/2, y: rect.height - 10, width: 10, height: 10))
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path2.cgPath
        shapeLayer2.fillColor = UIColor.purple.cgColor
        shapeLayer2.strokeColor = UIColor.white.cgColor
        shapeLayer2.lineWidth = 1
        
        layer.addSublayer(shapeLayer2)
        shapeLayer2.position = CGPoint(x: -10, y: 15)
    }
}


