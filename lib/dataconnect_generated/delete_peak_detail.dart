part of 'generated.dart';

class DeletePeakDetailVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeletePeakDetailVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeletePeakDetailData> dataDeserializer = (dynamic json)  => DeletePeakDetailData.fromJson(jsonDecode(json));
  Serializer<DeletePeakDetailVariables> varsSerializer = (DeletePeakDetailVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeletePeakDetailData, DeletePeakDetailVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeletePeakDetailData, DeletePeakDetailVariables> ref() {
    DeletePeakDetailVariables vars= DeletePeakDetailVariables(id: id,);
    return _dataConnect.mutation("DeletePeakDetail", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeletePeakDetailPeakDetailDelete {
  final String id;
  DeletePeakDetailPeakDetailDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePeakDetailPeakDetailDelete otherTyped = other as DeletePeakDetailPeakDetailDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeletePeakDetailPeakDetailDelete({
    required this.id,
  });
}

@immutable
class DeletePeakDetailData {
  final DeletePeakDetailPeakDetailDelete? peakDetail_delete;
  DeletePeakDetailData.fromJson(dynamic json):
  
  peakDetail_delete = json['peakDetail_delete'] == null ? null : DeletePeakDetailPeakDetailDelete.fromJson(json['peakDetail_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePeakDetailData otherTyped = other as DeletePeakDetailData;
    return peakDetail_delete == otherTyped.peakDetail_delete;
    
  }
  @override
  int get hashCode => peakDetail_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (peakDetail_delete != null) {
      json['peakDetail_delete'] = peakDetail_delete!.toJson();
    }
    return json;
  }

  DeletePeakDetailData({
    this.peakDetail_delete,
  });
}

@immutable
class DeletePeakDetailVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeletePeakDetailVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePeakDetailVariables otherTyped = other as DeletePeakDetailVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeletePeakDetailVariables({
    required this.id,
  });
}

