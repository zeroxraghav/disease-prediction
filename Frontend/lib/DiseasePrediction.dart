import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SymptomSelectionScreen extends StatefulWidget {
  const SymptomSelectionScreen({super.key, required this.title});
  final String title;

  @override
  _SymptomSelectionScreenState createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen> {
  final List<String> symptoms = [
    'weight_loss', 'nausea', 'back_pain', 'yellowing_of_eyes', 'redness_of_eyes',
    'neck_pain', 'brittle_nails', 'hip_joint_pain', 'movement_stiffness', 'unsteadiness',
    'continuous_feel_of_urine', 'internal_itching', 'depression', 'muscle_pain',
    'altered_sensorium', 'red_spots_over_body', 'belly_pain', 'abnormal_menstruation',
    'dischromic _patches', 'increased_appetite', 'rusty_sputum', 'lack_of_concentration',
    'fluid_overload.1', 'blood_in_sputum', 'prominent_veins_on_calf', 'palpitations',
    'silver_like_dusting', 'yellow_crust_ooze',
  ];

  final Map<String, bool> selectedSymptoms = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var symptom in symptoms) {
      selectedSymptoms[symptom] = false;
    }
  }

  Future<void> submitSymptoms() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, int> symptomData = {
      for (var entry in selectedSymptoms.entries) entry.key: entry.value ? 1 : 0
    };

    final payload = {'input_data': symptomData};

    try {
      final response = await http.post(
        Uri.parse('https://api-deploy-6wmx.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final result = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Diagnosis Result'),
          content: Text(result['prediction'].toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to get prediction. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Select your symptoms",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: symptoms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  String symptom = symptoms[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      title: Text(
                        symptom.replaceAll('_', ' ').replaceAll('.1', ''),
                        style: const TextStyle(fontSize: 16),
                      ),
                      value: selectedSymptoms[symptom],
                      onChanged: (val) {
                        setState(() {
                          selectedSymptoms[symptom] = val ?? false;
                        });
                      },
                      secondary: const Icon(Icons.health_and_safety, color: Colors.teal),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.medical_services_outlined),
                    label: const Text(
                      'Predict Disease',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: _isLoading ? null : submitSymptoms,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}