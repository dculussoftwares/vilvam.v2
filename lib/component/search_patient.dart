import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:material_3_demo/main.dart';
import 'package:material_3_demo/modal/Patients.dart';
import 'package:material_3_demo/ui/buttons.dart';

import 'patient_search_result_card.dart';

class SearchPatient extends StatefulWidget {
  const SearchPatient({super.key});

  @override
  State<SearchPatient> createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (ctx, constraints) => Center(
              child: Autocomplete<Patients>(
                fieldViewBuilder: (context, fieldTextEditingController,
                    fieldFocusNode, onFieldSubmitted) {
                  return TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Phone number and Name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Search patients by name or phone number",
                    ),
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                  );
                },
                displayStringForOption: (data) => data.name,
                optionsBuilder: _getSuggestions,
                optionsViewBuilder: (context, onSelected, results) =>
                    _buildSuggestionsView(
                        context, onSelected, results, constraints),
              ),
            ));
  }

  Widget _buildSuggestionsView(BuildContext context, onSelected,
      Iterable<Patients> results, BoxConstraints constraints) {
    List<Widget> items = results
        .map((str) => _buildSuggestion(context, str, () => onSelected(str)))
        .toList();
    items.insert(0, _buildSuggestionTitle(context));
    return Stack(
      children: [
        ExcludeSemantics(
          child: AppBtn.basic(
            onPressed: FocusManager.instance.primaryFocus!.unfocus,
            semanticLabel: '',
            child: const SizedBox.expand(),
          ),
        ),
        TopLeft(
          child: Container(
            margin: EdgeInsets.only(top: $styles.insets.xxs),
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: $styles.colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all($styles.insets.xs),
              decoration: BoxDecoration(
                color: $styles.colors.offWhite.withOpacity(0.92),
                borderRadius: BorderRadius.circular($styles.insets.xs),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(),
                child: ListView(
                  padding: EdgeInsets.all($styles.insets.xs),
                  shrinkWrap: true,
                  children: items,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionTitle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all($styles.insets.xs).copyWith(top: 0),
      margin: EdgeInsets.only(bottom: $styles.insets.xxs),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: $styles.colors.greyStrong.withOpacity(0.1)))),
      child: CenterLeft(
        child: DefaultTextStyle(
          style: $styles.text.title2.copyWith(color: $styles.colors.black),
          child: Text(
            "Suggestions".toUpperCase(),
            overflow: TextOverflow.ellipsis,
            textHeightBehavior:
                const TextHeightBehavior(applyHeightToFirstAscent: false),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestion(
      BuildContext context, Patients patient, VoidCallback onPressed) {
    return AppBtn.basic(
      semanticLabel: patient.name,
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all($styles.insets.xs),
        child: CenterLeft(
          child: DefaultTextStyle(
            style: $styles.text.bodySmall
                .copyWith(color: $styles.colors.greyStrong),
            child: Column(
              children: [
                PatientSearchResultCard(
                  patients: patient,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Patients>> _getSuggestions(
    TextEditingValue textEditingValue) async {
  return await dataRepository
      .searchPatientByNameAndPhoneNumber(textEditingValue.text.toLowerCase());
}
