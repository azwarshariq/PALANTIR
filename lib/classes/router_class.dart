class routerObject {
  String referenceId = '';
  String routerName = '';
  String floorRef = '';
  String MACAddress = '';

  routerObject(referenceId, routerName, floorRef, MAC){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.MACAddress = MAC;
  }

  void setValues(referenceId, routerName, floorRef, MAC){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.MACAddress = MAC;
  }
}