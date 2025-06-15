part of '../unit_screen.dart';

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(
            getTextColor(context),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

List<Widget> getServiceWidgets(List<_ServiceItem> servicesList) {
  final List<Widget> widgets = [];
  for (int i = 0; i + 1 < servicesList.length; i += 2) {
    widgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: servicesList[i]),
          Expanded(child: servicesList[i + 1]),
        ],
      ),
    );
  }

  if (servicesList.length % 2 != 0) {
    widgets.add(servicesList.last);
  }

  return widgets;
}
