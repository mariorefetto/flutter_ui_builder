import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    // The editor docks several panels, so it opens large and stays usable.
    let windowFrame = NSRect(
      x: self.frame.origin.x,
      y: self.frame.origin.y,
      width: 1440,
      height: 900
    )
    self.minSize = NSSize(width: 1000, height: 640)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
