![Main](https://raw.githubusercontent.com/wiki/ytakzk/Hokusai/images/main.jpg)

Hokusai is a Swift library that provides a bouncy action sheet.  
It will give the users a fancy experience without taking pains coding the cool animation.  
Hokusai is compatible with Swift2.0!!

[![Version](https://img.shields.io/cocoapods/v/Hokusai.svg?style=flat)](http://cocoapods.org/pods/Hokusai)
[![Platform](https://img.shields.io/cocoapods/p/Hokusai.svg?style=flat)](http://cocoapods.org/pods/Hokusai)
[![CI Status](http://img.shields.io/travis/ytakzk/Hokusai.svg?style=flat)](https://travis-ci.org/ytakzk/Hokusai)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installation

Drop in the Classes folder to your Xcode project.  
You can also use cocoapods or Carthage.

#### Using [cocoapods](http://cocoapods.org/)

Add `pod 'Hokusai'` to your `Podfile` and run `pod install`. Also add `use_frameworks!` to the `Podfile`.

```
use_frameworks!
pod 'Hokusai'
```

#### Using [Carthage](https://github.com/Carthage/Carthage)

Add `github "ytakzk/Hokusai" to your `Cartfile` and run `carthage update`. If unfamiliar with Carthage then checkout their [Getting Started section](https://github.com/Carthage/Carthage#getting-started).

```
github "ytakzk/Hokusai"
```

## Demo
![Demo](https://raw.githubusercontent.com/wiki/ytakzk/Hokusai/images/demo.gif)

## Hokusai Usage
Import Hokusai ```import Hokusai``` then use the following codes in some function except for viewDidLoad.  

```
let hokusai = Hokusai()

// Add a button with a closure
hokusai.addButton("Button 1") {
    println("Rikyu")
}

// Add a button with a selector
hokusai.addButton("Button 2", target: self, selector: Selector("button2Pressed"))

// Set a font name. AvenirNext-DemiBold is the default. (Optional)
hokusai.fontName = "Verdana-Bold"

// Select a color scheme. Just below you can see the dafault sets of schemes. (Optional)
hokusai.colorScheme = HOKColorScheme.Enshu

// Show Hokusai
hokusai.show()

// Selector for button 2
func button2Pressed() {
    println("Oribe")
}

// Change a title for cancel button. Default is Cancel. (Optional)
hokusai.cancelButtonTitle = "Done"

// Add a callback for cancel button (Optional)
hokusai.cancelButtonAction = {
    println("canceled")
}

```

#### Add a button with a closure
```
hokusai.addButton("Button Title") {
    // Do anything you want
}
```

#### Add a button with a selector
```
hokusai.addButton("Button Title", target: self, selector: Selector("buttonPressed"))

func buttonPressed() {
    // Do anything you want
}
```

## Color schemes
![Demo](https://raw.githubusercontent.com/wiki/ytakzk/Hokusai/images/colors.jpg)


```
public enum HOKColorScheme {
    case  Hokusai,
          Asagi,
          Matcha,
          Tsubaki,
          Inari,
          Karasu,
          Enshu
}
```

Or you can use your favorite color combination.
```
hokusai.colors = HOKColors(
    backGroundColor: UIColor.blackColor(),
    buttonColor: UIColor.purpleColor(),
    cancelButtonColor: UIColor.grayColor(),
    fontColor: UIColor.whiteColor()
)
```

## Author
ytakzk  
 [http://ytakzk.me](http://ytakzk.me)
 
## License
Hokusai is released under the MIT license.  
See LICENSE for details.
