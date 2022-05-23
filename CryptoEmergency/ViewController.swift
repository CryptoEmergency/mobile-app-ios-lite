

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, UIWebViewDelegate, UIScrollViewDelegate {
    
    let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.uiDelegate = self 
        webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        let url = URL(string: "https://crypto-emergency.com/ru/")!
        let webSite = URLRequest(url: url)
        webView.scrollView.delegate = self
        
        webView.load(webSite)
        
        view.addSubview(webView)
        
        setupWebViewScreen()
    }
    
    func setupWebViewScreen() {
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }

      func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
      }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard
            let url = navigationAction.request.url,
            let scheme = url.scheme else {
                decisionHandler(.cancel)
                return
        }

        if (scheme.lowercased() == "mailto") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        if (url.description.contains("https://dashboard.crypto-emergency.com/login")) {

            webView.scrollView.isScrollEnabled = false
            webView.scrollView.bouncesZoom = false
        } else {
            webView.scrollView.isScrollEnabled = true
            webView.scrollView.bouncesZoom = true
        }
        if (url.description.contains("https://t.me/")) {
            UIApplication.shared.open(URL(string: url.description.replacingOccurrences(of: "https://t.me/", with: "tg://resolve?domain="))!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
