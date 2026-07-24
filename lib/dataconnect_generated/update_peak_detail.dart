part of 'generated.dart';

class UpdatePeakDetailVariablesBuilder {
  String id;
  double conf;

  final FirebaseDataConnect _dataConnect;
  UpdatePeakDetailVariablesBuilder(this._dataConnect, {required  this.id,required  this.conf,});
  Deserializer<UpdatePeakDetailData> dataDeserializer = (dynamic json)  => UpdatePeakDetailData.fromJson(jsonDecode(json));
  Serializer<UpdatePeakDetailVariables> varsSerializer = (UpdatePeakDetailVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdatePeakDetailData, UpdatePeakDetailVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdatePeakDetailData, UpdatePeakDetailVariables> ref() {
    UpdatePeakDetailVariables vars= UpdatePeakDetailVariables(id: id,conf: conf,);
    return _dataConnect.mutation("UpdatePeakDetail", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdatePeakDetailPeakDetailUpdate {
  final String id;
  UpdatePeakDetailPeakDetailUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePeakDetailPeakDetailUpdate otherTyped = other as UpdatePeakDetailPeakDetailUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpdatePeakDetailPeakDetailUpdate({
    required this.id,
  });
}

@immutable
class UpdatePeakDetailData {
  final UpdatePeakDetailPeakDetailUpdate? peakDetail_update;
  UpdatePeakDetailData.fromJson(dynamic json):
  
  peakDetail_update = json['peakDetail_update'] == null ? null : UpdatePeakDetailPeakDetailUpdate.fromJson(json['peakDetail_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePeakDetailData otherTyped = other as UpdatePeakDetailData;
    return peakDetail_update == otherTyped.peakDetail_update;
    
  }
  @override
  int get hashCode => peakDetail_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (peakDetail_update != null) {
      json['peakDetail_update'] = peakDetail_update!.toJson();
    }
    return json;
  }

  UpdatePeakDetailData({
    this.peakDetail_update,
  });
}

@immutable
class UpdatePeakDetailVariables {
  final String id;
  final double conf;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdatePeakDetailVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  conf = nativeFromJson<double>(json['conf']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePeakDetailVariables otherTyped = other as UpdatePeakDetailVariables;
    return id == otherTyped.id && 
    conf == otherTyped.conf;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, conf.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['conf'] = nativeToJson<double>(conf);
    return json;
  }

  UpdatePeakDetailVariables({
    required this.id,
    required this.conf,
  });
}

