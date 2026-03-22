import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';

/// Ekran Kontakte Nou: montre imèl sipò epi pèmèt itilizatè a voye imèl.
class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static const String _supportEmail = 'support@lifacil.com';

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri.parse('mailto:$_supportEmail');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) _showEmailSnackBar(context);
      }
    } catch (_) {
      if (context.mounted) _showEmailSnackBar(context);
    }
  }

  void _showEmailSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kontakte nou: $_supportEmail'),
        backgroundColor: AppConstants.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        title: const Text(
          'Kontakte Nou',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.support_agent,
              size: 64,
              color: AppConstants.primaryGreen,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sipò',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Imèl sipò',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Material(
              color: AppConstants.cardBg,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => _openEmail(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppConstants.primaryGreen.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email_outlined, color: AppConstants.primaryGreen, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        _supportEmail,
                        style: const TextStyle(
                          color: AppConstants.primaryGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Peze imèl la pou voye yon mesaj bay ekip sipò nou.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
