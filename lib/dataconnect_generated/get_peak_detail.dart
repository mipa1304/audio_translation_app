part of 'generated.dart';

class GetPeakDetailVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetPeakDetailVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetPeakDetailData> dataDeserializer = (dynamic json)  => GetPeakDetailData.fromJson(jsonDecode(json));
  Serializer<GetPeakDetailVariables> varsSerializer = (GetPeakDetailVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPeakDetailData, GetPeakDetailVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPeakDetailData, GetPeakDetailVariables> ref() {
    GetPeakDetailVariables vars= GetPeakDetailVariables(id: id,);
    return _dataConnect.query("GetPeakDetail", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPeakDetailPeakDetail {
  final BigInt timestampMs;
  final double amplitudeDb;
  final String peakType;
  GetPeakDetailPeakDetail.fromJson(dynamic json):
  
  timestampMs = bigIntFromJson(json['timestampMs']),
  amplitudeDb = nativeFromJson<double>(json['amplitudeDb']),
  peakType = nativeFromJson<String>(json['peakType']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPeakDetailPeakDetail otherTyped = other as GetPeakDetailPeakDetail;
    return timestampMs == otherTyped.timestampMs && 
    amplitudeDb == otherTyped.amplitudeDb && 
    peakType == otherTyped.peakType;
    
  }
  @override
  int get hashCode => Object.hashAll([timestampMs.hashCode, amplitudeDb.hashCode, peakType.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['timestampMs'] = bigIntToJson(timestampMs);
    json['amplitudeDb'] = nativeToJson<double>(amplitudeDb);
    json['peakType'] = nativeToJson<String>(peakType);
    return json;
  }

  GetPeakDetailPeakDetail({
    required this.timestampMs,
    required this.amplitudeDb,
    required this.peakType,
  });
}

@immutable
class GetPeakDetailData {
  final GetPeakDetailPeakDetail? peakDetail;
  GetPeakDetailData.fromJson(dynamic json):
  
  peakDetail = json['peakDetail'] == null ? null : GetPeakDetailPeakDetail.fromJson(json['peakDetail']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPeakDetailData otherTyped = other as GetPeakDetailData;
    return peakDetail == otherTyped.peakDetail;
    
  }
  @override
  int get hashCode => peakDetail.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (peakDetail != null) {
      json['peakDetail'] = peakDetail!.toJson();
    }
    return json;
  }

  GetPeakDetailData({
    this.peakDetail,
  });
}

@immutable
class GetPeakDetailVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPeakDetailVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetPeakDetailVariables otherTyped = other as GetPeakDetailVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetPeakDetailVariables({
    required this.id,
  });
}

