class elevatorObject {
  String referenceId = '';
  String elevatorName = '';
  String floorRef = '';
  double x = 0;
  double y = 0;

  elevatorObject(referenceId, elevatorName, floorRef, x, y){
    this.referenceId = referenceId;
    this.elevatorName = elevatorName;
    this.floorRef = floorRef;
    this.x = x;
    this.y = y;
  }

  void setValues(referenceId, elevatorName, floorRef, x, y){
    this.referenceId = referenceId;
    this.elevatorName = elevatorName;
    this.floorRef = floorRef;
    this.x = x;
    this.y = y;
  }
}