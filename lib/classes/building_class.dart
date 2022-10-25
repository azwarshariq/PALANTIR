class buildingObject {
  String referenceId = '';
  String buildingName = '';
  String userRef = '';
  int numFloors = 0;

  buildingObject(referenceId, buildingName, userRef, numFloors){
    this.referenceId = referenceId;
    this.buildingName = buildingName;
    this.userRef = userRef;
    this.numFloors = numFloors;
  }
}
