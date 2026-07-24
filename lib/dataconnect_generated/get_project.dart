part of 'generated.dart';

class GetProjectVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetProjectVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetProjectData> dataDeserializer = (dynamic json)  => GetProjectData.fromJson(jsonDecode(json));
  Serializer<GetProjectVariables> varsSerializer = (GetProjectVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProjectData, GetProjectVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetProjectData, GetProjectVariables> ref() {
    GetProjectVariables vars= GetProjectVariables(id: id,);
    return _dataConnect.query("GetProject", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProjectProject {
  final String name;
  final String ownerId;
  final Timestamp? createdAt;
  GetProjectProject.fromJson(dynamic json):
  
  name = nativeFromJson<String>(json['name']),
  ownerId = nativeFromJson<String>(json['ownerId']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProjectProject otherTyped = other as GetProjectProject;
    return name == otherTyped.name && 
    ownerId == otherTyped.ownerId && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([name.hashCode, ownerId.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    json['ownerId'] = nativeToJson<String>(ownerId);
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    return json;
  }

  GetProjectProject({
    required this.name,
    required this.ownerId,
    this.createdAt,
  });
}

@immutable
class GetProjectData {
  final GetProjectProject? project;
  GetProjectData.fromJson(dynamic json):
  
  project = json['project'] == null ? null : GetProjectProject.fromJson(json['project']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProjectData otherTyped = other as GetProjectData;
    return project == otherTyped.project;
    
  }
  @override
  int get hashCode => project.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (project != null) {
      json['project'] = project!.toJson();
    }
    return json;
  }

  GetProjectData({
    this.project,
  });
}

@immutable
class GetProjectVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProjectVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProjectVariables otherTyped = other as GetProjectVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetProjectVariables({
    required this.id,
  });
}

