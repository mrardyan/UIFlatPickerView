// © 2025 UIFlatPicker. All rights reserved.

import UIKit

// MARK: - PickerComponentDataSource

/// Internal protocol for data source communication between UIFlatPickerView and PickerComponent
protocol PickerComponentDataSource: AnyObject {
  /// Returns the number of rows in the component
  func pickerComponentNumberOfRows(_ component: PickerComponent) -> Int

  /// Returns the title for a specific row
  func pickerComponent(_ component: PickerComponent, titleForRow row: Int) -> String
}

// MARK: - PickerComponentDelegate

/// Internal protocol for delegate communication between UIFlatPickerView and PickerComponent
protocol PickerComponentDelegate: AnyObject {
  /// Returns the height for rows in the component
  func pickerComponentHeightForRows(_ component: PickerComponent) -> CGFloat

  /// Called when a row is selected
  func pickerComponent(_ component: PickerComponent, didSelectRow row: Int)

  /// Called when a row is tapped
  func pickerComponent(_ component: PickerComponent, didTapRow row: Int)

  /// Called to style the label for a row
  func pickerComponent(_ component: PickerComponent, styleForLabel label: UILabel, highlighted: Bool)

  /// Returns a custom view for a row
  func pickerComponent(_ component: PickerComponent, viewForRow row: Int, highlighted: Bool, reusingView view: UIView?) -> UIView?

  /// Returns the spacing between components
  func pickerComponentSpacingBetweenComponents(_ component: PickerComponent) -> CGFloat

  /// Returns the width for the component
  func pickerComponent(_ component: PickerComponent, widthForComponent: Int) -> CGFloat
}

// MARK: - PickerComponent

/// A single component (column) of the UIFlatPickerView that handles scrolling and selection.
///
/// PickerComponent is responsible for managing a single column of the picker view,
/// including infinite scrolling, row selection, and visual feedback.
class PickerComponent: UIView {

  // MARK: - Public Properties

  /// The unique identifier for this component
  public let identifier: String

  /// The currently selected row in this component
  open var currentSelectedRow: Int!

  /// The currently selected index (accounting for infinite scrolling)
  open var currentSelectedIndex: Int {
    indexForRow(currentSelectedRow)
  }

  /// The scrolling style for this component
  open var scrollingStyle = UIFlatPickerView.ScrollingStyle.default {
    didSet {
      switch scrollingStyle {
      case .default:
        infinityRowsMultiplier = 1
      case .infinite:
        infinityRowsMultiplier = generateInfinityRowsMultiplier()
      }
    }
  }

  /// The selection style for this component
  open var selectionStyle = UIFlatPickerView.SelectionStyle.none {
    didSet {
      setupSelectionViewsVisibility()
    }
  }

  /// The data source for this component
  open weak var dataSource: PickerComponentDataSource?

  /// The delegate for this component
  open weak var delegate: PickerComponentDelegate?

  // MARK: - Customizable Views

  /// The default selection indicator view
  open lazy var defaultSelectionIndicator: UIView = {
    let selectionIndicator = UIView()
    selectionIndicator.backgroundColor = self.tintColor
    selectionIndicator.alpha = 0.0
    return selectionIndicator
  }()

  /// The selection overlay view
  open lazy var selectionOverlay: UIView = {
    let selectionOverlay = UIView()
    selectionOverlay.backgroundColor = self.tintColor
    selectionOverlay.alpha = 0.0
    return selectionOverlay
  }()

  /// The selection image view
  open lazy var selectionImageView: UIImageView = {
    let selectionImageView = UIImageView()
    selectionImageView.alpha = 0.0
    return selectionImageView
  }()

  /// The main table view for displaying rows
  public lazy var tableView = UITableView()

  // MARK: - Lifecycle

