import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> launchUrlString(String url) async {
  if (!await launchUrl(Uri.parse (url))) {
    throw Exception('Could not launch $url');
  }}




void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Copied "$text" to clipboard!')),
  );
}
