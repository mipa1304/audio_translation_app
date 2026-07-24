# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetProject
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getProject(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProjectData, GetProjectVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getProject(
  id: id,
);
GetProjectData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getProject(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMyProjects
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listMyProjects().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMyProjectsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMyProjects();
ListMyProjectsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listMyProjects().ref();
ref.execute();

ref.subscribe(...);
```


### GetAudioFile
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getAudioFile(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAudioFileData, GetAudioFileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAudioFile(
  id: id,
);
GetAudioFileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getAudioFile(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListProjectAudioFiles
#### Required Arguments
```dart
String projectId = ...;
ExampleConnector.instance.listProjectAudioFiles(
  projectId: projectId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListProjectAudioFilesData, ListProjectAudioFilesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listProjectAudioFiles(
  projectId: projectId,
);
ListProjectAudioFilesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String projectId = ...;

final ref = ExampleConnector.instance.listProjectAudioFiles(
  projectId: projectId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPeakDetail
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getPeakDetail(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPeakDetailData, GetPeakDetailVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPeakDetail(
  id: id,
);
GetPeakDetailData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getPeakDetail(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListAudioPeaks
#### Required Arguments
```dart
String audioId = ...;
ExampleConnector.instance.listAudioPeaks(
  audioId: audioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListAudioPeaksData, ListAudioPeaksVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listAudioPeaks(
  audioId: audioId,
);
ListAudioPeaksData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String audioId = ...;

final ref = ExampleConnector.instance.listAudioPeaks(
  audioId: audioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetAnalysisReport
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getAnalysisReport(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAnalysisReportData, GetAnalysisReportVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAnalysisReport(
  id: id,
);
GetAnalysisReportData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getAnalysisReport(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListAudioReports
#### Required Arguments
```dart
String audioId = ...;
ExampleConnector.instance.listAudioReports(
  audioId: audioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListAudioReportsData, ListAudioReportsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listAudioReports(
  audioId: audioId,
);
ListAudioReportsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String audioId = ...;

final ref = ExampleConnector.instance.listAudioReports(
  audioId: audioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetAnnotation
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getAnnotation(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAnnotationData, GetAnnotationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAnnotation(
  id: id,
);
GetAnnotationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getAnnotation(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListPeakAnnotations
#### Required Arguments
```dart
String peakId = ...;
ExampleConnector.instance.listPeakAnnotations(
  peakId: peakId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPeakAnnotationsData, ListPeakAnnotationsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listPeakAnnotations(
  peakId: peakId,
);
ListPeakAnnotationsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String peakId = ...;

final ref = ExampleConnector.instance.listPeakAnnotations(
  peakId: peakId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateProject
#### Required Arguments
```dart
String name = ...;
ExampleConnector.instance.createProject(
  name: name,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateProjectData, CreateProjectVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createProject(
  name: name,
);
CreateProjectData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;

final ref = ExampleConnector.instance.createProject(
  name: name,
).ref();
ref.execute();
```


### UpdateProject
#### Required Arguments
```dart
String id = ...;
String name = ...;
ExampleConnector.instance.updateProject(
  id: id,
  name: name,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateProjectData, UpdateProjectVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateProject(
  id: id,
  name: name,
);
UpdateProjectData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;

final ref = ExampleConnector.instance.updateProject(
  id: id,
  name: name,
).ref();
ref.execute();
```


### DeleteProject
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteProject(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteProjectData, DeleteProjectVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteProject(
  id: id,
);
DeleteProjectData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteProject(
  id: id,
).ref();
ref.execute();
```


### CreateAudioFile
#### Required Arguments
```dart
String filename = ...;
double duration = ...;
String projectId = ...;
ExampleConnector.instance.createAudioFile(
  filename: filename,
  duration: duration,
  projectId: projectId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateAudioFileData, CreateAudioFileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createAudioFile(
  filename: filename,
  duration: duration,
  projectId: projectId,
);
CreateAudioFileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String filename = ...;
double duration = ...;
String projectId = ...;

final ref = ExampleConnector.instance.createAudioFile(
  filename: filename,
  duration: duration,
  projectId: projectId,
).ref();
ref.execute();
```


### UpdateAudioFile
#### Required Arguments
```dart
String id = ...;
String status = ...;
ExampleConnector.instance.updateAudioFile(
  id: id,
  status: status,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateAudioFileData, UpdateAudioFileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateAudioFile(
  id: id,
  status: status,
);
UpdateAudioFileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String status = ...;

final ref = ExampleConnector.instance.updateAudioFile(
  id: id,
  status: status,
).ref();
ref.execute();
```


### DeleteAudioFile
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteAudioFile(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteAudioFileData, DeleteAudioFileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteAudioFile(
  id: id,
);
DeleteAudioFileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteAudioFile(
  id: id,
).ref();
ref.execute();
```


### CreatePeakDetail
#### Required Arguments
```dart
BigInt ts = ...;
double amp = ...;
String type = ...;
String audioId = ...;
ExampleConnector.instance.createPeakDetail(
  ts: ts,
  amp: amp,
  type: type,
  audioId: audioId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreatePeakDetailData, CreatePeakDetailVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPeakDetail(
  ts: ts,
  amp: amp,
  type: type,
  audioId: audioId,
);
CreatePeakDetailData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
BigInt ts = ...;
double amp = ...;
String type = ...;
String audioId = ...;

final ref = ExampleConnector.instance.createPeakDetail(
  ts: ts,
  amp: amp,
  type: type,
  audioId: audioId,
).ref();
ref.execute();
```


### UpdatePeakDetail
#### Required Arguments
```dart
String id = ...;
double conf = ...;
ExampleConnector.instance.updatePeakDetail(
  id: id,
  conf: conf,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdatePeakDetailData, UpdatePeakDetailVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updatePeakDetail(
  id: id,
  conf: conf,
);
UpdatePeakDetailData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
double conf = ...;

final ref = ExampleConnector.instance.updatePeakDetail(
  id: id,
  conf: conf,
).ref();
ref.execute();
```


### DeletePeakDetail
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deletePeakDetail(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeletePeakDetailData, DeletePeakDetailVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deletePeakDetail(
  id: id,
);
DeletePeakDetailData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deletePeakDetail(
  id: id,
).ref();
ref.execute();
```


### CreateAnalysisReport
#### Required Arguments
```dart
double lbs = ...;
int count = ...;
int rate = ...;
String audioId = ...;
ExampleConnector.instance.createAnalysisReport(
  lbs: lbs,
  count: count,
  rate: rate,
  audioId: audioId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateAnalysisReportData, CreateAnalysisReportVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createAnalysisReport(
  lbs: lbs,
  count: count,
  rate: rate,
  audioId: audioId,
);
CreateAnalysisReportData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
double lbs = ...;
int count = ...;
int rate = ...;
String audioId = ...;

final ref = ExampleConnector.instance.createAnalysisReport(
  lbs: lbs,
  count: count,
  rate: rate,
  audioId: audioId,
).ref();
ref.execute();
```


### UpdateAnalysisReport
#### Required Arguments
```dart
String id = ...;
double norm = ...;
ExampleConnector.instance.updateAnalysisReport(
  id: id,
  norm: norm,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateAnalysisReportData, UpdateAnalysisReportVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateAnalysisReport(
  id: id,
  norm: norm,
);
UpdateAnalysisReportData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
double norm = ...;

final ref = ExampleConnector.instance.updateAnalysisReport(
  id: id,
  norm: norm,
).ref();
ref.execute();
```


### DeleteAnalysisReport
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteAnalysisReport(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteAnalysisReportData, DeleteAnalysisReportVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteAnalysisReport(
  id: id,
);
DeleteAnalysisReportData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteAnalysisReport(
  id: id,
).ref();
ref.execute();
```


### CreateAnnotation
#### Required Arguments
```dart
String comment = ...;
String peakId = ...;
ExampleConnector.instance.createAnnotation(
  comment: comment,
  peakId: peakId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateAnnotationData, CreateAnnotationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createAnnotation(
  comment: comment,
  peakId: peakId,
);
CreateAnnotationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String comment = ...;
String peakId = ...;

final ref = ExampleConnector.instance.createAnnotation(
  comment: comment,
  peakId: peakId,
).ref();
ref.execute();
```


### UpdateAnnotation
#### Required Arguments
```dart
String id = ...;
String status = ...;
ExampleConnector.instance.updateAnnotation(
  id: id,
  status: status,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateAnnotationData, UpdateAnnotationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateAnnotation(
  id: id,
  status: status,
);
UpdateAnnotationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String status = ...;

final ref = ExampleConnector.instance.updateAnnotation(
  id: id,
  status: status,
).ref();
ref.execute();
```


### DeleteAnnotation
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteAnnotation(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteAnnotationData, DeleteAnnotationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteAnnotation(
  id: id,
);
DeleteAnnotationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteAnnotation(
  id: id,
).ref();
ref.execute();
```

