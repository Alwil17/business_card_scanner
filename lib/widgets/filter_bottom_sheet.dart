import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> selectedTags = [];
  String sortBy = 'Date';
  String ascendingString = 'Ascending';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter by Tags section
          _buildTitle('Filter by Tags', Icons.filter_alt),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: ['All', 'Clients', 'Prospects', 'Leads', 'Company'].map((tag) {
              return FilterChip(
                label: Text(tag),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                selected: selectedTags.contains(tag),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      if (tag == 'All') {
                        selectedTags.clear();
                        selectedTags.add(tag);
                      } else {
                        if (selectedTags.contains('All')) {
                          selectedTags.remove('All');
                        }
                        selectedTags.add(tag);
                      }
                    } else {
                      selectedTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Sort by section
          _buildTitle('Sort by', Icons.sort_by_alpha),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildClickableTextOption('Date'),
              Container(height: 8, child: VerticalDivider(color: Colors.black38)),
              _buildClickableTextOption('Name'),
              Container(height: 8, child: VerticalDivider(color: Colors.black38)),
              _buildClickableTextOption('Company'),
            ],
          ),
          const SizedBox(height: 16),

          // Sort Order section
          _buildTitle('Sort Order', Icons.swap_vert),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildClickableSortOption('Ascending', Icons.arrow_upward_sharp),
              _buildClickableSortOption('Descending', Icons.arrow_downward_sharp),
              /*_buildSortOrderButton('Ascending', isAscending),
              _buildSortOrderButton('Descending', !isAscending),*/
            ],
          ),
          const SizedBox(height: 16),

          // Apply Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'selectedTags': selectedTags,
                  'sortBy': sortBy,
                  'isAscending': ascendingString == 'Ascending',
                });
              },
              child: const Text('Apply filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String label, IconData icon){
    return Text.rich(TextSpan(children: [
      WidgetSpan(child: Icon(icon, size: 20,)),
      WidgetSpan(child: SizedBox(width: 5,)),
      TextSpan(text: label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ]));
  }
  
  // Build clickable text for Sort By options
  Widget _buildClickableTextOption(String label) {
    return InkWell(
      onTap: () {
        setState(() {
          sortBy = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: sortBy == label ? Colors.blue : Colors.black,
            fontWeight: sortBy == label ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Build clickable text for Sort By options
  Widget _buildClickableSortOption(String label, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          ascendingString = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child:  Text.rich(TextSpan(children: [
          WidgetSpan(child: Icon(icon, size: 20,)),
          WidgetSpan(child: SizedBox(width: 3,)),
          TextSpan(text: label, style: TextStyle(fontSize: 15,
            color: (ascendingString == label) ? Colors.blue : Colors.black,
            fontWeight: (ascendingString == label) ? FontWeight.bold : FontWeight.normal)),
        ]),),
      ),
    );
  }

}
