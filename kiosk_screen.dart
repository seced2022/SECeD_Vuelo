import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'vdo_webview.dart';

class KioskScreen extends StatefulWidget {
  const KioskScreen({super.key});

  @override
  State<KioskScreen> createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen> {
  final _controller = TextEditingController();
  String _error;

  // Cambia esto si en el futuro usas tu propio dominio (wrapper).
  static const String _base = "https://vdo.ninja/";

  String _normalizeId(String raw) => raw.trim();

  bool _isValidId(String id) {
    // 3..64 chars; letras/números/guion/underscore
    final re = RegExp(r'^[a-zA-Z0-9_-]{3,64}$');
    return re.hasMatch(id);
  }

  String _pushUrl(String id) =>
      "$_base?push=$id&screenshare&autostart&hideheader";

  String _viewUrl(String id) =>
      "$_base?view=$id&cleanviewer&hideheader";

  void _startShare() {
    final id = _normalizeId(_controller.text);
    if (!_isValidId(id)) {
      setState(() => _error = "ID inválido (usa letras/números, _ o -)");
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VdoWebView(
          title: "Compartir pantalla",
          initialUrl: _pushUrl(id),
        ),
      ),
    );
  }

  void _openViewerPreview() {
    final id = _normalizeId(_controller.text);
    if (!_isValidId(id)) {
      setState(() => _error = "ID inválido (usa letras/números, _ o -)");
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VdoWebView(
          title: "Vista (visor)",
          initialUrl: _viewUrl(id),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.text = "EMPRESA123"; // Cambia el valor por defecto si quieres
    _controller.addListener(() {
      final id = _normalizeId(_controller.text);
      setState(() {
        _error = _isValidId(id) ? null : "ID inválido (usa letras/números, _ o -)";
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = _normalizeId(_controller.text);
    final valid = _isValidId(id);
    final viewUrl = valid ? _viewUrl(id) : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Si quieres logo: añade assets/logo.png y usa Image.asset(...)
                  const Icon(Icons.business, size: 72),
                  const SizedBox(height: 12),
                  const Text(
                    "Compartir pantalla",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),

                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Push ID",
                      hintText: "Ej: EMPRESA123",
                      errorText: _error,
                      border: const OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _startShare(),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: valid ? _startShare : null,
                      child: const Text(
                        "Compartir pantalla",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: valid ? _openViewerPreview : null,
                      child: const Text("Previsualizar visor (opcional)"),
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (viewUrl != null) ...[
                    const Text(
                      "Escanea este QR en el PC/visor:",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    QrImageView(
                      data: viewUrl,
                      size: 220,
                      gapless: false,
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      viewUrl,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
