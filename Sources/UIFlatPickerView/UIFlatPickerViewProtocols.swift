// © 2025 UIFlatPicker. All rights reserved.

import UIKit

// MARK: - UIFlatPickerViewDataSource

/// The data source for a UIFlatPickerView object.
///
/// The data source provides the picker view with the data it needs to construct itself.
/// It must adopt the UIFlatPickerViewDataSource protocol and implement the required methods.
public protocol UIFlatPickerViewDataSource: AnyObject {
  /// Returns the number of components (columns) in the picker view.
  /// - Parameter pickerView: The picker view requesting this information.
  /// - Returns: The number of components in the picker view.
  func numberOfComponents(in pickerView: UIFlatPickerView) -> Int

  /// Returns the number of rows in the specified component.
  /// - Parameters:
  ///   - pickerView: The picker view requesting this information.
  ///   - component: The component index (zero-based).
  /// - Returns: The number of rows in the component.
  func pickerView(_ pickerView: UIFlatPickerView, numberOfRowsInComponent component: Int) -> Int

  /// Returns the title for the row in the specified component.
  /// - Parameters:
  ///   - pickerView: The picker view requesting this information.
  ///   - row: The row index (zero-based).
  ///   - component: The component index (zero-based).
  /// - Returns: The title for the row.
  func pickerView(_ pickerView: UIFlatPickerView, titleForRow row: Int, forComponent component: Int)
    -> String
}

// MARK: - UIFlatPickerViewDelegate

/// The delegate for a UIFlatPickerView object.
///
/// The delegate receives notifications when the user selects a row or when the picker view needs
/// information about its appearance. It must adopt the UIFlatPickerViewDelegate protocol and implement
/// the required methods.
public protocol UIFlatPickerViewDelegate: AnyObject {
  /// Returns the height for rows in all components.
  /// - Parameter pickerView: The picker view requesting this information.
  /// - Returns: The height for rows in points.
  func pickerViewRowsHeight(_ pickerView: UIFlatPickerView) -> CGFloat

  /// Called when the user selects a row in a component.
  /// - Parameters:
  ///   - pickerView: The picker view that contains the selected row.
  ///   - row: The index of the selected row (zero-based).
  ///   - component: The index of the component containing the selected row (zero-based).
  func pickerView(_ pickerView: UIFlatPickerView, didSelectRow row: Int, inComponent component: Int)

  /// Called when the user taps a row in a component.
  /// - Parameters:
  ///   - pickerView: The picker view that contains the tapped row.
  ///   - row: The index of the tapped row (zero-based).
  ///   - component: The index of the component containing the tapped row (zero-based).
  func pickerView(_ pickerView: UIFlatPickerView, didTapRow row: Int, inComponent component: Int)

  /// Called to style the label for a row in a component.
  /// - Parameters:
  ///   - pickerView: The picker view requesting the styling.
  ///   - label: The label to be styled.
  ///   - component: The index of the component containing the row (zero-based).
  ///   - highlighted: Whether the row is currently highlighted.
  func pickerView(
    _ pickerView: UIFlatPickerView, styleForLabel label: UILabel, forComponent component: Int,
    highlighted: Bool)

  /// Returns a custom view for a row in a component.
  /// - Parameters:
  ///   - pickerView: The picker view requesting the view.
  ///   - row: The index of the row (zero-based).
  ///   - component: The index of the component containing the row (zero-based).
  ///   - highlighted: Whether the row is currently highlighted.
  ///   - view: A previously used view that can be reused, or nil if no view is available.
  /// - Returns: A custom view for the row, or nil to use the default label.
  func pickerView(
    _ pickerView: UIFlatPickerView,
    viewForRow row: Int,
    forComponent component: Int,
    highlighted: Bool,
    reusingView view: UIView?
  )
    -> UIView?

  /// Returns the spacing between components.
  /// - Parameter pickerView: The picker view requesting this information.
  /// - Returns: The spacing between components in points.
  func pickerViewSpacingBetweenComponents(_ pickerView: UIFlatPickerView) -> CGFloat

  /// Returns the width for a specific component.
  /// - Parameters:
  ///   - pickerView: The picker view requesting this information.
  ///   - component: The index of the component (zero-based).
  /// - Returns: The width for the component in points, or -1 to use equal distribution.
  func pickerView(_ pickerView: UIFlatPickerView, widthForComponent component: Int) -> CGFloat
}

// MARK: - UIFlatPickerViewDelegate Default Implementations

extension UIFlatPickerViewDelegate {
  /// Default implementation returns -1, indicating equal distribution.
  /// - Parameters:
  ///   - pickerView: The picker view requesting this information.
  ///   - component: The index of the component (zero-based).
  /// - Returns: -1 to use equal distribution.
  public func pickerView(_ pickerView: UIFlatPickerView, widthForComponent component: Int) -> CGFloat
  {
    -1
  }

  /// Default implementation returns 0 spacing.
  /// - Parameter pickerView: The picker view requesting this information.
  /// - Returns: 0 points of spacing.
  public func pickerSpaceBetweenComponents(_ pickerView: UIFlatPickerView) -> CGFloat {
    0
  }
}
