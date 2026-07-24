library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_project.dart';

part 'update_project.dart';

part 'delete_project.dart';

part 'get_project.dart';

part 'list_my_projects.dart';

part 'create_audio_file.dart';

part 'update_audio_file.dart';

part 'delete_audio_file.dart';

part 'get_audio_file.dart';

part 'list_project_audio_files.dart';

part 'create_peak_detail.dart';

part 'update_peak_detail.dart';

part 'delete_peak_detail.dart';

part 'get_peak_detail.dart';

part 'list_audio_peaks.dart';

part 'create_analysis_report.dart';

part 'update_analysis_report.dart';

part 'delete_analysis_report.dart';

part 'get_analysis_report.dart';

part 'list_audio_reports.dart';

part 'create_annotation.dart';

part 'update_annotation.dart';

part 'delete_annotation.dart';

part 'get_annotation.dart';

part 'list_peak_annotations.dart';


String? bigIntToJson(BigInt? value) {
  return value?.toString();
}

BigInt bigIntFromJson(dynamic value) {
  return BigInt.parse(value);
}






class ExampleConnector {
  
  
  CreateProjectVariablesBuilder createProject ({required String name, }) {
    return CreateProjectVariablesBuilder(dataConnect, name: name,);
  }
  
  
  UpdateProjectVariablesBuilder updateProject ({required String id, required String name, }) {
    return UpdateProjectVariablesBuilder(dataConnect, id: id,name: name,);
  }
  
  
  DeleteProjectVariablesBuilder deleteProject ({required String id, }) {
    return DeleteProjectVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetProjectVariablesBuilder getProject ({required String id, }) {
    return GetProjectVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListMyProjectsVariablesBuilder listMyProjects () {
    return ListMyProjectsVariablesBuilder(dataConnect, );
  }
  
  
  CreateAudioFileVariablesBuilder createAudioFile ({required String filename, required double duration, required String projectId, }) {
    return CreateAudioFileVariablesBuilder(dataConnect, filename: filename,duration: duration,projectId: projectId,);
  }
  
  
  UpdateAudioFileVariablesBuilder updateAudioFile ({required String id, required String status, }) {
    return UpdateAudioFileVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  DeleteAudioFileVariablesBuilder deleteAudioFile ({required String id, }) {
    return DeleteAudioFileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetAudioFileVariablesBuilder getAudioFile ({required String id, }) {
    return GetAudioFileVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListProjectAudioFilesVariablesBuilder listProjectAudioFiles ({required String projectId, }) {
    return ListProjectAudioFilesVariablesBuilder(dataConnect, projectId: projectId,);
  }
  
  
  CreatePeakDetailVariablesBuilder createPeakDetail ({required BigInt ts, required double amp, required String type, required String audioId, }) {
    return CreatePeakDetailVariablesBuilder(dataConnect, ts: ts,amp: amp,type: type,audioId: audioId,);
  }
  
  
  UpdatePeakDetailVariablesBuilder updatePeakDetail ({required String id, required double conf, }) {
    return UpdatePeakDetailVariablesBuilder(dataConnect, id: id,conf: conf,);
  }
  
  
  DeletePeakDetailVariablesBuilder deletePeakDetail ({required String id, }) {
    return DeletePeakDetailVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetPeakDetailVariablesBuilder getPeakDetail ({required String id, }) {
    return GetPeakDetailVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListAudioPeaksVariablesBuilder listAudioPeaks ({required String audioId, }) {
    return ListAudioPeaksVariablesBuilder(dataConnect, audioId: audioId,);
  }
  
  
  CreateAnalysisReportVariablesBuilder createAnalysisReport ({required double lbs, required int count, required int rate, required String audioId, }) {
    return CreateAnalysisReportVariablesBuilder(dataConnect, lbs: lbs,count: count,rate: rate,audioId: audioId,);
  }
  
  
  UpdateAnalysisReportVariablesBuilder updateAnalysisReport ({required String id, required double norm, }) {
    return UpdateAnalysisReportVariablesBuilder(dataConnect, id: id,norm: norm,);
  }
  
  
  DeleteAnalysisReportVariablesBuilder deleteAnalysisReport ({required String id, }) {
    return DeleteAnalysisReportVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetAnalysisReportVariablesBuilder getAnalysisReport ({required String id, }) {
    return GetAnalysisReportVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListAudioReportsVariablesBuilder listAudioReports ({required String audioId, }) {
    return ListAudioReportsVariablesBuilder(dataConnect, audioId: audioId,);
  }
  
  
  CreateAnnotationVariablesBuilder createAnnotation ({required String comment, required String peakId, }) {
    return CreateAnnotationVariablesBuilder(dataConnect, comment: comment,peakId: peakId,);
  }
  
  
  UpdateAnnotationVariablesBuilder updateAnnotation ({required String id, required String status, }) {
    return UpdateAnnotationVariablesBuilder(dataConnect, id: id,status: status,);
  }
  
  
  DeleteAnnotationVariablesBuilder deleteAnnotation ({required String id, }) {
    return DeleteAnnotationVariablesBuilder(dataConnect, id: id,);
  }
  
  
  GetAnnotationVariablesBuilder getAnnotation ({required String id, }) {
    return GetAnnotationVariablesBuilder(dataConnect, id: id,);
  }
  
  
  ListPeakAnnotationsVariablesBuilder listPeakAnnotations ({required String peakId, }) {
    return ListPeakAnnotationsVariablesBuilder(dataConnect, peakId: peakId,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-south1',
    'example',
    'transcriptionapp',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
