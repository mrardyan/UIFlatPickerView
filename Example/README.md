# UIFlatPickerView Example App

This example app demonstrates all the features and capabilities of the UIFlatPickerView package.

## Setup Instructions

### 1. Open the Example Project
- Open `UIFlatPickerViewExample.xcodeproj` in Xcode
- The project is already configured with the necessary files

### 2. Add the UIFlatPickerView Package
- In Xcode, go to **File > Add Package Dependencies...**
- Enter the package URL: `https://github.com/mrardyan/UIFlatPickerView.git`
- Click **Add Package**
- Make sure the `UIFlatPickerView` library is added to your app target

### 3. Build and Run
- Select your target device or simulator (iOS 12.0+)
- Press **Cmd+R** to build and run the app

## Features Demonstrated

### 1. Basic Picker
- Simple single-component picker with months
- Default selection indicator style
- Standard text display

### 2. Infinite Scrolling Picker
- Numbers 1-100 with infinite scrolling enabled
- Overlay selection style
- Demonstrates seamless looping through data

### 3. Custom View Picker
- Custom row views with highlighted states
- Image selection style
- Custom background and styling

### 4. Multi-Component Picker
- Two components: Years and Colors
- Indicator selection style
- Shows how to handle multiple columns

### 5. Interactive Controls
- **Selection Style**: Switch between None, Indicator, Overlay, and Image styles
- **Row Height**: Adjust row height from 30 to 80 points
- **Text Color**: Change text color across all pickers
- **Indicator Color**: Change selection indicator color
- **Random Selection**: Programmatically select random rows

## What You'll See

The app showcases:
- Different selection styles (none, indicator, overlay, image)
- Infinite scrolling functionality
- Custom row views with highlighting
- Multi-component pickers
- Real-time customization controls
- Haptic feedback on selection
- Auto Layout integration

## Code Examples

The example demonstrates:
- Setting up data sources and delegates
- Configuring selection styles and colors
- Implementing custom row views
- Handling selection events
- Programmatic row selection
- Infinite scrolling setup

## Requirements

- iOS 12.0+
- Xcode 12.0+
- Swift 5.0+

## Troubleshooting

If you encounter build errors:
1. Make sure the UIFlatPickerView package is properly added
2. Check that the deployment target is iOS 12.0 or later
3. Clean the build folder (Product > Clean Build Folder)
4. Restart Xcode if needed

This example serves as both a demonstration and a reference implementation for using UIFlatPickerView in your own projects. 