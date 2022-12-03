class roomObject {
  String referenceId = '';
  String roomName = '';
  String floorRef = '';
  double x = 0;
  double y = 0;

  roomObject(referenceId, roomName, floorRef, x, y){
    this.referenceId = referenceId;
    this.roomName = roomName;
    this.floorRef = floorRef;
    this.x = x;
    this.y = y;
  }

  void setValues(referenceId, roomName, floorRef, x, y){
    this.referenceId = referenceId;
    this.roomName = roomName;
    this.floorRef = floorRef;
    this.x = x;
    this.y = y;
  }
}