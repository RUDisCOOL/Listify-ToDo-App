import 'package:flutter/material.dart';

class ListNameTile extends StatelessWidget {
  const ListNameTile({
    required this.listName,
    required this.onDelete,
    required this.onSelected,
    required this.onEdit,
    super.key,
  });
  final void Function() onEdit;
  final void Function() onSelected;
  final void Function() onDelete;

  final String listName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onEdit();
      },
      onTap: onSelected,
      child: Card.filled(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 10.0, top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  listName,
                  maxLines: null,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Do you want to delete this list?'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  onDelete();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
