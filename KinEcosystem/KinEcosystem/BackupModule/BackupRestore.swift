//
//  BackupRestore.swift
//  KinEcosystem
//
//  Created by Elazar Yifrach on 15/10/2018.
//  Copyright © 2018 Kik Interactive. All rights reserved.
//

import KinUtil

public protocol KeystoreProvider {
    func exportAccount(_ password: String) throws -> String
    func importAccount(keystore: String, password: String, completion: @escaping (Error?) -> ())
    func validatePassword(_ password: String) -> Bool
}

public typealias BRCompletionHandler = (_ success: Bool) -> ()

public enum BRPhase {
    case backup
    case restore
}

public enum BREvent {
    case backup(BREventType)
    case restore(BREventType)
}

public enum BREventType {
    case done
    case cancel
}

private enum BRPresentationType {
    case pushed
    case presented
}

private struct BRInstance {
    let presentationType: BRPresentationType
    let flowController: FlowController
    let completion: BRCompletionHandler
}

@available(iOS 9.0, *)
public class BRManager: NSObject {
    private let storeProvider: KeystoreProvider
    private var presentor: UIViewController?
    private var brInstance: BRInstance?
    
    public init(with storeProvider: KeystoreProvider) {
        self.storeProvider = storeProvider
    }
    
    /**
     Start a backup or recovery phase by pushing the view controllers onto a navigation controller.
     
     If the navigation controller has a `topViewController`, then the stack will be popped to that
     view controller upon completion. Otherwise it's up to the user to perform the final navigation.
     
     - Parameter phase: Perform a backup or restore
     - Parameter navigationController: The navigation controller being pushed onto
     - Parameter completion:
     */
    @available(*, deprecated, message: "use instead `start(_ phase: presentedOn: completion:)`")
    public func start(_ phase: BRPhase,
                      pushedOnto navigationController: UINavigationController,
                      completion: @escaping BRCompletionHandler)
    {
        guard brInstance == nil else {
            completion(false)
            return
        }
        
        let isStackEmpty = navigationController.viewControllers.isEmpty
        
        let flowController = createFlowController(phase: phase, keystoreProvider: storeProvider, navigationController: navigationController)
        navigationController.pushViewController(flowController.entryViewController, animated: !isStackEmpty)
        
        brInstance = BRInstance(presentationType: .pushed, flowController: flowController, completion: completion)
    }
    
    /**
     Start a backup or recovery phase by presenting the navigation controller onto a view controller.
     
     - Parameter phase: Perform a backup or restore
     - Parameter viewController: The view controller being presented onto
     - Parameter completion:
     */
    public func start(_ phase: BRPhase,
                      presentedOn viewController: UIViewController,
                      completion: @escaping BRCompletionHandler)
    {
        guard brInstance == nil else {
            completion(false)
            return
        }
        
        let navigationController = ThemedNavigationController()
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        let flowController = createFlowController(phase: phase, keystoreProvider: storeProvider, navigationController: navigationController)
        let dismissItem = UIBarButtonItem(barButtonSystemItem: .stop, target: flowController, action: #selector(flowController.cancelFlow))
        flowController.entryViewController.navigationItem.leftBarButtonItem = dismissItem
        navigationController.viewControllers = [flowController.entryViewController]
        viewController.present(navigationController, animated: true)
        
        brInstance = BRInstance(presentationType: .presented, flowController: flowController, completion: completion)
        presentor = viewController
    }
    
    private func createFlowController(phase: BRPhase, keystoreProvider: KeystoreProvider, navigationController: UINavigationController) -> FlowController {
        let controller: FlowController
        
        switch phase {
        case .backup:
            controller = BackupFlowController(keystoreProvider: storeProvider, navigationController: navigationController)
        case .restore:
            controller = RestoreFlowController(keystoreProvider: storeProvider, navigationController: navigationController)
        }
        
        controller.delegate = self
        return controller
    }
}

// MARK: - Navigation

@available(iOS 9.0, *)
extension BRManager {
    private var navigationController: UINavigationController? {
        return brInstance?.flowController.navigationController
    }
    
    private func dismissFlow() {
        presentor?.dismiss(animated: true)
    }
    
    private func popNavigationStackIfNeeded() {
        guard let flowController = brInstance?.flowController else {
            return
        }
        
        let navigationController = flowController.navigationController
        let entryViewController = flowController.entryViewController
        
        guard let index = navigationController.viewControllers.index(of: entryViewController) else {
            return
        }
        
        if index > 0 {
            let externalViewController = navigationController.viewControllers[index - 1]
            navigationController.popToViewController(externalViewController, animated: true)
        }
    }
}

// MARK: - Flow

@available(iOS 9.0, *)
extension BRManager: FlowControllerDelegate {
    func flowControllerDidComplete(_ controller: FlowController) {
        guard let brInstance = brInstance else {
            return
        }
        
        brInstance.completion(true)
        
        switch brInstance.presentationType {
        case .presented:
            dismissFlow()
        case .pushed:
            popNavigationStackIfNeeded()
        }
        
        self.brInstance = nil
    }
    
    func flowControllerDidCancel(_ controller: FlowController) {
        guard let brInstance = brInstance else {
            return
        }
        
        brInstance.completion(false)
        
        switch brInstance.presentationType {
        case .presented:
            dismissFlow()
        case .pushed:
            break
        }
        
        self.brInstance = nil
    }
}
