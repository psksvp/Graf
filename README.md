# Graf

Graf is a crossed platform graphics library for Swift Programming Language. 

Graf was inspired by [Processing](https://processing.org/), but not a clone. Graf will always be just a library.

Graf runs on MacOS and Linux. A port to iOS and Android is in the pipeline.

## Requirements

Graf uses [Cairo](https://www.cairographics.org) for drawing and [SDL2](https://www.libsdl.org) for displaying and handling inputs. 

* on MacOS, SDL2 and Cairo can be installed using [brew](https://brew.sh/). 

	> brew install sdl2 cairo

* on Ubuntu based Linux, run the following command

	> apt install libsdl2-dev libcairo2-dev

## Swift Package Manager 

To use Graf in your project, add Graf to the list of dependencies like below.

```swift

let package = Package(
    dependencies: [
        .package(name: "Graf", url: "https://github.com/psksvp/Graf.git", .branch("master"))
    ]
)

```

## Drawing and Input Loop

```swift

import Foundation
import Graf

func animation102()
{
  let view = Graf.newView("Hello Graf", 640, 480)
  
  var x = 0.0
  var y = Double(view.height) / 2
  
  view.draw
  {
    dc in
    
    dc.clear()
    Graf.ellipse(x, y, 200, 100).draw(dc)
    
    x = x + 1
  }
  
  view.onInputEvent
  {
    evt in
    
    switch evt
    {
      case let .mousePressed(mouseX: mx, mouseY: my, button: _) :
        x = Double(mx)
        y = Double(my)
      
      default: break
    }
  }
}

```


## Example

## Credit


## Contact 

<psksvp@gmail.com>


