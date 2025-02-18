import 'package:agenda/core/costants/string_constants.dart';
import '../../repository/base_repository.dart';
import '../models/event_model/event_model.dart';
import '../models/event_model_to_add/event_model_to_add.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class EventRepository extends BaseRepository {
  EventRepository(super.apiClient);

  Future<List<EventModel>> getAllEvents() async {
    final response = await apiClient.getList('events');
    return (response).map((json) => EventModel.fromJson(json)).toList();
  }

  Future<EventModel> getEventByUuid(String eventUuid) async {
    final response = await apiClient.get('events/$eventUuid');
    return EventModel.fromJson(response.data);
  }

  Future<void> createEvent(EventModelToAdd eventToAdd) async {
    await apiClient.post('events', eventToAdd.toJson());
  }

  Future<void> deleteEvent(String eventUuid) async {
    await apiClient.delete('events/$eventUuid', {});
  }

  Future<void> registerToEvent(String eventUuid) async {
    await apiClient.post('participants/subscribe/$eventUuid', {});
  }

  Future<void> unregisterFromEvent(String eventUuid) async {
    await apiClient.delete('participants/unscribe/$eventUuid', {});
  }

  Future<void> addNoteToEvent(String eventUuid, String noteContent) async {
    await apiClient.post('notes/$eventUuid', noteContent);
  }

  Future<void> uploadAttachment(
      String eventUuid, Uint8List fileBytes, String fileName) async {
    final formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
      "eventId": eventUuid,
    });

    try {
      await apiClient.postAttachments('/attachments/$eventUuid', formData);
    } catch (e) {
      throw Exception(StringConstants.attachmentUploadFailed);
    }
  }

  Future<void> downloadAttachment(int attachmentId, String fileName) async {
    try {
      final response = await apiClient.getAttachments('/attachments/$attachmentId/download',
          options: Options(responseType: ResponseType.bytes));

      // Create a Blob from the downloaded data
      final blob = html.Blob([response.data]);
      // Generate a temporary URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an invisible anchor element to trigger the download
      html.AnchorElement(href: url)
        ..target = 'blank' // Open in a new tab
        ..download = fileName // Set the filename for the downloaded file
        ..click(); // Simulate a click to start the download

      // Revoke the object URL to free up memory
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception(StringConstants.attachmentDownloadFailed);
    }
  }
}
