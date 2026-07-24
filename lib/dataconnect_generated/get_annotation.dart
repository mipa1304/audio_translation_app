part of 'generated.dart';

class GetAnnotationVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetAnnotationVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<GetAnnotationData> dataDeserializer = (dynamic json)  => GetAnnotationData.fromJson(jsonDecode(json));
  Serializer<GetAnnotationVariables> varsSerializer = (GetAnnotationVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetAnnotationData, GetAnnotationVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAnnotationData, GetAnnotationVariables> ref() {
    GetAnnotationVariables vars= GetAnnotationVariables(id: id,);
    return _dataConnect.query("GetAnnotation", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetAnnotationAnnotation {
  final String comment;
  final String status;
  final String? authorId;
  GetAnnotationAnnotation.fromJson(dynamic json):
  
  comment = nativeFromJson<String>(json['comment']),
  status = nativeFromJson<String>(json['status']),
  authorId = json['authorId'] == null ? null : nativeFromJson<String>(json['authorId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnnotationAnnotation otherTyped = other as GetAnnotationAnnotation;
    return comment == otherTyped.comment && 
    status == otherTyped.status && 
    authorId == otherTyped.authorId;
    
  }
  @override
  int get hashCode => Object.hashAll([comment.hashCode, status.hashCode, authorId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['comment'] = nativeToJson<String>(comment);
    json['status'] = nativeToJson<String>(status);
    if (authorId != null) {
      json['authorId'] = nativeToJson<String?>(authorId);
    }
    return json;
  }

  GetAnnotationAnnotation({
    required this.comment,
    required this.status,
    this.authorId,
  });
}

@immutable
class GetAnnotationData {
  final GetAnnotationAnnotation? annotation;
  GetAnnotationData.fromJson(dynamic json):
  
  annotation = json['annotation'] == null ? null : GetAnnotationAnnotation.fromJson(json['annotation']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnnotationData otherTyped = other as GetAnnotationData;
    return annotation == otherTyped.annotation;
    
  }
  @override
  int get hashCode => annotation.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (annotation != null) {
      json['annotation'] = annotation!.toJson();
    }
    return json;
  }

  GetAnnotationData({
    this.annotation,
  });
}

@immutable
class GetAnnotationVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetAnnotationVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAnnotationVariables otherTyped = other as GetAnnotationVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetAnnotationVariables({
    required this.id,
  });
}

