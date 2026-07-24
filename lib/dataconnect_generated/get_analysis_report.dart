part of 'generated.dart';

class GetAnalysisReportVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetAnalysisReportVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetAnalysisReportData> dataDeserializer = (dynamic json)  => GetAnalysisReportData.fromJson(jsonDecode(json));
  Serializer<GetAnalysisReportVariables> varsSerializer = (GetAnalysisReportVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAnalysisReportData, GetAnalysisReportVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAnalysisReportData, GetAnalysisReportVariables> ref() {
    GetAnalysisReportVariables vars= GetAnalysisReportVariables(id: id,);
    return _dataConnect.query("GetAnalysisReport", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAnalysisReportAnalysisReport {
  final double averageLbs;
  final int peakCount;
  final int sampleRate;
  final double? recommendedNormalization;
  GetAnalysisReportAnalysisReport.fromJson(dynamic json):
  
  averageLbs = nativeFromJson<double>(json['averageLbs']),
  peakCount = nativeFromJson<int>(json['peakCount']),
  sampleRate = nativeFromJson<int>(json['sampleRate']),
  recommendedNormalization = json['recommendedNormalization'] == null ? null : nativeFromJson<double>(json['recommendedNormalization']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnalysisReportAnalysisReport otherTyped = other as GetAnalysisReportAnalysisReport;
    return averageLbs == otherTyped.averageLbs && 
    peakCount == otherTyped.peakCount && 
    sampleRate == otherTyped.sampleRate && 
    recommendedNormalization == otherTyped.recommendedNormalization;
    
  }
  @override
  int get hashCode => Object.hashAll([averageLbs.hashCode, peakCount.hashCode, sampleRate.hashCode, recommendedNormalization.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['averageLbs'] = nativeToJson<double>(averageLbs);
    json['peakCount'] = nativeToJson<int>(peakCount);
    json['sampleRate'] = nativeToJson<int>(sampleRate);
    if (recommendedNormalization != null) {
      json['recommendedNormalization'] = nativeToJson<double?>(recommendedNormalization);
    }
    return json;
  }

  GetAnalysisReportAnalysisReport({
    required this.averageLbs,
    required this.peakCount,
    required this.sampleRate,
    this.recommendedNormalization,
  });
}

@immutable
class GetAnalysisReportData {
  final GetAnalysisReportAnalysisReport? analysisReport;
  GetAnalysisReportData.fromJson(dynamic json):
  
  analysisReport = json['analysisReport'] == null ? null : GetAnalysisReportAnalysisReport.fromJson(json['analysisReport']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnalysisReportData otherTyped = other as GetAnalysisReportData;
    return analysisReport == otherTyped.analysisReport;
    
  }
  @override
  int get hashCode => analysisReport.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (analysisReport != null) {
      json['analysisReport'] = analysisReport!.toJson();
    }
    return json;
  }

  GetAnalysisReportData({
    this.analysisReport,
  });
}

@immutable
class GetAnalysisReportVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAnalysisReportVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnalysisReportVariables otherTyped = other as GetAnalysisReportVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetAnalysisReportVariables({
    required this.id,
  });
}

