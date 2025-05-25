class LocationService {
  // This is a simplified version for demonstration
  // In a real app, you would use a geocoding API or service

  // Get approximate coordinates for a city and country
  // This is a very simplified implementation with a few major cities
  static Map<String, double> getCoordinates(String city, String country) {
    // Default coordinates (0,0) if location not found
    double latitude = 0.0;
    double longitude = 0.0;

    // Normalize input for comparison
    final String normalizedCity = city.trim().toLowerCase();
    final String normalizedCountry = country.trim().toLowerCase();

    // Map of major cities and their coordinates
    final Map<String, Map<String, double>> cityCoordinates = {
      'new york-usa': {'lat': 40.7128, 'lng': -74.0060},
      'london-uk': {'lat': 51.5074, 'lng': -0.1278},
      'paris-france': {'lat': 48.8566, 'lng': 2.3522},
      'tokyo-japan': {'lat': 35.6762, 'lng': 139.6503},
      'sydney-australia': {'lat': -33.8688, 'lng': 151.2093},
      'rio de janeiro-brazil': {'lat': -22.9068, 'lng': -43.1729},
      'cape town-south africa': {'lat': -33.9249, 'lng': 18.4241},
      'moscow-russia': {'lat': 55.7558, 'lng': 37.6173},
      'beijing-china': {'lat': 39.9042, 'lng': 116.4074},
      'mumbai-india': {'lat': 19.0760, 'lng': 72.8777},
      'cairo-egypt': {'lat': 30.0444, 'lng': 31.2357},
      'los angeles-usa': {'lat': 34.0522, 'lng': -118.2437},
      'berlin-germany': {'lat': 52.5200, 'lng': 13.4050},
      'rome-italy': {'lat': 41.9028, 'lng': 12.4964},
      'toronto-canada': {'lat': 43.6532, 'lng': -79.3832},
      'mexico city-mexico': {'lat': 19.4326, 'lng': -99.1332},
      'delhi-india': {'lat': 28.7041, 'lng': 77.1025},
      'bangkok-thailand': {'lat': 13.7563, 'lng': 100.5018},
      'singapore-singapore': {'lat': 1.3521, 'lng': 103.8198},
      'istanbul-turkey': {'lat': 41.0082, 'lng': 28.9784},
    };

    // Try to find the city-country pair
    final String key = '$normalizedCity-$normalizedCountry';
    if (cityCoordinates.containsKey(key)) {
      latitude = cityCoordinates[key]!['lat']!;
      longitude = cityCoordinates[key]!['lng']!;
    } else {
      // If exact match not found, try to find just the city
      for (final entry in cityCoordinates.entries) {
        if (entry.key.startsWith(normalizedCity)) {
          latitude = entry.value['lat']!;
          longitude = entry.value['lng']!;
          break;
        }
      }
    }

    return {'latitude': latitude, 'longitude': longitude};
  }
}
