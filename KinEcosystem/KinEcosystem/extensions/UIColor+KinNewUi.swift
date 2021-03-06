#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

extension Color {
	struct KinNewUi {
		static let black = Color(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1)
		static let white = Color(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
		static let bluishPurple = Color(red: 111/255.0, green: 65/255.0, blue: 232/255.0, alpha: 1)
		static let tealish = Color(red: 29/255.0, green: 194/255.0, blue: 164/255.0, alpha: 1)
		static let whiteTwo = Color(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
		static let brownGray = Color(red: 166/255.0, green: 166/255.0, blue: 166/255.0, alpha: 1)
        static let darkishPink = Color(red: 219/255.0, green: 73/255.0, blue: 123/255.0, alpha: 1)
        static let mercuryGray = Color(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
		static let veryLightPink = Color(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
		static let blackTwo = Color(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1)
        static let errorRed = Color.red
	}
}
