# Bird-Watching-iOS
Social network iOS application for bird watching

#### Features and Implementation:
* Firebase account creation using email and password
* Users can post a bird sighting with picture, bird name, and a description
  * A sighting post has the location associated
  * Users can flag sightings if they feel the sighting is false
    * Flagging the post turns the map annotation of the post red, instead of green, letting users know the sighting is skeptical
  * Users can comment on sightings
  * Sightings have time associated, so users do not go searching for a bird that flew
* Sightings are displayed as either a list or a map view
  * List view displays the picture and birdname, as well as time since sighting and current user's distance from sighting
  * Map view displays all sightings as annotations on the map, the annotation is green if not flagged, and red if flagged
    * Tapping an annotation will give the user the option to see more information, as well as display bird name and time since sighting
* Sighting information as well as comments stored in Firebase Database, and images in Firebase Storage

## Screenshots

#### Log In Screen

![birdlogin](https://cloud.githubusercontent.com/assets/8918712/26815013/887a4064-4a3e-11e7-9bba-9fe75be7ff90.png)
