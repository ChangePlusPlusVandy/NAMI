//
//  ChatUnavailableView.swift
//  NAMI
//
//  Created by Sophie Zhuang on 1/2/25.
//

import SwiftUI
import MessageUI
import UIKit

struct ChatUnavailableView: View {
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    let phoneNumber = 988
    @State var openMessages = false
     
    private let messageComposeDelegate = MessageDelegate()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.snappy) { isPresented.toggle() }
                }

            VStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 30) {
                    Text("Oh no, you’re reaching NAMI’s helpline outside of office hours")
                        .font(.title3)
                        .bold()

                    VStack(spacing: 10) {
                        Text("If you are experiencing a mental health crisis during this time, please call or text 988")
                            .font(.callout)

                        Text("The 988 Suicide & Crisis Lifeline is available 24/7")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }

                HStack (alignment: .bottom, spacing: 15) {
                    Link("Call", destination: URL(string: "tel://\(phoneNumber)")!)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    
                    Button {
                        self.presentMessageCompose()
                    } label: {
                        Text("Text")
                    }
                        
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    Button {
                        withAnimation (.snappy) { isPresented.toggle() }
                    } label: {
                        Text("Dismiss")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.NAMIDarkBlue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(20)
            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
}

// MARK: The message part
extension ChatUnavailableView { //https://medium.com/@florentmorin/messageui-swiftui-and-uikit-integration-82d91159b0bd

    /// Delegate for view controller as `MFMessageComposeViewControllerDelegate`
    private class MessageDelegate: NSObject, MFMessageComposeViewControllerDelegate {
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            // Customize here
            controller.dismiss(animated: true)
        }

    }

    /// Present an message compose view controller modally in UIKit environment
    private func presentMessageCompose() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let vc = UIApplication.shared.keyWindow?.rootViewController

        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = messageComposeDelegate


        vc?.present(composeVC, animated: true)
    }
}
extension UIViewController {

    /// Top most view controller in view hierarchy
    var topMostViewController: UIViewController {

        // No presented view controller? Current controller is the most view controller
        guard let presentedViewController = self.presentedViewController else {
            return self
        }

        // Presenting a navigation controller?
        // Top most view controller is in visible view controller hierarchy
        if let navigation = presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController
            } else {
                return navigation.topMostViewController
            }
        }

        // Presenting a tab bar controller?
        // Top most view controller is in visible view controller hierarchy
        if let tabBar = presentedViewController as? UITabBarController {
            if let selectedTab = tabBar.selectedViewController {
                return selectedTab.topMostViewController
            } else {
                return tabBar.topMostViewController
            }
        }

        // Presenting another kind of view controller?
        // Top most view controller is in visible view controller hierarchy
        return presentedViewController.topMostViewController
    }

}

extension UIWindow {

    /// Top most view controller in view hierarchy
    /// - Note: Wrapper to UIViewController.topMostViewController
    var topMostViewController: UIViewController? {
        return self.rootViewController?.topMostViewController
    }

}

extension UIApplication {

    /// Top most view controller in view hierarchy
    /// - Note: Wrapper to UIWindow.topMostViewController
    var topMostViewController: UIViewController? {
        return self.keyWindow?.topMostViewController
    }
}


#Preview {
    ChatUnavailableView(isPresented: .constant(true))
}



