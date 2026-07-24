part of 'generated.dart';

class CreateAnnotationVariablesBuilder {
  String comment;
  String peakId;

  final FirebaseDataConnect _dataConnect;
  CreateAnnotationVariablesBuilder(this._dataConnect, {required  this.comment,required  this.peakId,});
  Deserializer<CreateAnnotationData> dataDeserializer = (dynamic json)  => CreateAnnotationData.fromJson(jsonDecode(json));
  Serializer<CreateAnnotationVariables> varsSerializer = (CreateAnnotationVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateAnnotationData, CreateAnnotationVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateAnnotationData, CreateAnnotationVariables> ref() {
    CreateAnnotationVariables vars= CreateAnnotationVariables(comment: comment,peakId: peakId,);
    return _dataConnect.mutation("CreateAnnotation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateAnnotationAnnotationInsert {
  final String id;
  CreateAnnotationAnnotationInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnnotationAnnotationInsert otherTyped = other as CreateAnnotationAnnotationInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateAnnotationAnnotationInsert({
    required this.id,
  });
}

@immutable
class CreateAnnotationData {
  final CreateAnnotationAnnotationInsert annotation_insert;
  CreateAnnotationData.fromJson(dynamic json):
  
  annotation_insert = CreateAnnotationAnnotationInsert.fromJson(json['annotation_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnnotationData otherTyped = other as CreateAnnotationData;
    return annotation_insert == otherTyped.annotation_insert;
    
  }
  @override
  int get hashCode => annotation_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['annotation_insert'] = annotation_insert.toJson();
    return json;
  }

  CreateAnnotationData({
    required this.annotation_insert,
  });
}

@immutable
class CreateAnnotationVariables {
  final String comment;
  final String peakId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateAnnotationVariables.fromJson(Map<String, dynamic> json):
  
  comment = nativeFromJson<String>(json['comment']),
  peakId = nativeFromJson<String>(json['peakId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateAnnotationVariables otherTyped = other as CreateAnnotationVariables;
    return comment == otherTyped.comment && 
    peakId == otherTyped.peakId;
    
  }
  @override
  int get hashCode => Object.hashAll([comment.hashCode, peakId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['comment'] = nativeToJson<String>(comment);
    json['peakId'] = nativeToJson<String>(peakId);
    return json;
  }

  CreateAnnotationVariables({
    required this.comment,
    required this.peakId,
  });
}

