![Main](https://raw.githubusercontent.com/wiki/ytakzk/Hokusai/images/main.jpg)

Hokusai is a Swift library that provides a bouncy action sheet.  
It will give the users a fancy experience without taking pains coding the cool animation.  
This is inspired by Skype's iOS app.

[![Version](https://img.shields.io/cocoapods/v/Hokusai.svg?style=flat)](http://cocoapods.org/pods/Hokusai)
[![Platform](https://img.shields.io/cocoapods/p/Hokusai.svg?style=flat)](http://cocoapods.org/pods/Hokusai)

## Installation

Drop in the Classes folder to your Xcode project.

Or via CocoaPods
```
use_frameworks!  
pod 'Hokusai'
```

## Demo
![Demo](https://raw.githubusercontent.com/wiki/ytakzk/Hokusai/images/demo.gif)

## Hokusai Usage

```
let hokusai = Hokusai()

// Add a button with a closure
hokusai.addButton("Button 1") {
    println("Rikyu")
}

// Add a button with a selector
hokusai.addButton("Button 2") {
    println("Oribe")
}

// Set a font name. Default is AvenirNext-DemiBold.
hokusai.fontName = "Verdana-Bold"

// Select a color scheme
hokusai.colorScheme = HOKColorScheme.Enshu

// Show Hokusai
hokusai.show()
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

Or you can use your designed colors.
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