part of '../unit_screen.dart';

class _ServicesSection extends StatelessWidget {
  const _ServicesSection({super.key});

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
        Text(lang.services_title),
        ...getServiceWidgets(servicesList),
        const Divider(color: Colors.grey, height: 1),
      ],
    );
  }

  List<_ServiceItem> _loadServicesList(BuildContext context) {
    final UnitModel unit = InheritedUnit.of(context);

    final List<_ServiceItem> list = KServicesKeys.allKeys
        .map(
          (serviceKey) {
            if (unit.services.services[serviceKey] == null ||
                unit.services.services[serviceKey] == false) {
              return null;
            }

            return _ServiceItem(
              icon: KServicesKeys.serviceIcon[serviceKey] ?? '',
              title: KServicesKeys.getTitle(context, serviceKey) ?? '',
            );
          },
        )
        .whereType<_ServiceItem>()
        .toList();

    return list;
  }
}
