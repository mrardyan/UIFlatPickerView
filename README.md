# UIFlatPickerView

A customizable flat-design alternative to UIPickerView using UITableView, supporting infinite scroll, multiple components, and modern selection styles.

## Features

- **Flat Design**: Modern flat design using `UITableView` for each component
- **Infinite Scrolling**: Support for infinite scrolling that loops through data
- **Multiple Components**: Support for multiple columns (components) like `UIPickerView`
- **Customizable Selection**: Multiple selection styles (none, indicator, overlay, image)
- **Familiar API**: Similar API to `UIPickerView` for easy adoption
- **Auto Layout**: Built with Auto Layout for flexible sizing
- **Customizable**: Extensive customization options for appearance and behavior

## Requirements

- iOS 12.0+
- macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add UIFlatPickerView to your project in Xcode:

1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/mrardyan/UIFlatPickerView.git`
3. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mrardyan/UIFlatPickerView.git", from: "1.0.1")
]
```

## Usage

### Basic Example

Here's a simple example of how to use UIFlatPickerView in your view controller:

```swift
import UIKit
import UIFlatPickerView

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIFlatPickerView!
    
    let months = ["January", "February", "March", "April", "May", "June",
                  "July", "August", "September", "October", "November", "December"]
    let years = Array(2020...2030).map { String($0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the picker view
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Configure appearance
        pickerView.selectionStyle = .defaultIndicator
        pickerView.selectionIndicatorColor = .systemBlue // Applies to all components
        pickerView.infiniteScrollEnabled = false // Set to true for infinite scrolling
    }
}

// MARK: - UIFlatPickerViewDataSource
extension ViewController: UIFlatPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIFlatPickerView) -> Int {
        return 2 // Month and Year
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return months.count
        case 1: return years.count
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        switch component {
        case 0: return months[row]
        case 1: return years[row]
        default: return ""
        }
    }
}

// MARK: - UIFlatPickerViewDelegate
extension ViewController: UIFlatPickerViewDelegate {
    
    func pickerView(_ pickerView: UIFlatPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = months[pickerView.selectedRow(inComponent: 0) ?? 0]
        let year = years[pickerView.selectedRow(inComponent: 1) ?? 0]
        print("Selected: \(month) \(year)")
    }
}
```

### Enabling Infinite Scroll

```swift
pickerView.infiniteScrollEnabled = true // Enables infinite scrolling for all components
```

### Customizing Selection Indicator Color

```swift
pickerView.selectionIndicatorColor = .red // Changes indicator color for all components
```

### Data Source & Delegate

Implement the required protocols:

```swift
extension YourViewController: UIFlatPickerViewDataSource, UIFlatPickerViewDelegate {
    func numberOfComponents(in pickerView: UIFlatPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIFlatPickerView, numberOfRowsInComponent component: Int) -> Int { 12 }
    func pickerView(_ pickerView: UIFlatPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        months[row]
    }
    func pickerViewRowsHeight(_ pickerView: UIFlatPickerView) -> CGFloat { 44 }
    func pickerView(_ pickerView: UIFlatPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle selection
    }
    // ... other delegate methods as needed ...
}
```

## API Changes (v1.0.1)

- Removed `ScrollingStyle` enum and `scrollingStyle` property. Use `infiniteScrollEnabled` (Bool) instead.
- `selectionIndicatorColor` now applies to all components.
- All indicator/overlay/image logic is now handled in `PickerComponent` only.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 