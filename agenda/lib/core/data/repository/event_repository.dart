import '../../network/api_client.dart';
import '../../repository/base_repository.dart';
import '../models/event_model/event_model.dart';
import '../models/event_model_to_add/event_model_to_add.dart';
import '../models/note_model/note_model.dart';

class EventRepository extends BaseRepository {
  EventRepository(ApiClient apiClient) : super(apiClient);

  Future<List<EventModel>> getAllEvents() async {
    final response = await apiClient.getList('events');
    return (response).map((json) => EventModel.fromJson(json)).toList();
  }

  Future<EventModel> getEventByUuid(String eventUuid) async {
    final response = await apiClient.get('events/$eventUuid');
    return EventModel.fromJson(response);
  }

  Future<void> createEvent(EventModelToAdd eventToAdd) async {
    await apiClient.post('events', eventToAdd.toJson());
  }

  Future<void> updateEvent(int eventId, EventModelToAdd updatedEvent) async {
    await apiClient.put('events/$eventId', updatedEvent.toJson());
  }

  Future<void> deleteEvent(String eventUuid) async {
    await apiClient.delete('events/$eventUuid', {});
  }

  Future<void> registerToEvent(String eventId) async {
    await apiClient.post('participants/subscribe/$eventId', {});
  }

  Future<void> unregisterFromEvent(String eventId) async {
    await apiClient.delete('participants/unscribe/$eventId', {});
  }

  Future<void> addNoteToEvent(String eventUuid, String noteContent) async {
    await apiClient.postNote('notes/$eventUuid', noteContent);
  }
}
