import SwiftUI
import WebKit

struct WebAppView: UIViewRepresentable {
    private let targetURL = URL(string: "https://www.ea.com/ea-sports-fc/ultimate-team/web-app")!

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        if let js = loadAndSanitizeBookmarklet(named: "funzione", ext: "js") {
            let userScript = WKUserScript(source: js,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)
            contentController.addUserScript(userScript)
        }

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.preferences.javaScriptEnabled = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.bounces = false
        webView.load(URLRequest(url: targetURL))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    private func loadAndSanitizeBookmarklet(named: String, ext: String) -> String? {
        guard let path = Bundle.main.path(forResource: named, ofType: ext),
              var src = try? String(contentsOfFile: path, encoding: .utf8) else { return nil }
        if src.hasPrefix("javascript:") {
            src.removeFirst("javascript:".count)
        }
        return src
    }
}
