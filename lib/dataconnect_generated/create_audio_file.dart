part of 'generated.dart';

class CreateAudioFileVariablesBuilder {
  String filename;
  double duration;
  String projectId;

  final FirebaseDataConnect _dataConnect;
  CreateAudioFileVariablesBuilder(this._dataConnect, {required  this.filename,required  this.duration,required  this.projectId,});
  Deserializer<CreateAudioFileData> dataDeserializer = (dynamic json)  => CreateAudioFileData.fromJson(jsonDecode(json));
  Serializer<CreateAudioFileVariables> varsSerializer = (CreateAudioFileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateAudioFileData, CreateAudioFileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateAudioFileData, CreateAudioFileVariables> ref() {
    CreateAudioFileVariables vars= CreateAudioFileVariables(filename: filename,duration: duration,projectId: projectId,);
    return _dataConnect.mutation("CreateAudioFile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateAudioFileAudioFileInsert {
  final String id;
  CreateAudioFileAudioFileInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAudioFileAudioFileInsert otherTyped = other as CreateAudioFileAudioFileInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAudioFileAudioFileInsert({
    required this.id,
  });
}

@immutable
class CreateAudioFileData {
  final CreateAudioFileAudioFileInsert audioFile_insert;
  CreateAudioFileData.fromJson(dynamic json):
  
  audioFile_insert = CreateAudioFileAudioFileInsert.fromJson(json['audioFile_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAudioFileData otherTyped = other as CreateAudioFileData;
    return audioFile_insert == otherTyped.audioFile_insert;
    
  }
  @override
  int get hashCode => audioFile_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['audioFile_insert'] = audioFile_insert.toJson();
    return json;
  }

  CreateAudioFileData({
    required this.audioFile_insert,
  });
}

@immutable
class CreateAudioFileVariables {
  final String filename;
  final double duration;
  final String projectId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateAudioFileVariables.fromJson(Map<String, dynamic> json):
  
  filename = nativeFromJson<String>(json['filename']),
  duration = nativeFromJson<double>(json['duration']),
  projectId = nativeFromJson<String>(json['projectId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAudioFileVariables otherTyped = other as CreateAudioFileVariables;
    return filename == otherTyped.filename && 
    duration == otherTyped.duration && 
    projectId == otherTyped.projectId;
    
  }
  @override
  int get hashCode => Object.hashAll([filename.hashCode, duration.hashCode, projectId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['filename'] = nativeToJson<String>(filename);
    json['duration'] = nativeToJson<double>(duration);
    json['projectId'] = nativeToJson<String>(projectId);
    return json;
  }

  CreateAudioFileVariables({
    required this.filename,
    required this.duration,
    required this.projectId,
  });
}

