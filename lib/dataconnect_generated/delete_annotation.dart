part of 'generated.dart';

class DeleteAnnotationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteAnnotationVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteAnnotationData> dataDeserializer = (dynamic json)  => DeleteAnnotationData.fromJson(jsonDecode(json));
  Serializer<DeleteAnnotationVariables> varsSerializer = (DeleteAnnotationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteAnnotationData, DeleteAnnotationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteAnnotationData, DeleteAnnotationVariables> ref() {
    DeleteAnnotationVariables vars= DeleteAnnotationVariables(id: id,);
    return _dataConnect.mutation("DeleteAnnotation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteAnnotationAnnotationDelete {
  final String id;
  DeleteAnnotationAnnotationDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAnnotationAnnotationDelete otherTyped = other as DeleteAnnotationAnnotationDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteAnnotationAnnotationDelete({
    required this.id,
  });
}

@immutable
class DeleteAnnotationData {
  final DeleteAnnotationAnnotationDelete? annotation_delete;
  DeleteAnnotationData.fromJson(dynamic json):
  
  annotation_delete = json['annotation_delete'] == null ? null : DeleteAnnotationAnnotationDelete.fromJson(json['annotation_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAnnotationData otherTyped = other as DeleteAnnotationData;
    return annotation_delete == otherTyped.annotation_delete;
    
  }
  @override
  int get hashCode => annotation_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (annotation_delete != null) {
      json['annotation_delete'] = annotation_delete!.toJson();
    }
    return json;
  }

  DeleteAnnotationData({
    this.annotation_delete,
  });
}

@immutable
class DeleteAnnotationVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteAnnotationVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAnnotationVariables otherTyped = other as DeleteAnnotationVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteAnnotationVariables({
    required this.id,
  });
}

