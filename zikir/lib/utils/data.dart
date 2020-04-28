class Data {
  Interactions interactions;
  Counters counters;

  Data(this.interactions, this.counters);

  Data.fromJson(Map<String, dynamic> json)
      : interactions = json['interactions'],
        counters = json['counters'];

  Map<String, dynamic> toJson() => {
        'interactions': interactions,
        'counters': counters,
      };

  String getJsonString() {
    return this.toJson().toString();
  }
}

class boolList{
  List<bool> list;
  
}

class Interactions {
  bool tap;
  bool up;
  bool down;
  bool hold;
  void switchSomething(int which) {
    switch (which) {
      case 1:
        tap = !tap;
        break;
      case 2:
        up = !up;
        break;
      case 3:
        down = !down;
        break;
      case 4:
        hold = !hold;
        break;
    }
  }
}

class Counter {
  String name;
  String sentence;
  int value;
  int maxValue;

  Counter(String name, String sentence, int value, int maxValue) {
    this.name = name;
    this.sentence = sentence;
    this.value = value;
    this.maxValue = maxValue;
  }
}

class Counters {
  Map<String, Counter> counterList;
  addNew(String name, String sentence, int value, int maxValue) {
    counterList[name] = new Counter(name, sentence, value, maxValue);
  }
}
