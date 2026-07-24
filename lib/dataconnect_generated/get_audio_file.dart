part of 'generated.dart';

class GetAudioFileVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetAudioFileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetAudioFileData> dataDeserializer = (dynamic json)  => GetAudioFileData.fromJson(jsonDecode(json));
  Serializer<GetAudioFileVariables> varsSerializer = (GetAudioFileVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAudioFileData, GetAudioFileVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAudioFileData, GetAudioFileVariables> ref() {
    GetAudioFileVariables vars= GetAudioFileVariables(id: id,);
    return _dataConnect.query("GetAudioFile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAudioFileAudioFile {
  final String filename;
  final String status;
  final double durationSeconds;
  GetAudioFileAudioFile.fromJson(dynamic json):
  
  filename = nativeFromJson<String>(json['filename']),
  status = nativeFromJson<String>(json['status']),
  durationSeconds = nativeFromJson<double>(json['durationSeconds']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAudioFileAudioFile otherTyped = other as GetAudioFileAudioFile;
    return filename == otherTyped.filename && 
    status == otherTyped.status && 
    durationSeconds == otherTyped.durationSeconds;
    
  }
  @override
  int get hashCode => Object.hashAll([filename.hashCode, status.hashCode, durationSeconds.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['filename'] = nativeToJson<String>(filename);
    json['status'] = nativeToJson<String>(status);
    json['durationSeconds'] = nativeToJson<double>(durationSeconds);
    return json;
  }

  GetAudioFileAudioFile({
    required this.filename,
    required this.status,
    required this.durationSeconds,
  });
}

@immutable
class GetAudioFileData {
  final GetAudioFileAudioFile? audioFile;
  GetAudioFileData.fromJson(dynamic json):
  
  audioFile = json['audioFile'] == null ? null : GetAudioFileAudioFile.fromJson(json['audioFile']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAudioFileData otherTyped = other as GetAudioFileData;
    return audioFile == otherTyped.audioFile;
    
  }
  @override
  int get hashCode => audioFile.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (audioFile != null) {
      json['audioFile'] = audioFile!.toJson();
    }
    return json;
  }

  GetAudioFileData({
    this.audioFile,
  });
}

@immutable
class GetAudioFileVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAudioFileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAudioFileVariables otherTyped = other as GetAudioFileVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetAudioFileVariables({
    required this.id,
  });
}

