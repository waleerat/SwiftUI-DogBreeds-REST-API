
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   var window: UIWindow?
    @AppStorage("isPortrait") private var isPortrait: Bool = false

   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      if let windowScene = scene as? UIWindowScene {
         self.isPortrait = getOrientation(scene: windowScene)
      }
    
   }
    
   func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        
        self.isPortrait = getOrientation(scene: windowScene)
    
   }
    
   func getOrientation(scene: UIWindowScene) -> Bool {
      let interfaceOrientation = scene.interfaceOrientation
      if interfaceOrientation == .portrait || interfaceOrientation == .portraitUpsideDown {
         return true
      }
      return false
   }
}
