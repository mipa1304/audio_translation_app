part of 'generated.dart';

class CreateAnalysisReportVariablesBuilder {
  double lbs;
  int count;
  int rate;
  String audioId;

  final FirebaseDataConnect _dataConnect;
  CreateAnalysisReportVariablesBuilder(this._dataConnect, {required  this.lbs,required  this.count,required  this.rate,required  this.audioId,});
  Deserializer<CreateAnalysisReportData> dataDeserializer = (dynamic json)  => CreateAnalysisReportData.fromJson(jsonDecode(json));
  Serializer<CreateAnalysisReportVariables> varsSerializer = (CreateAnalysisReportVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateAnalysisReportData, CreateAnalysisReportVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateAnalysisReportData, CreateAnalysisReportVariables> ref() {
    CreateAnalysisReportVariables vars= CreateAnalysisReportVariables(lbs: lbs,count: count,rate: rate,audioId: audioId,);
    return _dataConnect.mutation("CreateAnalysisReport", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateAnalysisReportAnalysisReportInsert {
  final String id;
  CreateAnalysisReportAnalysisReportInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnalysisReportAnalysisReportInsert otherTyped = other as CreateAnalysisReportAnalysisReportInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAnalysisReportAnalysisReportInsert({
    required this.id,
  });
}

@immutable
class CreateAnalysisReportData {
  final CreateAnalysisReportAnalysisReportInsert analysisReport_insert;
  CreateAnalysisReportData.fromJson(dynamic json):
  
  analysisReport_insert = CreateAnalysisReportAnalysisReportInsert.fromJson(json['analysisReport_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnalysisReportData otherTyped = other as CreateAnalysisReportData;
    return analysisReport_insert == otherTyped.analysisReport_insert;
    
  }
  @override
  int get hashCode => analysisReport_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['analysisReport_insert'] = analysisReport_insert.toJson();
    return json;
  }

  CreateAnalysisReportData({
    required this.analysisReport_insert,
  });
}

@immutable
class CreateAnalysisReportVariables {
  final double lbs;
  final int count;
  final int rate;
  final String audioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateAnalysisReportVariables.fromJson(Map<String, dynamic> json):
  
  lbs = nativeFromJson<double>(json['lbs']),
  count = nativeFromJson<int>(json['count']),
  rate = nativeFromJson<int>(json['rate']),
  audioId = nativeFromJson<String>(json['audioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnalysisReportVariables otherTyped = other as CreateAnalysisReportVariables;
    return lbs == otherTyped.lbs && 
    count == otherTyped.count && 
    rate == otherTyped.rate && 
    audioId == otherTyped.audioId;
    
  }
  @override
  int get hashCode => Object.hashAll([lbs.hashCode, count.hashCode, rate.hashCode, audioId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['lbs'] = nativeToJson<double>(lbs);
    json['count'] = nativeToJson<int>(count);
    json['rate'] = nativeToJson<int>(rate);
    json['audioId'] = nativeToJson<String>(audioId);
    return json;
  }

  CreateAnalysisReportVariables({
    required this.lbs,
    required this.count,
    required this.rate,
    required this.audioId,
  });
}

