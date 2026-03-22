import 'package:flutter/material.dart';
import 'package:sports_betting_app/core/constants/app_constants.dart';

/// Ekran Tèm ak Kondisyon: règleman ak kondisyon itilizasyon aplikasyon an.
class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBg,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBg,
        elevation: 0,
        title: const Text(
          'Tèm ak Kondisyon',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('1. Akseptasyon', 'Lè w itilize aplikasyon Li Facil, w aksepte tout tèm ak kondisyon ki nan dokiman sa a.'),
            const SizedBox(height: 20),
            _section('2. Itilizasyon', 'Aplikasyon an rezève pou itilizasyon pèsonèl. Ou pa gen dwa revann, distribye oswa itilize li pou rezon komèsyal san otorizasyon.'),
            const SizedBox(height: 20),
            _section('3. Laj legal', 'Ou dwe gen omwen 18 an pou w itilize sèvis paryaj. Nou rezève dwa pou verifye laj ou.'),
            const SizedBox(height: 20),
            _section('4. Responsabilite', 'Ou responsab pou tout aksyon w nan kont ou. Sèvi ak bous ou ak responsablite.'),
            const SizedBox(height: 20),
            _section('5. Modpas', 'Ou dwe kenbe modpas ou an sekirite. Nou pa responsab si gen pèt akòz aksè ki pa otorize.'),
            const SizedBox(height: 20),
            _section('6. Chanjman', 'Nou kapab modifye tèm sa yo nenpòt ki lè. Itilizasyon kontinye ap vle di w aksepte nouvo tèm yo.'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.primaryGreen.withOpacity(0.3)),
              ),
              child: const Text(
                'Si w gen kesyon sou tèm ak kondisyon yo, kontakte nou nan seksyon "Kontakte Nou".',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppConstants.primaryGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
