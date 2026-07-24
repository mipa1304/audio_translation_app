part of 'generated.dart';

class DeleteAnalysisReportVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteAnalysisReportVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteAnalysisReportData> dataDeserializer = (dynamic json)  => DeleteAnalysisReportData.fromJson(jsonDecode(json));
  Serializer<DeleteAnalysisReportVariables> varsSerializer = (DeleteAnalysisReportVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteAnalysisReportData, DeleteAnalysisReportVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteAnalysisReportData, DeleteAnalysisReportVariables> ref() {
    DeleteAnalysisReportVariables vars= DeleteAnalysisReportVariables(id: id,);
    return _dataConnect.mutation("DeleteAnalysisReport", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteAnalysisReportAnalysisReportDelete {
  final String id;
  DeleteAnalysisReportAnalysisReportDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAnalysisReportAnalysisReportDelete otherTyped = other as DeleteAnalysisReportAnalysisReportDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteAnalysisReportAnalysisReportDelete({
    required this.id,
  });
}

@immutable
class DeleteAnalysisReportData {
  final DeleteAnalysisReportAnalysisReportDelete? analysisReport_delete;
  DeleteAnalysisReportData.fromJson(dynamic json):
  
  analysisReport_delete = json['analysisReport_delete'] == null ? null : DeleteAnalysisReportAnalysisReportDelete.fromJson(json['analysisReport_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAnalysisReportData otherTyped = other as DeleteAnalysisReportData;
    return analysisReport_delete == otherTyped.analysisReport_delete;
    
  }
  @override
  int get hashCode => analysisReport_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (analysisReport_delete != null) {
      json['analysisReport_delete'] = analysisReport_delete!.toJson();
    }
    return json;
  }

  DeleteAnalysisReportData({
    this.analysisReport_delete,
  });
}

@immutable
class DeleteAnalysisReportVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteAnalysisReportVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAnalysisReportVariables otherTyped = other as DeleteAnalysisReportVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteAnalysisReportVariables({
    required this.id,
  });
}

