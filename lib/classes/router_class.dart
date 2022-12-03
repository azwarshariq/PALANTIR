class routerObject {
  String referenceId = '';
  String routerName = '';
  String floorRef = '';
  String BSSID = '';
  double x = 0;
  double y = 0;

  routerObject(referenceId, routerName, floorRef, MAC, x, y){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.BSSID = MAC;
    this.x = x;
    this.y = y;
  }

  void setValues(referenceId, routerName, floorRef, MAC, x, y){
    this.referenceId = referenceId;
    this.routerName = routerName;
    this.floorRef = floorRef;
    this.BSSID = MAC;
    this.x = x;
    this.y = y;
  }
}