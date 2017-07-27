# AJMAnimatorView

AJMAnimatorview is a custom view which animates the appearance of an image using Core Animation and Core Graphics. There are two available style animations : square and circle.

## Usage

1. Declare a custom AJMAnimatorView property in your view controller

```swift
@IBOutlet weak var animatedView: AJMAnimatorView!
```

2. Call the function animateImage in the AJMAnimatorView (by default it will use a square animation), or if you prefer set a specific style.

```swift
animatedView.animateImage(image: UIImage(named: "nube.jpg")!)
animatedView.animateImage(image: UIImage(named: "nube.jpg")!, usingStyle:  AJMAnimatorStyle.Circle)
```

## Preview
![](https://media.giphy.com/media/sTDVenUXZaVLq/giphy.gif)
![](https://media.giphy.com/media/26n6GhdCWr7Ejpy3m/giphy.gif)

## License
MIT
