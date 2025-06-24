# UIFlatPickerView

A modern, customizable flat design picker view for iOS that provides an alternative to `UIPickerView` with enhanced features and a familiar API.

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
    .package(url: "https://github.com/mrardyan/UIFlatPickerView.git", from: "1.0.0")
]
```

## Usage

### Basic Implementation

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
        pickerView.scrollingStyle = .infinite
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

### Advanced Configuration

```swift
class AdvancedViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIFlatPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Customize appearance
        pickerView.selectionStyle = .overlay
        pickerView.scrollingStyle = .default
        
        // Set custom colors
        pickerView.backgroundColor = .systemBackground
        pickerView.defaultSelectionIndicator.backgroundColor = .systemBlue
        pickerView.selectionOverlay.backgroundColor = .systemBlue
        
        // Set initial selection
        pickerView.selectRow(5, inComponent: 0, animated: false)
        pickerView.selectRow(2, inComponent: 1, animated: false)
    }
}
```

### Custom Selection Styles

```swift
// Different selection styles you can use
pickerView.selectionStyle = .none                    // No visual selection indicator
pickerView.selectionStyle = .defaultIndicator        // Default selection indicator
pickerView.selectionStyle = .overlay                 // Custom overlay style
pickerView.selectionStyle = .image                   // Custom image style
```

### Infinite Scrolling Example

```swift
class InfiniteScrollViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIFlatPickerView!
    
    let numbers = Array(1...100).map { String($0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Enable infinite scrolling
        pickerView.scrollingStyle = .infinite
        
        // Set initial position in the middle for infinite scrolling
        pickerView.selectRow(numbers.count / 2, inComponent: 0, animated: false)
    }
}

extension InfiniteScrollViewController: UIFlatPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIFlatPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIFlatPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return numbers[row]
    }
}
```

### Programmatic Control

```swift
// Select specific rows
pickerView.selectRow(5, inComponent: 0, animated: true)
pickerView.selectRow(10, inComponent: 1, animated: false)

// Get current selection
let selectedRow = pickerView.selectedRow(inComponent: 0)
let selectedTitle = pickerView.dataSource?.pickerView(pickerView, titleForRow: selectedRow ?? 0, forComponent: 0)

// Reload data
pickerView.reloadAllComponents()
pickerView.reloadComponent(0)

// Enable/disable the picker
pickerView.enabled = false
```

### Custom Row Views

```swift
extension ViewController: UIFlatPickerViewDelegate {
    
    func pickerView(
        _ pickerView: UIFlatPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        highlighted: Bool,
        reusingView view: UIView?
    ) -> UIView? {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        switch component {
        case 0:
            label.text = months[row]
            if highlighted {
                label.textColor = .systemBlue
                label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                label.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            } else {
                label.textColor = .label
                label.backgroundColor = row % 2 == 0 ? .systemGray6 : .systemBackground
            }
        case 1:
            label.text = years[row]
            if highlighted {
                label.textColor = .systemGreen
                label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                label.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            } else {
                label.textColor = .label
                label.backgroundColor = .systemBackground
            }
        default:
            label.text = ""
        }
        
        return label
    }
}
```

### Auto Layout Integration

```swift
class AutoLayoutViewController: UIViewController {
    
    private let pickerView = UIFlatPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        setupConstraints()
    }
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            pickerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
```

## API Reference

### UIFlatPickerView Properties

- `dataSource: UIFlatPickerViewDataSource?` - The data source for the picker view
- `delegate: UIFlatPickerViewDelegate?` - The delegate for the picker view
- `selectionStyle: SelectionStyle` - The visual style for selection indication
- `scrollingStyle: ScrollingStyle` - The scrolling behavior (default or infinite)
- `enabled: Bool` - Whether the picker view is enabled
- `defaultSelectionIndicator: UIView` - The default selection indicator view
- `selectionOverlay: UIView` - The selection overlay view
- `selectionImageView: UIImageView` - The selection image view

### Selection Styles

- `.none` - No visual selection indicator
- `.defaultIndicator` - Default selection indicator
- `.overlay` - Custom overlay style
- `.image` - Custom image for selection

### Scrolling Styles

- `.default` - Standard scrolling behavior
- `.infinite` - Infinite scrolling that loops through data

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 