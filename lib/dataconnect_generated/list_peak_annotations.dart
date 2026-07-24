part of 'generated.dart';

class ListPeakAnnotationsVariablesBuilder {
  String peakId;

  final FirebaseDataConnect _dataConnect;
  ListPeakAnnotationsVariablesBuilder(this._dataConnect, {required  this.peakId,});
  Deserializer<ListPeakAnnotationsData> dataDeserializer = (dynamic json)  => ListPeakAnnotationsData.fromJson(jsonDecode(json));
  Serializer<ListPeakAnnotationsVariables> varsSerializer = (ListPeakAnnotationsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListPeakAnnotationsData, ListPeakAnnotationsVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListPeakAnnotationsData, ListPeakAnnotationsVariables> ref() {
    ListPeakAnnotationsVariables vars= ListPeakAnnotationsVariables(peakId: peakId,);
    return _dataConnect.query("ListPeakAnnotations", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListPeakAnnotationsAnnotations {
  final String id;
  final String comment;
  final String status;
  ListPeakAnnotationsAnnotations.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  comment = nativeFromJson<String>(json['comment']),
  status = nativeFromJson<String>(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPeakAnnotationsAnnotations otherTyped = other as ListPeakAnnotationsAnnotations;
    return id == otherTyped.id && 
    comment == otherTyped.comment && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, comment.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['comment'] = nativeToJson<String>(comment);
    json['status'] = nativeToJson<String>(status);
    return json;
  }

  ListPeakAnnotationsAnnotations({
    required this.id,
    required this.comment,
    required this.status,
  });
}

@immutable
class ListPeakAnnotationsData {
  final List<ListPeakAnnotationsAnnotations> annotations;
  ListPeakAnnotationsData.fromJson(dynamic json):
  
  annotations = (json['annotations'] as List<dynamic>)
        .map((e) => ListPeakAnnotationsAnnotations.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPeakAnnotationsData otherTyped = other as ListPeakAnnotationsData;
    return annotations == otherTyped.annotations;
    
  }
  @override
  int get hashCode => annotations.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['annotations'] = annotations.map((e) => e.toJson()).toList();
    return json;
  }

  ListPeakAnnotationsData({
    required this.annotations,
  });
}

@immutable
class ListPeakAnnotationsVariables {
  final String peakId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListPeakAnnotationsVariables.fromJson(Map<String, dynamic> json):
  
  peakId = nativeFromJson<String>(json['peakId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListPeakAnnotationsVariables otherTyped = other as ListPeakAnnotationsVariables;
    return peakId == otherTyped.peakId;
    
  }
  @override
  int get hashCode => peakId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['peakId'] = nativeToJson<String>(peakId);
    return json;
  }

  ListPeakAnnotationsVariables({
    required this.peakId,
  });
}

