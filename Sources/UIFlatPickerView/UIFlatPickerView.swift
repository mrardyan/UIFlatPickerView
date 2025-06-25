// © 2025 UIFlatPicker. All rights reserved.

import UIKit

/// A customizable flat design picker view that supports multiple components, infinite scrolling, and various selection styles.
///
/// UIFlatPickerView is an alternative to UIPickerView with a modern flat design using UITableView for each component.
/// It supports infinite scrolling, multiple selection styles, and provides a familiar API similar to UIPickerView.
///
/// ## Features:
/// - Multiple components (columns)
/// - Infinite scrolling support
/// - Customizable selection indicators
/// - Flat design using UITableView
/// - Familiar UIPickerView-like API
///
/// ## Example Usage:
/// ```swift
/// let pickerView = UIFlatPickerView()
/// pickerView.dataSource = self
/// pickerView.delegate = self
/// pickerView.selectionStyle = .defaultIndicator
/// ```
@objc public class UIFlatPickerView: UIView {

  // MARK: - Public Properties

  /// The data source for the picker view
  public weak var dataSource: UIFlatPickerViewDataSource? {
    didSet { setupComponents() }
  }

  /// The delegate for the picker view
  public weak var delegate: UIFlatPickerViewDelegate? {
    didSet { setupComponents() }
  }

  /// The selection style for all components
  @objc public var selectionStyle = SelectionStyle.none {
    didSet {
      for componentPicker in componentPickers {
        componentPicker.selectionStyle = selectionStyle
      }
    }
  }

  /// Enables or disables infinite scrolling for all components
  @objc public var infiniteScrollEnabled: Bool = false {
    didSet {
      for componentPicker in componentPickers {
        componentPicker.infiniteScrollEnabled = infiniteScrollEnabled
      }
    }
  }

  /// The height of each row in points
  @objc public var rowHeight: CGFloat = 44.0 {
    didSet {
      updateRowHeight()
    }
  }

  /// The background color of the picker view
  @objc public override var backgroundColor: UIColor? {
    get { super.backgroundColor }
    set { super.backgroundColor = newValue }
  }

  /// The text color for row titles
  @objc public var textColor: UIColor = .black {
    didSet {
      updateTextColor()
    }
  }

  /// Whether the picker view is enabled for user interaction
  @objc public var enabled = true {
    didSet {
      for componentPicker in componentPickers {
        componentPicker.enabled = enabled
      }
    }
  }

  /// The currently selected row in the first component
  public var currentSelectedRow: Int? {
    get { selectedRow(inComponent: 0) }
    set { if let row = newValue { selectRow(row, inComponent: 0, animated: false) } }
  }

  /// The currently selected index in the first component
  public var currentSelectedIndex: Int {
    selectedRow(inComponent: 0) ?? 0
  }

  /// The color of the selection indicator for all components
  @objc public var selectionIndicatorColor: UIColor = .blue {
    didSet {
      for component in componentPickers {
        component.selectionIndicatorColor = selectionIndicatorColor
      }
    }
  }

  // MARK: - Enums

  /// Defines the visual style for selected rows
  @objc public enum SelectionStyle: Int {
    /// No visual selection indicator
    case none
    /// Default indicator line below selected row
    case defaultIndicator
    /// Overlay background on selected row
    case overlay
    /// Custom image on selected row
    case image
  }

  // MARK: - Private Properties

  private var componentPickers: [PickerComponent] = []
  private var stackView: UIStackView!

  private var selectionOverlayHeight: NSLayoutConstraint!
  private var selectionImageHeight: NSLayoutConstraint!
  private var selectionIndicatorBottom: NSLayoutConstraint!

  // MARK: - Initialization

  @objc public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }

  @objc public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }

  // MARK: - Setup

  private func initialize() {
    setupStackView()
    setupSelectionViews()
  }

  private func setupStackView() {
    stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func setupSelectionViews() {
    // No need to add defaultSelectionIndicator, selectionOverlay, or selectionImageView
    // as they are no longer part of the UIFlatPickerView
  }

  private func setupComponents() {
    guard let dataSource = dataSource else { return }

    // Clear existing components
    componentPickers.forEach { $0.removeFromSuperview() }
    componentPickers.removeAll()

    let numberOfComponents = dataSource.numberOfComponents(in: self)

    for i in 0..<numberOfComponents {
      let component = PickerComponent()
      component.tag = i
      component.dataSource = self
      component.delegate = self
      component.infiniteScrollEnabled = infiniteScrollEnabled
      component.selectionStyle = selectionStyle
      component.enabled = enabled

      stackView.addArrangedSubview(component)
      componentPickers.append(component)
    }
  }

  // MARK: - Row/Color/Selection Updates

  private func updateRowHeight() {
    for component in componentPickers {
      component.reloadComponent()
    }
    setNeedsLayout()
  }

  private func updateTextColor() {
    for component in componentPickers {
      component.tableView.reloadData()
    }
  }

  // MARK: - Row Selection API

  public func selectedRow(inComponent component: Int) -> Int? {
    guard component >= 0 && component < componentPickers.count else { return nil }
    return componentPickers[component].currentSelectedRow
  }

  public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
    guard component >= 0 && component < componentPickers.count else { return }
    componentPickers[component].selectRow(row, animated: animated)
  }
}

// MARK: - PickerComponentDataSource

extension UIFlatPickerView: PickerComponentDataSource {
  func pickerComponentNumberOfRows(_ component: PickerComponent) -> Int {
    guard let dataSource = dataSource else { return 0 }
    return dataSource.pickerView(self, numberOfRowsInComponent: component.tag)
  }

  func pickerComponent(_ component: PickerComponent, titleForRow row: Int) -> String {
    guard let dataSource = dataSource else { return "" }
    return dataSource.pickerView(self, titleForRow: row, forComponent: component.tag)
  }
}

// MARK: - PickerComponentDelegate

extension UIFlatPickerView: PickerComponentDelegate {
  func pickerComponentHeightForRows(_ component: PickerComponent) -> CGFloat {
    return delegate?.pickerViewRowsHeight(self) ?? 44.0
  }

  func pickerComponent(_ component: PickerComponent, didSelectRow row: Int) {
    delegate?.pickerView(self, didSelectRow: row, inComponent: component.tag)
  }

  func pickerComponent(_ component: PickerComponent, didTapRow row: Int) {
    delegate?.pickerView(self, didTapRow: row, inComponent: component.tag)
  }

  func pickerComponent(
    _ component: PickerComponent, styleForLabel label: UILabel, highlighted: Bool
  ) {
    delegate?.pickerView(
      self, styleForLabel: label, forComponent: component.tag, highlighted: highlighted)
  }

  func pickerComponent(
    _ component: PickerComponent,
    viewForRow row: Int,
    highlighted: Bool,
    reusingView view: UIView?
  )
    -> UIView?
  {
    return delegate?.pickerView(
      self, viewForRow: row, forComponent: component.tag, highlighted: highlighted, reusingView: view)
  }

  func pickerComponentSpacingBetweenComponents(_ component: PickerComponent) -> CGFloat {
    return delegate?.pickerViewSpacingBetweenComponents(self) ?? 0
  }

  func pickerComponent(_ component: PickerComponent, widthForComponent: Int) -> CGFloat {
    return delegate?.pickerView(self, widthForComponent: component.tag) ?? -1
  }
}
