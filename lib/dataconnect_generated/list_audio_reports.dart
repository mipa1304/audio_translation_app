part of 'generated.dart';

class ListAudioReportsVariablesBuilder {
  String audioId;

  final FirebaseDataConnect _dataConnect;
  ListAudioReportsVariablesBuilder(this._dataConnect, {required  this.audioId,});
  Deserializer<ListAudioReportsData> dataDeserializer = (dynamic json)  => ListAudioReportsData.fromJson(jsonDecode(json));
  Serializer<ListAudioReportsVariables> varsSerializer = (ListAudioReportsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListAudioReportsData, ListAudioReportsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListAudioReportsData, ListAudioReportsVariables> ref() {
    ListAudioReportsVariables vars= ListAudioReportsVariables(audioId: audioId,);
    return _dataConnect.query("ListAudioReports", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListAudioReportsAnalysisReports {
  final String id;
  final double averageLbs;
  final Timestamp? generatedAt;
  ListAudioReportsAnalysisReports.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  averageLbs = nativeFromJson<double>(json['averageLbs']),
  generatedAt = json['generatedAt'] == null ? null : Timestamp.fromJson(json['generatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAudioReportsAnalysisReports otherTyped = other as ListAudioReportsAnalysisReports;
    return id == otherTyped.id && 
    averageLbs == otherTyped.averageLbs && 
    generatedAt == otherTyped.generatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, averageLbs.hashCode, generatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['averageLbs'] = nativeToJson<double>(averageLbs);
    if (generatedAt != null) {
      json['generatedAt'] = generatedAt!.toJson();
    }
    return json;
  }

  ListAudioReportsAnalysisReports({
    required this.id,
    required this.averageLbs,
    this.generatedAt,
  });
}

@immutable
class ListAudioReportsData {
  final List<ListAudioReportsAnalysisReports> analysisReports;
  ListAudioReportsData.fromJson(dynamic json):
  
  analysisReports = (json['analysisReports'] as List<dynamic>)
        .map((e) => ListAudioReportsAnalysisReports.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAudioReportsData otherTyped = other as ListAudioReportsData;
    return analysisReports == otherTyped.analysisReports;
    
  }
  @override
  int get hashCode => analysisReports.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['analysisReports'] = analysisReports.map((e) => e.toJson()).toList();
    return json;
  }

  ListAudioReportsData({
    required this.analysisReports,
  });
}

@immutable
class ListAudioReportsVariables {
  final String audioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListAudioReportsVariables.fromJson(Map<String, dynamic> json):
  
  audioId = nativeFromJson<String>(json['audioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListAudioReportsVariables otherTyped = other as ListAudioReportsVariables;
    return audioId == otherTyped.audioId;
    
  }
  @override
  int get hashCode => audioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audioId'] = nativeToJson<String>(audioId);
    return json;
  }

  ListAudioReportsVariables({
    required this.audioId,
  });
}

