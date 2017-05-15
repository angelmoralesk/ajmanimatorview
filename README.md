# AJMAnimatorview

AJMAnimatorview is a custom view which dismisses the image on screen using layers and animations.

## Usage

1. Declare a property in the view controller

```swift
@IBOutlet weak var animatedView: AJMAnimatorView!
```

2. Call the function animateImage on the AJMAnimatorView object

```swift
animatedView.animateImage(image: UIImage(named: "nube.jpg")!)
```

## Preview
![](https://media.giphy.com/media/sTDVenUXZaVLq/giphy.gif)

## License
MIT
