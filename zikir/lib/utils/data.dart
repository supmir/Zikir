import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
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

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);

  Map<String, dynamic> toJson() => _$CounterToJson(this);

  Counter(String name, String sentence, int value, int maxValue) {
    this.name = name;
    this.sentence = sentence;
    this.value = value;
    this.maxValue = maxValue;
  }
}

@JsonSerializable(nullable: true)
class Counters {
  Map<String, Counter> counterList = {};

  Counters();

  factory Counters.fromJson(Map<String, dynamic> json) =>
      _$CountersFromJson(json);

  Map<String, dynamic> toJson() => _$CountersToJson(this);

  addNew(String name, String sentence, int value, int maxValue) {
    Counter temp = new Counter(name, sentence, value, maxValue);
    counterList[name] = temp;
    // counterList.update(name, temp);
  }
}
