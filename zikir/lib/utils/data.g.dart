// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['interactions'] == null
        ? null
        : Interactions.fromJson(json['interactions'] as Map<String, dynamic>),
    json['counters'] == null
        ? null
        : Counters.fromJson(json['counters'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'interactions': instance.interactions,
      'counters': instance.counters,
    };

Interactions _$InteractionsFromJson(Map<String, dynamic> json) {
  return Interactions(
    json['bools'],
  );
}

Map<String, dynamic> _$InteractionsToJson(Interactions instance) =>
    <String, dynamic>{
      'bools': instance.bools,
    };

Counter _$CounterFromJson(Map<String, dynamic> json) {
  return Counter(
    json['name'] as String,
    json['sentence'] as String,
    json['value'] as int,
    json['maxValue'] as int,
  )..active = json['active'] as bool;
}

Map<String, dynamic> _$CounterToJson(Counter instance) => <String, dynamic>{
      'name': instance.name,
      'sentence': instance.sentence,
      'value': instance.value,
      'maxValue': instance.maxValue,
      'active': instance.active,
    };

Counters _$CountersFromJson(Map<String, dynamic> json) {
  return Counters()
    ..counterList = (json['counterList'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Counter.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$CountersToJson(Counters instance) => <String, dynamic>{
      'counterList': instance.counterList,
    };
