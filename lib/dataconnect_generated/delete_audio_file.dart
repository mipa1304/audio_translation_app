part of 'generated.dart';

class DeleteAudioFileVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteAudioFileVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteAudioFileData> dataDeserializer = (dynamic json)  => DeleteAudioFileData.fromJson(jsonDecode(json));
  Serializer<DeleteAudioFileVariables> varsSerializer = (DeleteAudioFileVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteAudioFileData, DeleteAudioFileVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteAudioFileData, DeleteAudioFileVariables> ref() {
    DeleteAudioFileVariables vars= DeleteAudioFileVariables(id: id,);
    return _dataConnect.mutation("DeleteAudioFile", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteAudioFileAudioFileDelete {
  final String id;
  DeleteAudioFileAudioFileDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAudioFileAudioFileDelete otherTyped = other as DeleteAudioFileAudioFileDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteAudioFileAudioFileDelete({
    required this.id,
  });
}

@immutable
class DeleteAudioFileData {
  final DeleteAudioFileAudioFileDelete? audioFile_delete;
  DeleteAudioFileData.fromJson(dynamic json):
  
  audioFile_delete = json['audioFile_delete'] == null ? null : DeleteAudioFileAudioFileDelete.fromJson(json['audioFile_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAudioFileData otherTyped = other as DeleteAudioFileData;
    return audioFile_delete == otherTyped.audioFile_delete;
    
  }
  @override
  int get hashCode => audioFile_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (audioFile_delete != null) {
      json['audioFile_delete'] = audioFile_delete!.toJson();
    }
    return json;
  }

  DeleteAudioFileData({
    this.audioFile_delete,
  });
}

@immutable
class DeleteAudioFileVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteAudioFileVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteAudioFileVariables otherTyped = other as DeleteAudioFileVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteAudioFileVariables({
    required this.id,
  });
}

