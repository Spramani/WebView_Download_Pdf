//
//  ViewController.swift
//  WebView_Download_Pdf
//
//  Created by Adsum MAC 2 on 11/05/21.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController,UIScrollViewDelegate, URLSessionDelegate
{
    
    
    @IBOutlet weak var Web: WKWebView!
    
    var urlString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.Web.scrollView.delegate = self
//        self.Web.navigationDelegate = self
        Web.scrollView.isScrollEnabled = true
        
        
        
        
           let source: String = "var meta = document.createElement('meta');" +
               "meta.name = 'viewport';" +
               "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
               "var head = document.getElementsByTagName('head')[0];" +
               "head.appendChild(meta);"
           let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
           let userContentController: WKUserContentController = WKUserContentController()
           let configuration = WKWebViewConfiguration()
           let preferences = WKPreferences()
           
           
           preferences.javaScriptEnabled = true
           preferences.javaScriptCanOpenWindowsAutomatically = true
           configuration.preferences = preferences
           configuration.userContentController = userContentController
           userContentController.addUserScript(script)
           
           
           let web2 = WKWebView(frame: .zero, configuration: configuration)
            web2.frame = self.view.frame
           self.view.addSubview(web2)
//           web2.translatesAutoresizingMaskIntoConstraints = false
//           NSLayoutConstraint.activate([web2.topAnchor.constraint(equalTo: view.bottomAnchor),web2.leftAnchor.constraint(equalTo: self.view.leftAnchor),web2.rightAnchor.constraint(equalTo: self.view.rightAnchor),web2.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])

           
           if let url = URL(string: urlString!) {
               let urlRequest = URLRequest(url: url)
               web2.load(urlRequest)
           }
           web2.uiDelegate = self
           web2.scrollView.isScrollEnabled = true
        
       
        setupWebView()
        loadWebView()
    }
    
    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        Web.uiDelegate = self
    }
    
    func loadWebView() {
        if let url = URL(string: "https://schoolapp.neverskip.com/exapp/#/reptexam_v1/2197/193109/163") // Enter Web url
        {
            let urlRequest = URLRequest(url: url)
            Web.load(urlRequest)
        }
    }
    
    
    
    
    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.contentSize = .zero
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.subviews.forEach { subview in
            subview.gestureRecognizers?.forEach { recognizer in
                if let tapRecognizer = recognizer as? UITapGestureRecognizer,
                    tapRecognizer.numberOfTapsRequired == 2 && tapRecognizer.numberOfTouchesRequired == 1 {
                    subview.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
}


extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        openLinkInSafari(withURLString: "\(String(describing: navigationAction.request.url!))")
  
        return nil
    }
    func openLinkInSafari(withURLString link: String) {

        guard let url = NSURL(string: link) else {
            print("INVALID URL")
            return
        }

        /// Test for valid scheme & append "http" if needed
        if !(["http", "https"].contains(url.scheme?.localizedLowercase)) {
//            let appendedLink = "http://".stringByAppendingPathComponent(path: link)
//
//            url = NSURL(string: appendedLink)!
        }
        UIApplication.shared.open(url as URL)

    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
          if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url{
               
                  print(url)
                  print("Redirected to browser. No need to open it locally")
                  decisionHandler(.cancel)
              } else {
                  print("Open it locally")
                  decisionHandler(.allow)
              }
          } else {
              print("not a user click")
              decisionHandler(.allow)
          }
      }
}
