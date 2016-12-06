//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    let defaultImageName: String = "scenery"
    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var originalLabel: UILabel!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterMenu:UIView!
    @IBOutlet weak var filtercollectionView:UICollectionView!
    let filterArray:Array = ["Brighness", "Green", "Purpple", "Yellow"]
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet var sliderMenu: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        //secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // filterMenu layout
        filterMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        filterMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // sliderMenu layout
        sliderMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // hide originalLabel
        self.originalLabel.hidden = true
        
        // init self.filteredImage and load self.imageView.image -> default image
        self.showDefaultImage()
        
        // init by disable compare button
        self.compareButton.enabled = false
        
        // init by disable edit button
        self.editButton.enabled = false
        
        // lognPress
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longTap(_:)))
        longGesture.delegate = self
        self.imageView.addGestureRecognizer(longGesture)
        
        // collectionView delegate
        self.filtercollectionView.dataSource = self;
        self.filtercollectionView.delegate = self;
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Compare
    @IBAction func comparePressed(sender: UIButton) {
        if (sender.selected) {
            self.showFilterImage()
            sender.selected = false
            self.filterButton.enabled = true
        }else{
            self.showDefaultImage()
            sender.selected = true
            self.filterButton.enabled = false
        }
    }
    
    // MARK: Edit Action
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            self.hideSliderMenu()
            self.showFilterMenu()
            sender.selected = false
            self.filterButton.enabled = true
            self.compareButton.enabled = true
        }else{
            self.hideFilterMenu()
            self.showSliderMenu()
            sender.selected = true
            self.filterButton.enabled = false
            self.compareButton.enabled = false
        }
    }
    
    // MARK: ShowFilterMenu
    func showSliderMenu() {
        view.addSubview(sliderMenu)
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(50)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.sliderMenu.alpha = 1.0
        }
        
    }
    
    func hideSliderMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.sliderMenu.removeFromSuperview()
            }
        }
    }


    @IBAction func sliderValueChanged(sender: AnyObject) {
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            // set default image -> imageView.image
            self.showDefaultImage()
            //hideSecondaryMenu()
            hideFilterMenu()
            self.filteredImage = UIImage (named: defaultImageName)
            sender.selected = false
            // disable compare button
            self.compareButton.enabled = false
            // disable edit button
            self.editButton.enabled = false
        } else {
            showFilterMenu()
            //showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        }
    }

    
    // MARK: ShowFilterMenu
    func showFilterMenu() {
        view.addSubview(filterMenu)
        
        let bottomConstraint = filterMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = filterMenu.heightAnchor.constraintEqualToConstant(50)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.filterMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.filterMenu.alpha = 1.0
        }

    }
    
    // MARK: HideFilterMenu
    
    func hideFilterMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.filterMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.filterMenu.removeFromSuperview()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:FilterCollectionViewCell = self.filtercollectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCollectionViewCell
        
        // configure cell
        cell.filterButton.tag = indexPath.row
        //cell.filterButton .setTitle(self.filterArray[indexPath.row], forState: .Normal)
        cell.filterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cell.filterButton .addTarget(self, action: #selector(ViewController.filterButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.filterButton .setBackgroundImage(self.getFilteredImage(indexPath.row), forState: .Normal)
        
        return cell
    }
    
    func filterButtonClicked(sender:UIButton) {
        switch sender.tag {
        case 0:
            // enable comapreButton
            self.compareButton.enabled = true
            // set comparebutton selected = false
            self.compareButton.selected = false
            // originalLabel
            self.originalLabel.hidden = true
            // enable edit button
            self.editButton.enabled = true
            self.imageProcessorWithIndex(0)
            break
        case 1:
            // enable comapreButton
            self.compareButton.enabled = true
            // set comparebutton selected = false
            self.compareButton.selected = false
            // originalLabel
            self.originalLabel.hidden = true
            // enable edit button
            self.editButton.enabled = true
            self.imageProcessorWithIndex(1)
            break
        case 2:
            // enable comapreButton
            self.compareButton.enabled = true
            // set comparebutton selected = false
            self.compareButton.selected = false
            // originalLabel
            self.originalLabel.hidden = true
            // enable edit button
            self.editButton.enabled = true
            self.imageProcessorWithIndex(2)
            break
        case 3:
            // enable comapreButton
            self.compareButton.enabled = true
            // set comparebutton selected = false
            self.compareButton.selected = false
            // originalLabel
            self.originalLabel.hidden = true
            // enable edit button
            self.editButton.enabled = true
            self.imageProcessorWithIndex(3)
            break
        default:
            break
        }
    }
    
    // MARK: Second Menu Buttons Action
    
    @IBAction func brightnessPressed(sender: AnyObject) {
        // enable comapreButton
        self.compareButton.enabled = true
        
        // originalLabel
        self.originalLabel.hidden = true
        
        self.imageProcessorWithIndex(0)
    }
    
    @IBAction func greenFilterPressed(sender: AnyObject) {
        // enable comapreButton
        self.compareButton.enabled = true
        
        // originalLabel
        self.originalLabel.hidden = true
        
        self.imageProcessorWithIndex(1)
    }
    
    @IBAction func purppleFilterPressed(sender: AnyObject) {
        // enable comapreButton
        self.compareButton.enabled = true
        
        // originalLabel
        self.originalLabel.hidden = true
        
        self.imageProcessorWithIndex(2)
    }
    
    @IBAction func yellowFilterPressed(sender: AnyObject) {
        // enable comapreButton
        self.compareButton.enabled = true
        
        // originalLabel
        self.originalLabel.hidden = true
        
        self.imageProcessorWithIndex(3)
    }
    
    // MARK: ImageProcessorClass
    
    func imageProcessorWithIndex(indexFilter:Int) {
        let imageBrightnessFilter = ImageProcessor(image: UIImage(named: defaultImageName)!)
        self.filteredImage = imageBrightnessFilter.implementFilter(indexFilter)
        self.imageView.image = self.filteredImage
    }
    
    func getFilteredImage(indexFilter: Int) ->UIImage {
        let imageBrightnessFilter = ImageProcessor(image: UIImage(named: defaultImageName)!)
        return imageBrightnessFilter.implementFilter(indexFilter)
    }
    
    // MARK: CompareScenario
    
    func showDefaultImage() {
        self.imageView.image = UIImage(named: defaultImageName)
        self.originalLabel.hidden = false
    }
    
    func showFilterImage() {
        self.imageView.image = self.filteredImage
        self.originalLabel.hidden = true
    }
    
    // MARK: LognPressGesture
    
    func longTap(sender:UILongPressGestureRecognizer){
        print("Long tap")
        if sender.state == .Ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
            if (self.filteredImage != nil) {
                self.showFilterImage()
            }
        }
        else if sender.state == .Began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
            self.showDefaultImage()
        }
    }
    
   
}

