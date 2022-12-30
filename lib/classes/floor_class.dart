class floorObject {
  String referenceId = '';
  String floorName = '';
  String buildingRef = '';
  int numRouters = 0;
  String floorPlan = '';
  int collectedDataPoints = 0;

  floorObject(referenceId, floorName, buildingRef, numRouters, floorPlan, collectedDataPoints){
    this.referenceId = referenceId;
    this.floorName = floorName;
    this.buildingRef = buildingRef;
    this.numRouters = numRouters;
    this.floorPlan = floorPlan;
    this.collectedDataPoints = collectedDataPoints;
  }

  void setValues(referenceId, floorName, buildingRef, numRouters, floorPlan, collectedDataPoints){
    this.referenceId = referenceId;
    this.floorName = floorName;
    this.buildingRef = buildingRef;
    this.numRouters = numRouters;
    this.floorPlan = floorPlan;
    this.collectedDataPoints = collectedDataPoints;
  }

  void updateFloorPlan(floorPlan){
    this.floorPlan = floorPlan;
  }
}