  /// Unavailable. Use `init(identifier:frame:)` instead.
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Initializes a new picker component
  /// - Parameters:
  ///   - identifier: A unique identifier for this component
  ///   - frame: The frame for this component
  init(identifier: String = "", frame: CGRect = .zero) {
    self.identifier = identifier
    super.init(frame: frame)
  }

  // MARK: - Public Methods

  /// Selects a specific row in the component
  /// - Parameters:
  ///   - row: The row index to select
  ///   - animated: Whether to animate the selection
  open func selectRow(_ row: Int, animated: Bool) {
    var finalRow = row

    if scrollingStyle == .infinite, row <= numberOfRowsByDataSource {
      let middleMultiplier =
        scrollingStyle == .infinite ? (infinityRowsMultiplier / 2) : infinityRowsMultiplier
      let middleIndex = numberOfRowsByDataSource * middleMultiplier
      finalRow = middleIndex - (numberOfRowsByDataSource - finalRow)
    }

    currentSelectedRow = finalRow
    delegate?.pickerComponent(self, didSelectRow: indexForRow(currentSelectedRow))
    tableView.setContentOffset(
      CGPoint(x: 0.0, y: CGFloat(currentSelectedRow) * rowHeight), animated: animated)
  }

  /// Reloads the component data
  open func reloadComponent() {
    shouldSelectNearbyToMiddleRow = true
    tableView.reloadData()
  }

  // MARK: - Internal Properties

  /// Whether the component is enabled for user interaction
  var enabled = true {
    didSet {
      if enabled {
        turnPickerViewOn()
      } else {
        turnPickerViewOff()
      }
    }
  }

  /// The number of rows provided by the data source
  var numberOfRowsByDataSource: Int {
    dataSource?.pickerComponentNumberOfRows(self) ?? 0
  }

  /// The height for rows in this component
  var rowHeight: CGFloat {
    delegate?.pickerComponentHeightForRows(self) ?? 0
  }

  // MARK: - Private Properties

  private var selectionOverlayH: NSLayoutConstraint!
  private var selectionImageH: NSLayoutConstraint!
  private var selectionIndicatorB: NSLayoutConstraint!
  private var pickerCellBackgroundColor: UIColor?

  private let pickerViewCellIdentifier = "pickerViewCell"

  private var infinityRowsMultiplier = 1
  private var firstTimeOrientationChanged = true
  private var orientationChanged = false
  private var screenSize: CGSize = UIScreen.main.bounds.size
  private var isScrolling = false
  private var setupHasBeenDone = false
  private var shouldSelectNearbyToMiddleRow = true

  private var indexesByDataSource: Int {
    numberOfRowsByDataSource > 0 ? numberOfRowsByDataSource - 1 : numberOfRowsByDataSource
  }

  // MARK: - Override Methods

  override open var backgroundColor: UIColor? {
    didSet {
      tableView.backgroundColor = backgroundColor
      pickerCellBackgroundColor = backgroundColor
    }
  }

  open override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    if newWindow != nil {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(PickerComponent.adjustCurrentSelectedAfterOrientationChanges),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
    } else {
      NotificationCenter.default.removeObserver(
        self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()

    if !setupHasBeenDone {
      setup()
      setupHasBeenDone = true
    }
  }

  // MARK: - Private Methods

  @objc
  private func adjustCurrentSelectedAfterOrientationChanges() {
    guard screenSize != UIScreen.main.bounds.size else {
      return
    }

    screenSize = UIScreen.main.bounds.size
    setNeedsLayout()
    layoutIfNeeded()
    shouldSelectNearbyToMiddleRow = true

    if firstTimeOrientationChanged {
      firstTimeOrientationChanged = false
      return
    }

    if !isScrolling {
      return
    }

    orientationChanged = true
  }

  private func setup() {
    infinityRowsMultiplier = generateInfinityRowsMultiplier()

    translatesAutoresizingMaskIntoConstraints = false
    setupTableView()
    setupSelectionOverlay()
    setupSelectionImageView()
    setupDefaultSelectionIndicator()

    tableView.delegate = self
    tableView.dataSource = self
    tableView.reloadData()

    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.adjustSelectionOverlayHeightConstraint()
    }
  }

