part of 'generated.dart';

class CreateProjectVariablesBuilder {
  String name;

  final FirebaseDataConnect _dataConnect;
  CreateProjectVariablesBuilder(this._dataConnect, {required  this.name,});
  Deserializer<CreateProjectData> dataDeserializer = (dynamic json)  => CreateProjectData.fromJson(jsonDecode(json));
  Serializer<CreateProjectVariables> varsSerializer = (CreateProjectVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateProjectData, CreateProjectVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateProjectData, CreateProjectVariables> ref() {
    CreateProjectVariables vars= CreateProjectVariables(name: name,);
    return _dataConnect.mutation("CreateProject", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateProjectProjectInsert {
  final String id;
  CreateProjectProjectInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateProjectProjectInsert otherTyped = other as CreateProjectProjectInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateProjectProjectInsert({
    required this.id,
  });
}

@immutable
class CreateProjectData {
  final CreateProjectProjectInsert project_insert;
  CreateProjectData.fromJson(dynamic json):
  
  project_insert = CreateProjectProjectInsert.fromJson(json['project_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateProjectData otherTyped = other as CreateProjectData;
    return project_insert == otherTyped.project_insert;
    
  }
  @override
  int get hashCode => project_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['project_insert'] = project_insert.toJson();
    return json;
  }

  CreateProjectData({
    required this.project_insert,
  });
}

@immutable
class CreateProjectVariables {
  final String name;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateProjectVariables.fromJson(Map<String, dynamic> json):
  
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateProjectVariables otherTyped = other as CreateProjectVariables;
    return name == otherTyped.name;
    
  }
  @override
  int get hashCode => name.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  CreateProjectVariables({
    required this.name,
  });
}

