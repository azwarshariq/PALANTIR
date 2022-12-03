class roomObject {
  String referenceId = '';
  String roomName = '';
  String floorRef = '';

  roomObject(referenceId, roomName, floorRef){
    this.referenceId = referenceId;
    this.roomName = roomName;
    this.floorRef = floorRef;
  }

  void setValues(referenceId, routerName, floorRef, MAC){
    this.referenceId = referenceId;
    this.roomName = roomName;
    this.floorRef = floorRef;
  }
}