part of 'generated.dart';

class ListProjectAudioFilesVariablesBuilder {
  String projectId;

  final FirebaseDataConnect _dataConnect;
  ListProjectAudioFilesVariablesBuilder(this._dataConnect, {required  this.projectId,});
  Deserializer<ListProjectAudioFilesData> dataDeserializer = (dynamic json)  => ListProjectAudioFilesData.fromJson(jsonDecode(json));
  Serializer<ListProjectAudioFilesVariables> varsSerializer = (ListProjectAudioFilesVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListProjectAudioFilesData, ListProjectAudioFilesVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListProjectAudioFilesData, ListProjectAudioFilesVariables> ref() {
    ListProjectAudioFilesVariables vars= ListProjectAudioFilesVariables(projectId: projectId,);
    return _dataConnect.query("ListProjectAudioFiles", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListProjectAudioFilesAudioFiles {
  final String id;
  final String filename;
  final String status;
  ListProjectAudioFilesAudioFiles.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  filename = nativeFromJson<String>(json['filename']),
  status = nativeFromJson<String>(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListProjectAudioFilesAudioFiles otherTyped = other as ListProjectAudioFilesAudioFiles;
    return id == otherTyped.id && 
    filename == otherTyped.filename && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, filename.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['filename'] = nativeToJson<String>(filename);
    json['status'] = nativeToJson<String>(status);
    return json;
  }

  ListProjectAudioFilesAudioFiles({
    required this.id,
    required this.filename,
    required this.status,
  });
}

@immutable
class ListProjectAudioFilesData {
  final List<ListProjectAudioFilesAudioFiles> audioFiles;
  ListProjectAudioFilesData.fromJson(dynamic json):
  
  audioFiles = (json['audioFiles'] as List<dynamic>)
        .map((e) => ListProjectAudioFilesAudioFiles.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListProjectAudioFilesData otherTyped = other as ListProjectAudioFilesData;
    return audioFiles == otherTyped.audioFiles;
    
  }
  @override
  int get hashCode => audioFiles.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audioFiles'] = audioFiles.map((e) => e.toJson()).toList();
    return json;
  }

  ListProjectAudioFilesData({
    required this.audioFiles,
  });
}

@immutable
class ListProjectAudioFilesVariables {
  final String projectId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListProjectAudioFilesVariables.fromJson(Map<String, dynamic> json):
  
  projectId = nativeFromJson<String>(json['projectId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListProjectAudioFilesVariables otherTyped = other as ListProjectAudioFilesVariables;
    return projectId == otherTyped.projectId;
    
  }
  @override
  int get hashCode => projectId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['projectId'] = nativeToJson<String>(projectId);
    return json;
  }

  ListProjectAudioFilesVariables({
    required this.projectId,
  });
}

