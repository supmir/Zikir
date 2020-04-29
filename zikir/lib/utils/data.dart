import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
part 'data.g.dart';



@JsonSerializable(nullable: true)
class Data {
  Interactions interactions;
  Counters counters;

  Data(this.interactions, this.counters);
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  String getJsonString() {
    return jsonEncode(this.toJson());
  }
}

@JsonSerializable(nullable: true)
class Interactions {
  var bools;

  Interactions(var bools) {
    this.bools = bools;
  }
  factory Interactions.fromJson(Map<String, dynamic> json) =>
      _$InteractionsFromJson(json);

  Map<String, dynamic> toJson() => _$InteractionsToJson(this);

  void switchSomething(String key) {
    if (bools.containsKey(key)) {
      bools[key] = !bools[key];
    } else {
      print("Missing key $key");
    }
  }
}

@JsonSerializable(nullable: true)
class Counter {
  String name;
  String sentence;
  int value;
  int maxValue;
  bool active = true;

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);

  Map<String, dynamic> toJson() => _$CounterToJson(this);

  Counter(String name, String sentence, int value, int maxValue) {
    this.name = name;
    this.sentence = sentence;
    this.value = value;
    this.maxValue = maxValue;
    this.active = true;
  }
  Counter.def() {
    this.name = "";
    this.sentence = "";
    this.value = 0;
    this.maxValue = 99;
    this.active = true;
  }

  setName(String name) {
    this.name = name;
  }

  setSentence(String sentence) {
    this.sentence = sentence;
  }

  setMaxValue(int maxValue) {
    this.maxValue = maxValue;
  }

  setActive() {
    this.active = !this.active;
  }
}

@JsonSerializable(nullable: true)
class Counters {
  int headCount = 0;
  Map<String, Counter> counterList = {};

  Counters();

  factory Counters.fromJson(Map<String, dynamic> json) =>
      _$CountersFromJson(json);

  Map<String, dynamic> toJson() => _$CountersToJson(this);

  changeActive(String key) {
    counterList[key].setActive();
    headCount = 0;
    resetHeadcount();
  }

  int resetHeadcount() {
    headCount = 0;
    for (String key in counterList.keys) {
      if (counterList[key].active) headCount += counterList[key].value;
    }
    print("Headcount = $headCount");
    return headCount;
  }

  addNew(String name, String sentence, int value, int maxValue) {
    Counter temp = new Counter(name, sentence, value, maxValue);
    counterList[name] = temp;
    return temp;
  }

  addNewByCounter(Counter counter) {
    counterList[counter.name] = counter;
  }

  updateValue(String key, int value) {
    counterList[key].value = value;
  }

  update(bool reset) {
    // int tempCount = headCount;
    Counter temp;
    // bool reachedZero = false;
    resetHeadcount();

    for (String key in counterList.keys) {
      if (!counterList[key].active) continue;
      if (counterList[key].value < counterList[key].maxValue) {
        if (!reset) counterList[key].value++;
        print("${counterList[key].value},${counterList[key].maxValue}");
        if (counterList[key].value == counterList[key].maxValue) {
          Vibration.vibrate(duration: 1000);
          FlutterRingtonePlayer.playNotification();
        }
        temp = counterList[key];
        break;
      }
    }
    resetHeadcount();

    // for (String key in counterList.keys) {
    //   if (!counterList[key].active) continue;
    //   int max = counterList[key].maxValue;
    //   if (headCount > max) {
    //     updateValue(key, max);
    //     tempCount -= max;
    //   } else if (tempCount >= 0) {
    //     updateValue(key, tempCount);
    //     tempCount -= tempCount;
    //     if (!reachedZero) {
    //       temp = counterList[key];
    //       reachedZero = true;
    //     }
    //   }
    // }
    if (temp == null) {
      // counterList["            "] = new Counter("          ","          ",0,9999999999999999);
      return addNew("          ", "          ", 0, 999999999999);
    }

    return temp;
  }

  int getTotal() {
    // int total = 0;
    // for (String key in counterList.keys) {
    //   total += counterList[key].value;
    // }
    return resetHeadcount();
    ;
  }

  void removeByString(String name) {
    if (counterList.containsKey(name)) counterList.remove(name);
  }

  void reset() {
    for (String key in counterList.keys) {
      if (counterList[key].active) counterList[key].value = 0;
    }
    resetHeadcount();
  }
}
