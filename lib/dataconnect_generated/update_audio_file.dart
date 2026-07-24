part of 'generated.dart';

class UpdateAudioFileVariablesBuilder {
  String id;
  String status;

  final FirebaseDataConnect _dataConnect;
  UpdateAudioFileVariablesBuilder(this._dataConnect, {required  this.id,required  this.status,});
  Deserializer<UpdateAudioFileData> dataDeserializer = (dynamic json)  => UpdateAudioFileData.fromJson(jsonDecode(json));
  Serializer<UpdateAudioFileVariables> varsSerializer = (UpdateAudioFileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateAudioFileData, UpdateAudioFileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateAudioFileData, UpdateAudioFileVariables> ref() {
    UpdateAudioFileVariables vars= UpdateAudioFileVariables(id: id,status: status,);
    return _dataConnect.mutation("UpdateAudioFile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateAudioFileAudioFileUpdate {
  final String id;
  UpdateAudioFileAudioFileUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAudioFileAudioFileUpdate otherTyped = other as UpdateAudioFileAudioFileUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdateAudioFileAudioFileUpdate({
    required this.id,
  });
}

@immutable
class UpdateAudioFileData {
  final UpdateAudioFileAudioFileUpdate? audioFile_update;
  UpdateAudioFileData.fromJson(dynamic json):
  
  audioFile_update = json['audioFile_update'] == null ? null : UpdateAudioFileAudioFileUpdate.fromJson(json['audioFile_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateAudioFileData otherTyped = other as UpdateAudioFileData;
    return audioFile_update == otherTyped.audioFile_update;
    
  }
  @override
  int get hashCode => audioFile_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (audioFile_update != null) {
      json['audioFile_update'] = audioFile_update!.toJson();
    }
    return json;
  }

  UpdateAudioFileData({
    this.audioFile_update,
  });
}

@immutable
class UpdateAudioFileVariables {
  final String id;
  final String status;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateAudioFileVariables.fromJson(Map<String, dynamic> json):
  
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

    final UpdateAudioFileVariables otherTyped = other as UpdateAudioFileVariables;
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

  UpdateAudioFileVariables({
    required this.id,
    required this.status,
  });
}

