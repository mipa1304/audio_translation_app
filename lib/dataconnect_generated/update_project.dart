part of 'generated.dart';

class UpdateProjectVariablesBuilder {
  String id;
  String name;

  final FirebaseDataConnect _dataConnect;
  UpdateProjectVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,});
  Deserializer<UpdateProjectData> dataDeserializer = (dynamic json)  => UpdateProjectData.fromJson(jsonDecode(json));
  Serializer<UpdateProjectVariables> varsSerializer = (UpdateProjectVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateProjectData, UpdateProjectVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateProjectData, UpdateProjectVariables> ref() {
    UpdateProjectVariables vars= UpdateProjectVariables(id: id,name: name,);
    return _dataConnect.mutation("UpdateProject", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateProjectProjectUpdate {
  final String id;
  UpdateProjectProjectUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProjectProjectUpdate otherTyped = other as UpdateProjectProjectUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateProjectProjectUpdate({
    required this.id,
  });
}

@immutable
class UpdateProjectData {
  final UpdateProjectProjectUpdate? project_update;
  UpdateProjectData.fromJson(dynamic json):
  
  project_update = json['project_update'] == null ? null : UpdateProjectProjectUpdate.fromJson(json['project_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProjectData otherTyped = other as UpdateProjectData;
    return project_update == otherTyped.project_update;
    
  }
  @override
  int get hashCode => project_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (project_update != null) {
      json['project_update'] = project_update!.toJson();
    }
    return json;
  }

  UpdateProjectData({
    this.project_update,
  });
}

@immutable
class UpdateProjectVariables {
  final String id;
  final String name;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateProjectVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateProjectVariables otherTyped = other as UpdateProjectVariables;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  UpdateProjectVariables({
    required this.id,
    required this.name,
  });
}

