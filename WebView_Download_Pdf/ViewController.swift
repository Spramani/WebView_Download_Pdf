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
        if let url = URL(string: "") // Enter Web url 
        {
            let urlRequest = URLRequest(url: url)
            Web.load(urlRequest)
        }
    }
    
    
    
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
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
