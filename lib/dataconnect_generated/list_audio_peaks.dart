part of 'generated.dart';

class ListAudioPeaksVariablesBuilder {
  String audioId;

  final FirebaseDataConnect _dataConnect;
  ListAudioPeaksVariablesBuilder(this._dataConnect, {required  this.audioId,});
  Deserializer<ListAudioPeaksData> dataDeserializer = (dynamic json)  => ListAudioPeaksData.fromJson(jsonDecode(json));
  Serializer<ListAudioPeaksVariables> varsSerializer = (ListAudioPeaksVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListAudioPeaksData, ListAudioPeaksVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListAudioPeaksData, ListAudioPeaksVariables> ref() {
    ListAudioPeaksVariables vars= ListAudioPeaksVariables(audioId: audioId,);
    return _dataConnect.query("ListAudioPeaks", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListAudioPeaksPeakDetails {
  final String id;
  final BigInt timestampMs;
  final double amplitudeDb;
  ListAudioPeaksPeakDetails.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  timestampMs = bigIntFromJson(json['timestampMs']),
  amplitudeDb = nativeFromJson<double>(json['amplitudeDb']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAudioPeaksPeakDetails otherTyped = other as ListAudioPeaksPeakDetails;
    return id == otherTyped.id && 
    timestampMs == otherTyped.timestampMs && 
    amplitudeDb == otherTyped.amplitudeDb;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, timestampMs.hashCode, amplitudeDb.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['timestampMs'] = bigIntToJson(timestampMs);
    json['amplitudeDb'] = nativeToJson<double>(amplitudeDb);
    return json;
  }

  ListAudioPeaksPeakDetails({
    required this.id,
    required this.timestampMs,
    required this.amplitudeDb,
  });
}

@immutable
class ListAudioPeaksData {
  final List<ListAudioPeaksPeakDetails> peakDetails;
  ListAudioPeaksData.fromJson(dynamic json):
  
  peakDetails = (json['peakDetails'] as List<dynamic>)
        .map((e) => ListAudioPeaksPeakDetails.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAudioPeaksData otherTyped = other as ListAudioPeaksData;
    return peakDetails == otherTyped.peakDetails;
    
  }
  @override
  int get hashCode => peakDetails.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['peakDetails'] = peakDetails.map((e) => e.toJson()).toList();
    return json;
  }

  ListAudioPeaksData({
    required this.peakDetails,
  });
}

@immutable
class ListAudioPeaksVariables {
  final String audioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListAudioPeaksVariables.fromJson(Map<String, dynamic> json):
  
  audioId = nativeFromJson<String>(json['audioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAudioPeaksVariables otherTyped = other as ListAudioPeaksVariables;
    return audioId == otherTyped.audioId;
    
  }
  @override
  int get hashCode => audioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audioId'] = nativeToJson<String>(audioId);
    return json;
  }

  ListAudioPeaksVariables({
    required this.audioId,
  });
}

