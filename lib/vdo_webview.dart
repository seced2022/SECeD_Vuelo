import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VdoWebView extends StatefulWidget {
  final String title;
  final String initialUrl;

  const VdoWebView({
    super.key,
    required this.title,
    required this.initialUrl,
  });

  @override
  State<VdoWebView> createState() => _VdoWebViewState();
}

class _VdoWebViewState extends State<VdoWebView> {
  late final WebViewController _web;

  @override
  void initState() {
    super.initState();
    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: "Recargar",
            onPressed: () => _web.reload(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: "Cerrar",
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: WebViewWidget(controller: _web),
    );
  }
}
