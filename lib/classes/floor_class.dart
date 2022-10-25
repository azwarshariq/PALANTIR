class floorObject {
  String referenceId = '';
  String floorName = '';
  String buildingRef = '';
  int numRouters = 0;

  floorObject(referenceId, floorName, buildingRef, numRouters){
    this.referenceId = referenceId;
    this.floorName = floorName;
    this.buildingRef = buildingRef;
    this.numRouters = numRouters;
  }

  void setValues(referenceId, floorName, buildingRef, numRouters){
    this.referenceId = referenceId;
    this.floorName = floorName;
    this.buildingRef = buildingRef;
    this.numRouters = numRouters;
  }
}