  private func setupTableView() {
    tableView.estimatedRowHeight = 0
    tableView.estimatedSectionFooterHeight = 0
    tableView.estimatedSectionHeaderHeight = 0
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.separatorColor = .none
    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = false
    tableView.showsVerticalScrollIndicator = false
    tableView.showsHorizontalScrollIndicator = false
    tableView.scrollsToTop = false
    tableView.register(
      SimplePickerTableViewCell.classForCoder(), forCellReuseIdentifier: pickerViewCellIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(tableView)

    NSLayoutConstraint.activate([
      tableView.heightAnchor.constraint(equalTo: heightAnchor),
      tableView.widthAnchor.constraint(equalTo: widthAnchor),
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  private func setupSelectionViewsVisibility() {
    switch selectionStyle {
    case .defaultIndicator:
      defaultSelectionIndicator.alpha = 1.0
      selectionOverlay.alpha = 0.0
      selectionImageView.alpha = 0.0

    case .overlay:
      selectionOverlay.alpha = 0.25
      defaultSelectionIndicator.alpha = 0.0
      selectionImageView.alpha = 0.0

    case .image:
      selectionImageView.alpha = 1.0
      selectionOverlay.alpha = 0.0
      defaultSelectionIndicator.alpha = 0.0

    case .none:
      selectionOverlay.alpha = 0.0
      defaultSelectionIndicator.alpha = 0.0
      selectionImageView.alpha = 0.0
    }
  }

  private func setupSelectionOverlay() {
    selectionOverlay.isUserInteractionEnabled = false
    selectionOverlay.translatesAutoresizingMaskIntoConstraints = false
    addSubview(selectionOverlay)

    selectionOverlayH = selectionOverlay.heightAnchor.constraint(equalToConstant: rowHeight)

    NSLayoutConstraint.activate([
      selectionOverlayH,
      selectionOverlay.widthAnchor.constraint(equalTo: widthAnchor),
      selectionOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
      selectionOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
      selectionOverlay.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  private func setupSelectionImageView() {
    selectionImageView.isUserInteractionEnabled = false
    selectionImageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(selectionImageView)

    selectionImageH = selectionImageView.heightAnchor.constraint(equalToConstant: rowHeight)

    NSLayoutConstraint.activate([
      selectionImageH,
      selectionImageView.widthAnchor.constraint(equalTo: widthAnchor),
      selectionImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      selectionImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      selectionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  private func setupDefaultSelectionIndicator() {
    defaultSelectionIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(defaultSelectionIndicator)

    selectionIndicatorB = defaultSelectionIndicator.bottomAnchor.constraint(
      equalTo: centerYAnchor, constant: rowHeight / 2)

    NSLayoutConstraint.activate([
      defaultSelectionIndicator.heightAnchor.constraint(equalToConstant: 2.0),
      defaultSelectionIndicator.widthAnchor.constraint(equalTo: widthAnchor),
      defaultSelectionIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
      selectionIndicatorB,
      defaultSelectionIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  private func generateInfinityRowsMultiplier() -> Int {
    if scrollingStyle == .default {
      return 1
    }

    if numberOfRowsByDataSource > 100 {
      return 100
    } else if numberOfRowsByDataSource < 100, numberOfRowsByDataSource > 50 {
      return 200
    } else if numberOfRowsByDataSource < 50, numberOfRowsByDataSource > 25 {
      return 400
    } else {
      return 800
    }
  }

  private func adjustSelectionOverlayHeightConstraint() {
    if selectionOverlayH.constant != rowHeight || selectionImageH.constant != rowHeight
      || selectionIndicatorB.constant != (rowHeight / 2)
    {
      selectionOverlayH.constant = rowHeight
      selectionImageH.constant = rowHeight
      selectionIndicatorB.constant = -(rowHeight / 2)
      layoutIfNeeded()
    }
  }

  private func indexForRow(_ row: Int) -> Int {
    row % (numberOfRowsByDataSource > 0 ? numberOfRowsByDataSource : 1)
  }

  private func selectedNearbyToMiddleRow(_ row: Int) {
    currentSelectedRow = row
    tableView.reloadData()
    tableView.contentInset = UIEdgeInsets.zero

    let indexOfSelectedRow = visibleIndexOfSelectedRow()
    tableView.setContentOffset(
      CGPoint(x: 0.0, y: CGFloat(indexOfSelectedRow) * rowHeight), animated: false)

    delegate?.pickerComponent(self, didSelectRow: currentSelectedRow)
    shouldSelectNearbyToMiddleRow = false
  }

  private func selectTappedRow(_ row: Int) {
    delegate?.pickerComponent(self, didTapRow: indexForRow(row))
    selectRow(row, animated: true)
  }

  private func turnPickerViewOn() {
    tableView.isScrollEnabled = true
    setupSelectionViewsVisibility()
  }

  private func turnPickerViewOff() {
    tableView.isScrollEnabled = false
    selectionOverlay.alpha = 0.0
    defaultSelectionIndicator.alpha = 0.0
    selectionImageView.alpha = 0.0
  }

  private func visibleIndexOfSelectedRow() -> Int {
    let middleMultiplier =
      scrollingStyle == .infinite ? (infinityRowsMultiplier / 2) : infinityRowsMultiplier
    let middleIndex = numberOfRowsByDataSource * middleMultiplier
    let indexForSelectedRow: Int

    if currentSelectedRow != nil, scrollingStyle == .default, currentSelectedRow == 0 {
      indexForSelectedRow = 0
    } else if currentSelectedRow != nil {
      indexForSelectedRow = middleIndex - (numberOfRowsByDataSource - currentSelectedRow)
    } else {
      let middleRow = Int(floor(Float(indexesByDataSource) / 2.0))
      indexForSelectedRow = middleIndex - (numberOfRowsByDataSource - middleRow)
    }

    return indexForSelectedRow
  }
}

// MARK: - SimplePickerTableViewCell

private class SimplePickerTableViewCell: UITableViewCell {
  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(
      frame: CGRect(
        x: 0.0,
        y: 0.0,
        width: self.contentView.frame.width,
        height: self.contentView.frame.height))
    titleLabel.textAlignment = .center
    return titleLabel
  }()

  var customView: UIView?
}

// MARK: - UITableViewDataSource

extension PickerComponent: UITableViewDataSource {

  public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    let numberOfRows = numberOfRowsByDataSource * infinityRowsMultiplier

    if shouldSelectNearbyToMiddleRow, numberOfRows > 0 {
      if isScrolling {
        let middleRow = Int(floor(Float(indexesByDataSource) / 2.0))
        selectedNearbyToMiddleRow(middleRow)
      } else {
        let rowToSelect =
          currentSelectedRow != nil
          ? currentSelectedRow : Int(floor(Float(indexesByDataSource) / 2.0))
        selectedNearbyToMiddleRow(rowToSelect!)
      }
    }

    if numberOfRows > 0 {
      turnPickerViewOn()
    } else {
      turnPickerViewOff()
    }

    return numberOfRows
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let indexOfSelectedRow = visibleIndexOfSelectedRow()

    let pickerViewCell =
      tableView.dequeueReusableCell(
        withIdentifier: pickerViewCellIdentifier,
        for: indexPath) as! SimplePickerTableViewCell

    let view = delegate?.pickerComponent(
      self,
      viewForRow: indexForRow(indexPath.row),
      highlighted: indexPath.row == indexOfSelectedRow,
      reusingView: pickerViewCell.customView)

    pickerViewCell.selectionStyle = .none
    pickerViewCell.backgroundColor = pickerCellBackgroundColor ?? UIColor.white

    if let view = view {
      let frameY = indexPath.row == 0 ? (frame.height / 2) - (rowHeight / 2) : 0.0
      view.frame = CGRect(x: 0.0, y: frameY, width: frame.width, height: rowHeight)
      pickerViewCell.customView = view
      pickerViewCell.contentView.addSubview(pickerViewCell.customView!)
    } else {
      let centerY = indexPath.row == 0 ? (frame.height / 2) - (rowHeight / 2) : 0.0
      pickerViewCell.titleLabel.frame = CGRect(
        x: 0.0, y: centerY, width: frame.width, height: rowHeight)
      pickerViewCell.contentView.addSubview(pickerViewCell.titleLabel)
      pickerViewCell.titleLabel.backgroundColor = UIColor.clear
      pickerViewCell.titleLabel.text = dataSource?.pickerComponent(
        self,
        titleForRow: indexForRow(indexPath.row))

      delegate?.pickerComponent(
        self,
        styleForLabel: pickerViewCell.titleLabel,
        highlighted: indexPath.row == indexOfSelectedRow)
    }

    return pickerViewCell
  }
}

// MARK: - UITableViewDelegate

extension PickerComponent: UITableViewDelegate {

  public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectTappedRow(indexPath.row)
  }

  public func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let numberOfRowsInPickerView =
      dataSource!.pickerComponentNumberOfRows(self) * infinityRowsMultiplier

    if indexPath.row == 0 {
      return (frame.height / 2) + (rowHeight / 2)
    } else if numberOfRowsInPickerView > 0, indexPath.row == numberOfRowsInPickerView - 1 {
      return (frame.height / 2) + (rowHeight / 2)
    }

    return rowHeight
  }
}

// MARK: - UIScrollViewDelegate

extension PickerComponent: UIScrollViewDelegate {

  public func scrollViewWillBeginDragging(_: UIScrollView) {
    isScrolling = true
  }

  public func scrollViewWillEndDragging(
    _: UIScrollView,
    withVelocity _: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let partialRow = Float(targetContentOffset.pointee.y / rowHeight)
    var roundedRow = Int(lroundf(partialRow))

    if roundedRow < 0 {
      roundedRow = 0
    } else {
      targetContentOffset.pointee.y = CGFloat(roundedRow) * rowHeight
    }

    currentSelectedRow = indexForRow(roundedRow)
    delegate?.pickerComponent(self, didSelectRow: currentSelectedRow)
  }

  public func scrollViewDidEndDecelerating(_: UIScrollView) {
    if orientationChanged {
      selectedNearbyToMiddleRow(currentSelectedRow)
      orientationChanged = false
    }

    isScrolling = false
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let partialRow = Float(scrollView.contentOffset.y / rowHeight)
    let roundedRow = Int(lroundf(partialRow))

    if let visibleRows = tableView.indexPathsForVisibleRows {
      for indexPath in visibleRows {
        if let cellToUnhighlight = tableView.cellForRow(at: indexPath)
          as? SimplePickerTableViewCell,
          indexPath.row != roundedRow
        {
          let _ = delegate?.pickerComponent(
            self,
            viewForRow: indexForRow(indexPath.row),
            highlighted: false,
            reusingView: cellToUnhighlight.customView)
          delegate?.pickerComponent(
            self, styleForLabel: cellToUnhighlight.titleLabel, highlighted: false)
        }
      }
    }

    if let cellToHighlight = tableView.cellForRow(at: IndexPath(row: roundedRow, section: 0))
      as? SimplePickerTableViewCell
    {
      let _ = delegate?.pickerComponent(
        self,
        viewForRow: indexForRow(roundedRow),
        highlighted: true,
        reusingView: cellToHighlight.customView)
      let _ = delegate?.pickerComponent(
        self, styleForLabel: cellToHighlight.titleLabel, highlighted: true)
    }
  }
}
