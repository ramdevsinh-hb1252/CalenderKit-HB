import UIKit
//import DateToolsSwift

class DateLabel: UILabel, DaySelectorItemProtocol {
  var calendar = Calendar.autoupdatingCurrent {
    didSet {
      updateState()
    }
  }

  var date = Date() {
    didSet {
      text = String(date.day)
      updateState()
    }
  }

  private var isToday: Bool {
    return calendar.isDateInToday(date)
  }

  var selected: Bool = false {
    didSet {
      animate()
    }
  }

  var style = DaySelectorStyle()

  override var intrinsicContentSize: CGSize {
    return CGSize(width: 35, height: 35)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  func configure() {
    isUserInteractionEnabled = true
    textAlignment = .center
    clipsToBounds = true
  }

  func updateStyle(_ newStyle: DaySelectorStyle) {
    style = newStyle
    updateState()
  }

  func updateState() {
    text = String(component(component: .day, from: date))
    let today = isToday
    if selected {
      font = style.todayFont
      textColor = today ? style.todayActiveTextColor : style.activeTextColor
      backgroundColor = today ? style.todayActiveBackgroundColor : style.selectedBackgroundColor
    } else {
      let notTodayColor = isAWeekend(date: date) ? style.weekendTextColor : style.inactiveTextColor
      font = style.font
      textColor = today ? style.todayInactiveTextColor : notTodayColor
      backgroundColor = style.inactiveBackgroundColor
    }
  }

  private func component(component: Calendar.Component, from date: Date) -> Int {
    return calendar.component(component, from: date)
  }

  private func isAWeekend(date: Date) -> Bool {
    let weekday = component(component: .weekday, from: date)
    if weekday == 7 || weekday == 1 {
      return true
    }
    return false
  }

  func animate(){
    UIView.transition(with: self,
                      duration: 0.4,
                      options: .transitionCrossDissolve,
                      animations: {
                        self.updateState()
    }, completion: nil)
  }

  override func layoutSubviews() {
    layer.cornerRadius = bounds.height / 2
  }
  override func tintColorDidChange() {
    updateState()
  }
}
