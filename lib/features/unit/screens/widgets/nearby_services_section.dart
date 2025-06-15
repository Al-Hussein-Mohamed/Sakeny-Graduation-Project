part of '../unit_screen.dart';

class _NearbyServicesSection extends StatelessWidget {
  const _NearbyServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    final List<_ServiceItem> servicesList = _loadServicesList(context);

    if (servicesList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const SizedBox(height: 2),
        Text(lang.nearby_services),
        ...getServiceWidgets(servicesList),
        const Divider(color: Colors.grey, height: 1),
      ],
    );
  }

  List<_ServiceItem> _loadServicesList(BuildContext context) {
    final UnitModel unit = InheritedUnit.of(context);
    final List<_ServiceItem> list = KNearbyServicesKeys.allKeys
        .map(
          (serviceKey) {
            if (unit.nearbyServices.services[serviceKey] == null ||
                unit.nearbyServices.services[serviceKey] == false) {
              return null;
            }
            return _ServiceItem(
              icon: KNearbyServicesKeys.serviceIcon[serviceKey] ?? '',
              title: KNearbyServicesKeys.getTitle(context, serviceKey) ?? '',
            );
          },
        )
        .whereType<_ServiceItem>()
        .toList();

    return list;
  }
}
