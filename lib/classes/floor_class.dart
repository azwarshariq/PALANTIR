class floorObject {
  String referenceId = '';
  String floorName = '';
  String buildingRef = '';
  int numRouters = 0;
  String floorPlan = '';

  floorObject(referenceId, floorName, buildingRef, numRouters, floorPlan){
    this.referenceId = referenceId;
    this.floorName = floorName;
    this.buildingRef = buildingRef;
    this.numRouters = numRouters;
    this.floorPlan = floorPlan;
  }

  void setValues(referenceId, floorName, buildingRef, numRouters, floorPlan){
    this.referenceId = referenceId;
    this.floorName = floorName;
    this.buildingRef = buildingRef;
    this.numRouters = numRouters;
    this.floorPlan = floorPlan;
  }

  void updateFloorPlan(floorPlan){
    this.floorPlan = floorPlan;
  }
}