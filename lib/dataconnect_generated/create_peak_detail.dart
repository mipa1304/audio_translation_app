part of 'generated.dart';

class CreatePeakDetailVariablesBuilder {
  BigInt ts;
  double amp;
  String type;
  String audioId;

  final FirebaseDataConnect _dataConnect;
  CreatePeakDetailVariablesBuilder(this._dataConnect, {required  this.ts,required  this.amp,required  this.type,required  this.audioId,});
  Deserializer<CreatePeakDetailData> dataDeserializer = (dynamic json)  => CreatePeakDetailData.fromJson(jsonDecode(json));
  Serializer<CreatePeakDetailVariables> varsSerializer = (CreatePeakDetailVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePeakDetailData, CreatePeakDetailVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePeakDetailData, CreatePeakDetailVariables> ref() {
    CreatePeakDetailVariables vars= CreatePeakDetailVariables(ts: ts,amp: amp,type: type,audioId: audioId,);
    return _dataConnect.mutation("CreatePeakDetail", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePeakDetailPeakDetailInsert {
  final String id;
  CreatePeakDetailPeakDetailInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePeakDetailPeakDetailInsert otherTyped = other as CreatePeakDetailPeakDetailInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreatePeakDetailPeakDetailInsert({
    required this.id,
  });
}

@immutable
class CreatePeakDetailData {
  final CreatePeakDetailPeakDetailInsert peakDetail_insert;
  CreatePeakDetailData.fromJson(dynamic json):
  
  peakDetail_insert = CreatePeakDetailPeakDetailInsert.fromJson(json['peakDetail_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePeakDetailData otherTyped = other as CreatePeakDetailData;
    return peakDetail_insert == otherTyped.peakDetail_insert;
    
  }
  @override
  int get hashCode => peakDetail_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['peakDetail_insert'] = peakDetail_insert.toJson();
    return json;
  }

  CreatePeakDetailData({
    required this.peakDetail_insert,
  });
}

@immutable
class CreatePeakDetailVariables {
  final BigInt ts;
  final double amp;
  final String type;
  final String audioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePeakDetailVariables.fromJson(Map<String, dynamic> json):
  
  ts = bigIntFromJson(json['ts']),
  amp = nativeFromJson<double>(json['amp']),
  type = nativeFromJson<String>(json['type']),
  audioId = nativeFromJson<String>(json['audioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePeakDetailVariables otherTyped = other as CreatePeakDetailVariables;
    return ts == otherTyped.ts && 
    amp == otherTyped.amp && 
    type == otherTyped.type && 
    audioId == otherTyped.audioId;
    
  }
  @override
  int get hashCode => Object.hashAll([ts.hashCode, amp.hashCode, type.hashCode, audioId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['ts'] = bigIntToJson(ts);
    json['amp'] = nativeToJson<double>(amp);
    json['type'] = nativeToJson<String>(type);
    json['audioId'] = nativeToJson<String>(audioId);
    return json;
  }

  CreatePeakDetailVariables({
    required this.ts,
    required this.amp,
    required this.type,
    required this.audioId,
  });
}

