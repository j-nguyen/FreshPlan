//
//  AppDelegate.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import MaterialComponents
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// set up the window size
		window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = self.window else { fatalError("no window") }
    // prepare fabric
    prepareFabric()
		// setup window to make sure
		// check to make sure if token exists or not
    window.makeKeyAndVisible()
    window.backgroundColor = .white
		if let _ = UserDefaults.standard.string(forKey: "token"), let jwt = Token.decodeJWT {
      if jwt.expired {
        let alertController = MDCAlertController(title: "Login Expired", message: "Your login credentials have expired. Please log back in.")
        let action = MDCAlertAction(title: "OK", handler: { _ in
          UserDefaults.standard.removeObject(forKey: "token")
        })
        alertController.addAction(action)
        window.rootViewController = LoginAssembler.make()
        window.rootViewController?.present(alertController, animated: true)
      } else {
        window.rootViewController = HomeAssembler.make()
      }
		} else {
			window.rootViewController = LoginAssembler.make()
		}
		
		return true
	}
  
  private func prepareFabric() {
    #if DEBUG
      Fabric.with([Crashlytics.self])
    #endif
  }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

