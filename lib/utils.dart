
enum CHECK_STATUS { INITIAL, SUCCESS, FAIL }

class Event {
  String type;

  Event(String type) {
    this.type = type;
  }
}
