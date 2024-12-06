import 'package:flutter/material.dart';

class BreadCrumb extends StatelessWidget {
  final List<String> breadcrumb;
  final IconData icon;
  const BreadCrumb({super.key, required this.breadcrumb, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      height: 40.0,
      width: double.infinity,
      color: Color.fromRGBO(38, 42, 79, 1),
      child: Row(
        children: breadcrumb
            .asMap()
            .entries
            .map(
              (entry) => BreadCrumbItem(
                name: entry.value,
                isFirst: entry.key == 0,
                breadcrumb: breadcrumb,
                icon: icon,
              ),
            )
            .toList(),
      ),
    );
  }
}

class BreadCrumbItem extends StatefulWidget {
  final String name;
  final bool isFirst;
  final breadcrumb;
  final icon;

  const BreadCrumbItem({super.key, required this.name, required this.isFirst, this.breadcrumb, this.icon});

  @override
  State<BreadCrumbItem> createState() => _BreadCrumbItemState();
}

class _BreadCrumbItemState extends State<BreadCrumbItem> {
  bool onIt = false;
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.isFirst? Padding(padding: EdgeInsets.only(right: 8),child: Icon(widget.icon, color: Colors.white,),): const Icon(Icons.chevron_right, color: Colors.white,),
        GestureDetector(
          onTap: () {
            while (widget.breadcrumb.last != widget.name) {
              setState((){
                Navigator.pop(context);
              });
            }
          },
          child: MouseRegion(
            opaque: true,
            onEnter: (_) {
              setState(() {
                onIt = true;
                color = const Color.fromARGB(255, 21, 101, 192);
              });
            },
            onExit: (_) {
              setState(() {
                onIt = false;
                color = Colors.white;
              });
            },
            child: Text(
              widget.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.3,
                    color:
                        (widget.name == widget.breadcrumb.last) ? Colors.white : color,
                    decoration: onIt && widget.name != widget.breadcrumb.last
                    ? TextDecoration.underline
                    : TextDecoration.none,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
