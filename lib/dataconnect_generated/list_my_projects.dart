part of 'generated.dart';

class ListMyProjectsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListMyProjectsVariablesBuilder(this._dataConnect, );
  Deserializer<ListMyProjectsData> dataDeserializer = (dynamic json)  => ListMyProjectsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListMyProjectsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListMyProjectsData, void> ref() {
    
    return _dataConnect.query("ListMyProjects", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMyProjectsProjects {
  final String id;
  final String name;
  final Timestamp? createdAt;
  ListMyProjectsProjects.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  createdAt = json['createdAt'] == null ? null : Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyProjectsProjects otherTyped = other as ListMyProjectsProjects;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    return json;
  }

  ListMyProjectsProjects({
    required this.id,
    required this.name,
    this.createdAt,
  });
}

@immutable
class ListMyProjectsData {
  final List<ListMyProjectsProjects> projects;
  ListMyProjectsData.fromJson(dynamic json):
  
  projects = (json['projects'] as List<dynamic>)
        .map((e) => ListMyProjectsProjects.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyProjectsData otherTyped = other as ListMyProjectsData;
    return projects == otherTyped.projects;
    
  }
  @override
  int get hashCode => projects.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['projects'] = projects.map((e) => e.toJson()).toList();
    return json;
  }

  ListMyProjectsData({
    required this.projects,
  });
}

