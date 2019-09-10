//
//  AppleCustomAnnotation.swift
//  CustomMapAnnotationViewClusteringFix
//
//  Created by 123456 on 8/28/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SDWebImage

class AppleCustomAnnotationView: MKAnnotationView {
    
    private let boxInset = CGFloat(10)
    private let interItemSpacing = CGFloat(10)
    private let maxContentWidth = CGFloat(90)
    private let contentInsets = UIEdgeInsets(top: 10, left: 30, bottom: 20, right: 20)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = interItemSpacing
        
        return stackView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()
    
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
//        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        // Anchor the top and leading edge of the stack view to let it grow to the content size.
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentInsets.left).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top).isActive = true
        
        // Limit how much the content is allowed to grow.
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: maxContentWidth).isActive = true
        label.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        /*
         If using the same annotation view and reuse identifier for multiple annotations, iOS will reuse this view by calling `prepareForReuse()`
         so the view can be put into a known default state, and `prepareForDisplay()` right before the annotation view is displayed. This method is
         the view's oppurtunity to update itself to display content for the new annotation.
         */
        if let annotation = annotation as? ImageAnnotation {
            label.text = annotation.title
            let placeHolder = #imageLiteral(resourceName: "DSC00042")
            self.imageView.sd_setImage(with: annotation.photoURL, placeholderImage: placeHolder, options: SDWebImageOptions.refreshCached, completed: {(image,error,imageCacheType,storageReference) in
                    if let error = error{
                        print("Uh-Oh an error has occured: \(error.localizedDescription)" )
                    }
                guard let image = image else{
                    return
                }
                if let heightConstraint = self.imageHeightConstraint {
                    self.imageView.removeConstraint(heightConstraint)
                }
                
                let ratio = image.size.height / image.size.width
                self.imageHeightConstraint = self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor, multiplier: ratio, constant: 0)
                self.imageHeightConstraint?.isActive = true
                })
        }
        
        // Since the image and text sizes may have changed, require the system do a layout pass to update the size of the subviews.
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // The stack view will not have a size until a `layoutSubviews()` pass is completed. As this view's overall size is the size
        // of the stack view plus a border area, the layout system needs to know that this layout pass has invalidated this view's
        // `intrinsicContentSize`.
        invalidateIntrinsicContentSize()
        
        // The annotation view's center is at the annotation's coordinate. For this annotation view, offset the center so that the
        // drawn arrow point is the annotation's coordinate.
        let contentSize = intrinsicContentSize
        centerOffset = CGPoint(x: 0, y: -contentSize.height/2)
        
        // Now that the view has a new size, the border needs to be redrawn at the new size.
        setNeedsDisplay()
    }
    
    override var intrinsicContentSize: CGSize {
        var size = stackView.bounds.size
        size.width += contentInsets.left + contentInsets.right
        size.height += contentInsets.top + contentInsets.bottom + 30
        return size
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Used to draw the rounded background box and pointer.
        UIColor.darkGray.setFill()
        
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
        
        // Draw the pointed shape.
//        let pointShape = UIBezierPath(ovalIn: CGRect(x: rect.width/2, y: rect.height - 10, width: 10, height: 10))
//        pointShape.move(to: CGPoint(x: 14, y: 0))
//        pointShape.addLine(to: CGPoint.zero)
//        pointShape.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
//        pointShape.fill()
        
        // Draw the rounded box.
        let box = CGRect(x: boxInset, y: 0, width: rect.size.width - boxInset, height: rect.size.height - 30)
        let roundedRect = UIBezierPath(roundedRect: box, cornerRadius: 5)
        roundedRect.lineWidth = 2
        roundedRect.fill()
        
        
        UIColor.purple.setFill()
        let circleDot = UIBezierPath(ovalIn: CGRect(x: box.midX - 7.5, y: rect.size.height - 15, width: 15, height: 15))
        circleDot.lineWidth = 2
        circleDot.fill()
       
    }
}
