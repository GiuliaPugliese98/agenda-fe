import '../../network/api_client.dart';
import '../../repository/base_repository.dart';
import '../models/event_model/event_model.dart';
import '../models/event_model_to_add/event_model_to_add.dart';

class EventRepository extends BaseRepository {
  EventRepository(ApiClient apiClient) : super(apiClient);

  Future<List<EventModel>> getAllEvents() async {
    final response = await apiClient.getList('events');
    return (response).map((json) => EventModel.fromJson(json)).toList();
  }

  Future<EventModel> getEventById(int eventId) async {
    final response = await apiClient.get('events/$eventId');
    return EventModel.fromJson(response);
  }

  Future<void> createEvent(EventModelToAdd eventToAdd) async {
    await apiClient.post('events', eventToAdd.toJson());
  }

  Future<void> updateEvent(int eventId, EventModelToAdd updatedEvent) async {
    await apiClient.put('events/$eventId', updatedEvent.toJson());
  }

  Future<void> deleteEvent(String eventId) async {
    //TODO
  }

  Future<void> registerToEvent(String eventId) async {
    await apiClient.post('participants/subscribe/$eventId', {});
  }

  Future<void> unregisterFromEvent(String eventId) async {
    await apiClient.delete('participants/unscribe/$eventId', {});
  }
}
