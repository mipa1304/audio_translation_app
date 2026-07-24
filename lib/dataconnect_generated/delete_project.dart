part of 'generated.dart';

class DeleteProjectVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteProjectVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteProjectData> dataDeserializer = (dynamic json)  => DeleteProjectData.fromJson(jsonDecode(json));
  Serializer<DeleteProjectVariables> varsSerializer = (DeleteProjectVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteProjectData, DeleteProjectVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteProjectData, DeleteProjectVariables> ref() {
    DeleteProjectVariables vars= DeleteProjectVariables(id: id,);
    return _dataConnect.mutation("DeleteProject", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteProjectProjectDelete {
  final String id;
  DeleteProjectProjectDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProjectProjectDelete otherTyped = other as DeleteProjectProjectDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteProjectProjectDelete({
    required this.id,
  });
}

@immutable
class DeleteProjectData {
  final DeleteProjectProjectDelete? project_delete;
  DeleteProjectData.fromJson(dynamic json):
  
  project_delete = json['project_delete'] == null ? null : DeleteProjectProjectDelete.fromJson(json['project_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProjectData otherTyped = other as DeleteProjectData;
    return project_delete == otherTyped.project_delete;
    
  }
  @override
  int get hashCode => project_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (project_delete != null) {
      json['project_delete'] = project_delete!.toJson();
    }
    return json;
  }

  DeleteProjectData({
    this.project_delete,
  });
}

@immutable
class DeleteProjectVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteProjectVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteProjectVariables otherTyped = other as DeleteProjectVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteProjectVariables({
    required this.id,
  });
}

