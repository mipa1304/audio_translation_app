part of 'generated.dart';

class UpdateAnnotationVariablesBuilder {
  String id;
  String status;

  final FirebaseDataConnect _dataConnect;
  UpdateAnnotationVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<UpdateAnnotationData> dataDeserializer = (dynamic json)  => UpdateAnnotationData.fromJson(jsonDecode(json));
  Serializer<UpdateAnnotationVariables> varsSerializer = (UpdateAnnotationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateAnnotationData, UpdateAnnotationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateAnnotationData, UpdateAnnotationVariables> ref() {
    UpdateAnnotationVariables vars= UpdateAnnotationVariables(id: id,status: status,);
    return _dataConnect.mutation("UpdateAnnotation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateAnnotationAnnotationUpdate {
  final String id;
  UpdateAnnotationAnnotationUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAnnotationAnnotationUpdate otherTyped = other as UpdateAnnotationAnnotationUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateAnnotationAnnotationUpdate({
    required this.id,
  });
}

@immutable
class UpdateAnnotationData {
  final UpdateAnnotationAnnotationUpdate? annotation_update;
  UpdateAnnotationData.fromJson(dynamic json):
  
  annotation_update = json['annotation_update'] == null ? null : UpdateAnnotationAnnotationUpdate.fromJson(json['annotation_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAnnotationData otherTyped = other as UpdateAnnotationData;
    return annotation_update == otherTyped.annotation_update;
    
  }
  @override
  int get hashCode => annotation_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (annotation_update != null) {
      json['annotation_update'] = annotation_update!.toJson();
    }
    return json;
  }

  UpdateAnnotationData({
    this.annotation_update,
  });
}

@immutable
class UpdateAnnotationVariables {
  final String id;
  final String status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateAnnotationVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  status = nativeFromJson<String>(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAnnotationVariables otherTyped = other as UpdateAnnotationVariables;
    return id == otherTyped.id && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['status'] = nativeToJson<String>(status);
    return json;
  }

  UpdateAnnotationVariables({
    required this.id,
    required this.status,
  });
}

