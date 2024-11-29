import 'dart:convert';
import 'package:http/http.dart' as http;

class CropService {
  // The base URL of your API
  final String baseUrl = 'http://localhost:3000/crop'; // Update with your actual API base URL

  // Fetch the list of crops from the API
  Future<List<Map<String, String>>> fetchCrops() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body); // Decode the response body

        // Map the data to a List<Map<String, String>> by converting dynamic to String
        return data.map((crop) {
          return {
            'CropId': crop['cropid'].toString(), // Explicitly cast cropid to String
            'Crop variety': crop['name']?.toString() ?? '',   // Ensure the name is a String, fallback to empty string
            'Quality': crop['quality']?.toString() ?? '',     // Ensure quality is a String, fallback to empty string
            'Status': crop['status']?.toString() ?? '',       // Ensure status is a String, fallback to empty string
            'Planting Date': crop['planting_date']?.toString() ?? '', // Ensure planting date is a String, fallback to empty string
          };
        }).toList();
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      throw Exception('Failed to load crops: $e');
    }
  }
}
