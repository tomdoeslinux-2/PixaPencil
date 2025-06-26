import 'package:flutter/material.dart';

class IconDropdownItem {
  final String key;
  final Widget icon;

  const IconDropdownItem({
    required this.key,
    required this.icon,
  });
}

class IconDropdownMenu extends StatefulWidget {
  final List<IconDropdownItem> items;
  final void Function(String key) onItemSelected;

  const IconDropdownMenu({
    super.key,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<IconDropdownMenu> createState() => _IconDropdownMenuState();
}

class _IconDropdownMenuState extends State<IconDropdownMenu> {
  final MenuController _controller = MenuController();
  final GlobalKey _buttonKey = GlobalKey();
  late String _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.items.first.key;
  }

  void _toggleMenu() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem =
        widget.items.firstWhere((item) => item.key == _selectedKey);

    return MenuAnchor(
      controller: _controller,
      alignmentOffset: const Offset(0, -4),
      style: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
      ),
      builder: (context, controller, child) {
        return Material(
          key: _buttonKey,
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              _toggleMenu();
            },
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  selectedItem.icon,
                  Icon(
                    _controller.isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color(0xFF797979),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      menuChildren: [
        Material(
          elevation: 2,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              children: [
                for (final item in widget.items)
                  Material(
                    key: ValueKey(item.key),
                    color: _selectedKey == item.key
                        ? const Color(0xFFE4E4E4)
                        : Colors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedKey = item.key;
                        });
                        widget.onItemSelected(item.key);
                        _toggleMenu();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(4),
                        child: item.icon,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
