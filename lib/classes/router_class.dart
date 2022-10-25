class routerObject {
  String referenceId = '';
  String routerName = '';
  String floorRef = '';
  String MACAddress = '';

  buildingObject(referenceId, routerName, floorRef, MAC){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.MACAddress = MAC;
  }
}