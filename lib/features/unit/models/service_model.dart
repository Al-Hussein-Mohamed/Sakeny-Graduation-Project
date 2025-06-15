import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/generated/l10n.dart';

class KServicesKeys {
  static const String elevator = 'elevator';
  static const String balcony = 'balcony';
  static const String airConditioner = 'airConditioner';
  static const String landLine = 'landLine';
  static const String wifi = 'wifi';
  static const String tv = 'tv';
  static const String naturalGas = 'naturalGas';
  static const String waterHeater = 'waterHeater';

  static final int wifiBit = 1 << 0;
  static final int tvBit = 1 << 1;
  static final int waterHeaterBit = 1 << 2;
  static final int airConditionerBit = 1 << 3;
  static final int naturalGasBit = 1 << 4;
  static final int elevatorBit = 1 << 5;
  static final int balconyBit = 1 << 6;
  static final int landLineBit = 1 << 7;

  // Change the order of keys to Change the order of the services in Unit screen
  static const List<String> allKeys = [
    elevator,
    balcony,
    airConditioner,
    landLine,
    wifi,
    tv,
    naturalGas,
    waterHeater,
  ];

  static final Map<String, int> serviceBit = {
    elevator: elevatorBit,
    balcony: balconyBit,
    airConditioner: airConditionerBit,
    landLine: landLineBit,
    wifi: wifiBit,
    tv: tvBit,
    naturalGas: naturalGasBit,
    waterHeater: waterHeaterBit,
  };

  static final Map<String, String> serviceIcon = {
    elevator: ConstImages.elevatorService,
    balcony: ConstImages.balconyService,
    airConditioner: ConstImages.airConditioningService,
    landLine: ConstImages.landlineService,
    wifi: ConstImages.wifiService,
    tv: ConstImages.tvService,
    naturalGas: ConstImages.naturalGasService,
    waterHeater: ConstImages.waterMeterService,
  };

  static bool isServicesAvailable(String service, int msk) {
    return (msk & serviceBit[service]!) != 0;
  }

  static String getTitle(BuildContext context, String key) {
    final S lang = S.of(context);
    switch (key) {
      case elevator:
        return lang.services_elevator;
      case balcony:
        return lang.services_balcony;
      case airConditioner:
        return lang.services_airConditioner;
      case landLine:
        return lang.services_landLine;
      case wifi:
        return lang.services_wifi;
      case tv:
        return lang.services_tv;
      case naturalGas:
        return lang.services_naturalGas;
      case waterHeater:
        return lang.services_waterHeater;
      default:
        return '';
    }
  }
}

class ServicesModel extends Equatable {
  const ServicesModel({required this.msk, required this.services});

  final int msk;
  final Map<String, bool> services;

  int toMask() {
    int mask = 0;
    for (final e in services.entries) {
      if (e.value) {
        mask |= KServicesKeys.serviceBit[e.key]!;
      }
    }

    return mask;
  }

  // ignore: sort_constructors_first
  factory ServicesModel.fromMask(int mask) {
    return ServicesModel(
      msk: mask,
      services: Map.fromEntries(
        KServicesKeys.allKeys.map(
          (e) => MapEntry(e, KServicesKeys.isServicesAvailable(e, mask)),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [
        msk,
        services,
      ];
}
