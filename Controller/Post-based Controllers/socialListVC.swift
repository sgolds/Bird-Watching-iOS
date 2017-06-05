//
//  socialListVC.swift
//  Bird Watching
//
//  Created by Sten Golds on 7/13/16.
//  Copyright © 2016 Sten Golds. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class socialListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    //references to the tableView and mapView created in the storyboard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    //array of posts to display
    var posts = [Post]()
    
    //variables used to store the post information that will be passed on to the viewPostVC
    var selectedPostTime = ""
    var selectedPostDistance = ""
    var selectedPostImage: UIImage?
    
    //CLLocation variables
    let locationManager: CLLocationManager = CLLocationManager()
    var currLocation: CLLocationCoordinate2D! = CLLocationCoordinate2D()
    let regionRadius: CLLocationDistance = 2000 //2km
    
    //cache used to store downloaded images, so images aren't repeatedly downloaded
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //move the mapView to follow user
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        //call function to start up core location, and set up MapView
        beginCoreLocAndMapSetUp()

        //fill the posts array, and add post annotations to mapView
        loadPosts()
        
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DISPLAY_POST_SEGUE { //if going to the viewPostVC continue
            if let displayVC = segue.destination as? viewPostVC { //cast the destination of the segue as viewPostVC, continue on sucess
                if let post = sender as? Post { //cast the sender of the segue to Post, continue on success
                    //set the post for the viewPostVC to the sender post
                    displayVC.post = post
                    
                    //set the time of the viewPostVC to the time associated with the selected post
                    displayVC.sentTime = self.selectedPostTime
                    
                    //set the distance of the viewPostVC to the distance associated with the selected post
                    displayVC.sentDist = self.selectedPostDistance
                    
                    //check if post had an image, if so set the image of the viewPostVC to the selected post image
                    if let imageForSegue = self.selectedPostImage {
                        displayVC.sentImage = imageForSegue
                    }
                }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //only want one section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //want one row per one post to display
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get post at given row
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell { //dequeue a reusable cell as PostCell, continue on success
            
            
            if let image = socialListVC.imageCache.object(forKey: post.postKey as NSString) { //if cache has an image for the post, load the image from cache
                
                //configure the dequeued PostCell with an image provided
                cell.configCell(post: post, currLocation: currLocation, image: image)
            } else {
                cell.configCell(post: post, currLocation: currLocation)
            }
            
            //return the configured cell
            return cell
        } else { //if a dequeued cell couldn't be cast as a PostCell, create a new PostCell
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //store selected cell
        let cell = tableView.cellForRow(at: indexPath) as! PostCell
        
        //set the selectedPostTime to the time associated with the selected cell
        if let timeString = cell.timeLabel.text {
            selectedPostTime = timeString
        }
        
        //set the selectedPostDistance to the distance associated with the selected cell
        if let distString = cell.distanceLabel.text {
            selectedPostDistance = distString
        }
        
        //set the selectedPostImage to the image associated with the selected cell
        if let imagePicked = cell.postImage.image {
            selectedPostImage = imagePicked
        }
        
        //segue to a view controller to display the selected post, use the selected post as the sender
        self.performSegue(withIdentifier: DISPLAY_POST_SEGUE, sender: posts[indexPath.row])
        
        //deselect the selected row
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    
    /**
     * @name listButtonPressed
     * @desc if the list is chosen to display, hide the mapView and display the tableView
     * @param AnyObject sender - sender of the action
     * @return void
     */
    @IBAction func listButtonPressed(_ sender: AnyObject) {
        self.tableView.isHidden = false
        self.mapView.isHidden = true
    }
    
    /**
     * @name mapButtonPressed
     * @desc if the map is chosen to display, hide the tableView and display the mapView
     * @param AnyObject sender - sender of the action
     * @return void
     */
    @IBAction func mapButtonPressed(_ sender: AnyObject) {
        self.tableView.isHidden = true
        self.mapView.isHidden = false

    }
    
    /**
     * @name loadPosts
     * @desc get posts from the firebase database, add annotations to the mapView for the associated posts
     * and store these posts in posts array
     * @return void
     */
    func loadPosts() {
        
        DataService.ds.POST_REF.observe(.value, with: { (snapshot) in //get posts as snapshot
            //clear posts
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] { //cast the snapshot as an array of snapshots, continue on success
                //iterate over the snapshots gotten
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> { //cast value of the snapshot to a dict, continue on success
                        //initialize a post with the data gotten from the snapshot
                        let gotPost = Post(dictionary: postDict)
                        
                        //initialize a BirdMapAnnotation with the created post, add it to the mapView
                        let postAnno = BirdMapAnnotation(post: gotPost)
                        self.mapView.addAnnotation(postAnno)
                        
                        //add the created post to the posts array
                        self.posts.append(gotPost)
                    }
                    
                }
            }
            
            //reload the tableView so the gotten posts will be displayed
            self.tableView.reloadData()
        })
    }
    
    
    /**
     * @name locationManager - didUpdateLocations
     * @desc update the users current location variable as the current location changes
     * @param CLLocationManager manager - manager used to get current user's location
     * @param [CLLocation] locations - array of new location data
     * @return void
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue:CLLocationCoordinate2D = manager.location?.coordinate {
            currLocation = locValue
        }
    }
    
    /**
     * @name beginCoreLocAndMapSetUp
     * @desc starts the locationManager, and initializes the mapView
     * @return void
     */
    func beginCoreLocAndMapSetUp() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        //ask for authorization from the user for always getting location
        self.locationManager.requestAlwaysAuthorization()
        
        //ask for authorization from the user for getting their location when using the app
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() { //if location services are authorized
            
            //begin getting the user's location
            locationManager.startUpdatingLocation()
            
            //update the currLocation variable to contain the user's current location
            if let locValue:CLLocationCoordinate2D = locationManager.location?.coordinate {
                currLocation = locValue
            }
            
            //intialize mapView around the user's current location
            let initialLocation = CLLocation(latitude: currLocation.latitude, longitude: currLocation.longitude)
            centerMapOnLocation(location: initialLocation)
            
            //show the user's locaiton on the mapView
            mapView.showsUserLocation = true
        }
    }
    
    /**
     * @name locationManager - didChangeAuthorization
     * @desc called if the authorization status is changed, if the status includes always authorized and authorized when in use
     * display user's location on mapView
     * @param CLLocationManager manager - location manager
     * @param CLAuthorizationStatus status - status of our authorization to get user's location
     * @return void
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways && status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    /**
     * @name mapView - calloutAccessoryControlTapped
     * @desc gets the associated post information for annotation accessory tapped, segues to a view controller to display
     * the assocciated post
     * @param MKMapView mapView - the mapView
     * @param MKAnnotationView view - assocciated annotation view that was tapped
     * @param UIControl control - associated UIControl
     * @return void
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? BirdMapAnnotation { //cast the view's annotation as a BirdMapAnnotation, continue on success
            //if the annotation has a time, set the selectedPostTime to the annotation's time
            if let time = anno.postAge {
                selectedPostTime = time
            }
            
            if let postFromAnno = anno.post as? Post { //cast the annotation's post as a Post, continue on success
                
                //get the post's location, and the user's current location
                let locOne = CLLocation.init(latitude: CLLocationDegrees.init(postFromAnno.location[0]), longitude: CLLocationDegrees.init(postFromAnno.location[1]))
                let locTwo = CLLocation.init(latitude: currLocation.latitude, longitude: currLocation.longitude)
                
                //set the selectedPostDistance to the calculated string value containing the distance from the post to the user
                selectedPostDistance = postFromAnno.distanceString(dist: Int(locOne.distance(from: locTwo)))
                
                //create reference to storage location of the post image
                let imgRef = DataService.ds.IMAGES_REF.child(postFromAnno.postKey + ".jpg")
                
                // Download the image, if there is no error downloading set the selectedPostImage to the downloaded image
                imgRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        print(error)
                    } else {
                        self.selectedPostImage = UIImage(data: data!)!
                    }
                    
                    //segue to screen to display the selected post, use the post associated with the selected annotation
                    //as the sender
                    self.performSegue(withIdentifier: DISPLAY_POST_SEGUE, sender: postFromAnno)
                }
            }
        }
        
       
    }
    
    /**
     * @name centerMapOnLocation
     * @desc centers the mapView around the given location
     * @param CLLocation location - location to center mapView around
     * @return void
     */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}
