class MapboxResponse {
  final String? type;
  final List<Feature> features;
  final String? attribution;

  MapboxResponse({
    this.type,
    required this.features,
    this.attribution,
  });

  factory MapboxResponse.fromJson(Map<String, dynamic> json) => MapboxResponse(
        type: json["type"],
        features: List<Feature>.from(
            json["features"]!.map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  final String? type;
  final Geometry? geometry;
  final Properties properties;

  Feature({
    this.type,
    this.geometry,
    required this.properties,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "geometry": geometry?.toJson(),
        "properties": properties.toJson(),
      };
}

class Geometry {
  final List<double>? coordinates;
  final String? type;

  Geometry({
    this.coordinates,
    this.type,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
        "type": type,
      };
}

class Properties {
  final String? name;
  final String? mapboxId;
  final String? featureType;
  final String? placeFormatted;
  final Context context;
  final Coordinates? coordinates;
  final String? language;
  final String? maki;
  final Metadata? metadata;
  final String? namePreferred;
  final List<double>? bbox;
  final String? fullAddress;

  Properties({
    this.name,
    this.mapboxId,
    this.featureType,
    this.placeFormatted,
    required this.context,
    this.coordinates,
    this.language,
    this.maki,
    this.metadata,
    this.namePreferred,
    this.bbox,
    this.fullAddress,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        name: json["name"],
        mapboxId: json["mapbox_id"],
        fullAddress: json["full_address"],
        featureType: json["feature_type"],
        placeFormatted: json["place_formatted"],
        context: Context.fromJson(json["context"]),
        coordinates: json["coordinates"] == null
            ? null
            : Coordinates.fromJson(json["coordinates"]),
        language: json["language"],
        maki: json["maki"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        namePreferred: json["name_preferred"],
        bbox: json["bbox"] == null
            ? []
            : List<double>.from(json["bbox"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mapbox_id": mapboxId,
        "feature_type": featureType,
        "place_formatted": placeFormatted,
        "context": context.toJson(),
        "coordinates": coordinates?.toJson(),
        "language": language,
        "maki": maki,
        "metadata": metadata?.toJson(),
        "name_preferred": namePreferred,
        "bbox": bbox == null ? [] : List<dynamic>.from(bbox!.map((x) => x)),
      };
}

class Context {
  final Country? country;
  final Region? region;
  final Locality? postcode;
  final Locality? place;
  final Locality? street;
  final Locality? locality;

  Context({
    this.country,
    this.region,
    this.postcode,
    this.place,
    this.street,
    this.locality,
  });

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        region: json["region"] == null ? null : Region.fromJson(json["region"]),
        postcode: json["postcode"] == null
            ? null
            : Locality.fromJson(json["postcode"]),
        place: json["place"] == null ? null : Locality.fromJson(json["place"]),
        street:
            json["street"] == null ? null : Locality.fromJson(json["street"]),
        locality: json["locality"] == null
            ? null
            : Locality.fromJson(json["locality"]),
      );

  Map<String, dynamic> toJson() => {
        "country": country?.toJson(),
        "region": region?.toJson(),
        "postcode": postcode?.toJson(),
        "place": place?.toJson(),
        "street": street?.toJson(),
        "locality": locality?.toJson(),
      };
}

class Country {
  final String? id;
  final String? name;
  final String? countryCode;
  final String? countryCodeAlpha3;

  Country({
    this.id,
    this.name,
    this.countryCode,
    this.countryCodeAlpha3,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        countryCode: json["country_code"],
        countryCodeAlpha3: json["country_code_alpha_3"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_code": countryCode,
        "country_code_alpha_3": countryCodeAlpha3,
      };
}

class Locality {
  final String? id;
  final String? name;

  Locality({
    this.id,
    this.name,
  });

  factory Locality.fromJson(Map<String, dynamic> json) => Locality(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Region {
  final String? id;
  final String? name;
  final String? regionCode;
  final String? regionCodeFull;

  Region({
    this.id,
    this.name,
    this.regionCode,
    this.regionCodeFull,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["name"],
        regionCode: json["region_code"],
        regionCodeFull: json["region_code_full"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "region_code": regionCode,
        "region_code_full": regionCodeFull,
      };
}

class Coordinates {
  final double? latitude;
  final double? longitude;
  final String? accuracy;

  Coordinates({
    this.latitude,
    this.longitude,
    this.accuracy,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        accuracy: json["accuracy"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
