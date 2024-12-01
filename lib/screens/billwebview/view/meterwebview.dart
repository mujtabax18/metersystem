import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MeterWebViewPage extends StatelessWidget {
  final String meterNumber;

  MeterWebViewPage({required this.meterNumber});

  @override
  Widget build(BuildContext context) {
    final url = 'https://bill.pitc.com.pk/mepcobill/general?refno=$meterNumber';

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Show progress
          },
          onPageStarted: (String url) {
            // Optional: Handle when page starts loading
          },
          onPageFinished: (String url) {
            // Optional: Handle when page finishes loading
          },
          onWebResourceError: (WebResourceError error) {
            // Optional: Handle web resource error
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(title: Text('Meter Bill')),
      body: WebViewWidget(controller: controller),
    );
  }
}
