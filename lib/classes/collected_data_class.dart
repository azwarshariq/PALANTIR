class collectedData {
  String referenceId = '';
  List<String> listOfBSSIDs = [];
  List<int> listOfFrequencies = [];
  List<int> listOfStrengths = [];
  double x = 0.0;
  double y = 0.0;

  collectedData(referenceId, listOfBSSIDs, listOfFrequencies, listOfStrengths, x, y){
    this.referenceId = referenceId;
    this.listOfBSSIDs = listOfBSSIDs;
    this.listOfFrequencies = listOfFrequencies;
    this.listOfStrengths = listOfStrengths;
    this.x = x;
    this.y = y;
  }

  void setValues(referenceId, listOfBSSIDs, listOfFrequencies, listOfStrengths, x, y){
    this.referenceId = referenceId;
    this.listOfBSSIDs = listOfBSSIDs;
    this.listOfFrequencies = listOfFrequencies;
    this.listOfStrengths = listOfStrengths;
    this.x = x;
    this.y = y;
  }
}