stringer(var bools, String value) {
  var b = value.split(" ");
  int i = 0;
  for (String x in bools.keys) {
    bools[x] = b[i] == 'T' ? true : false;
    i++;
  }

  // for (int i=0; i < bools.length; i++) {
  //   x.add(b[i] == 'T' ? true : false);
  // }
  // bools = new Map<String,bool>.fromIterables(bools.keys, x.getRange(0, x.length));
  print(bools);
  return bools;
}

initBool() {
  return {
    'Tap': true, //tap
    'Up': false, //up
    'Down': false, //down
    'Hold': false, //hold
    'Current': true, //curent text
    'Subhanallah': true, //subhanallah
    'Alhamdulillah': true, //alhamdulillah
    'Allahuakbar': true, //allahuakbar
    'Lailahailallah': true, //lailahaillallah
  };
}

counterSetter(){

}

counterLimitSetter(){
  
}