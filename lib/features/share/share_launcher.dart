import 'package:url_launcher/url_launcher.dart';

import '../../data/models.dart';

/// Opens the platform's native app when installed, else its website in the
/// browser. Uses https URLs throughout: externalNonBrowserApplication
/// resolves to the installed app (Android app links), and the browser is the
/// universal fallback.
Future<void> launchPlatform(SharePlatform platform, {String? text}) async {
  final uri = Uri.parse(platform.shareUrl(text));
  final openedApp = await launchUrl(
    uri,
    mode: LaunchMode.externalNonBrowserApplication,
  ).catchError((_) => false);
  if (!openedApp) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((_) => false);
  }
}
