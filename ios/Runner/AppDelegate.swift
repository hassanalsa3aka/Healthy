import UIKit
import Flutter
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.proviedAPIKey("AIzaSyCudB3bN77J_KYintlaDdyKkuf6YeTeGUU")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
