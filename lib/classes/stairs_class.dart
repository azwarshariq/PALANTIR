class stairsObject {
  String referenceId = '';
  String stairsName = '';
  String floorRef = '';
  double x = 0;
  double y = 0;

  stairsObject(referenceId, stairsName, floorRef, x, y){
    this.referenceId = referenceId;
    this.stairsName = stairsName;
    this.floorRef = floorRef;
    this.x = x;
    this.y = y;
  }

  void setValues(referenceId, stairsName, floorRef, x, y){
    this.referenceId = referenceId;
    this.stairsName = stairsName;
    this.floorRef = floorRef;
    this.x = x;
    this.y = y;
  }
}