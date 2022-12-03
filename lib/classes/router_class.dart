class routerObject {
  String referenceId = '';
  String routerName = '';
  String floorRef = '';
  String BSSID = '';

  routerObject(referenceId, routerName, floorRef, MAC){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.BSSID = MAC;
  }

  void setValues(referenceId, routerName, floorRef, MAC){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.BSSID = MAC;
  }
}