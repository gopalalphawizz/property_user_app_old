
import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:ebroker/utils/responsiveSize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../data/cubits/auth/auth_cubit.dart';
import '../../../data/helper/widgets.dart';
import '../../../utils/AppIcon.dart';
import '../../../utils/helper_utils.dart';
import '../../../utils/ui_utils.dart';
import '../widgets/custom_text_form_field.dart';

class EnqueryFromWidget extends StatefulWidget {
 final String id;
  const EnqueryFromWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EnqueryFromWidget> createState() => _EnqueryFromWidgettState();
}

class _EnqueryFromWidgettState extends State<EnqueryFromWidget> {
  final TextEditingController _subject = TextEditingController();
  late final TextEditingController _email =
  TextEditingController();
  final TextEditingController _text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      appBar: UiUtils.buildAppBar(context,
          title: UiUtils.getTranslatedLabel(context, "Enquery"),
          showBackButton: true),
      body:
      Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  blurRadius: 3, color: ui.Color.fromARGB(255, 201, 201, 201)
              )
            ],
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color:
                              context.color.tertiaryColor.withOpacity(0.0),
                              shape: BoxShape.circle,
                            ),
                            width: 40,
                            height: 40,
                            child: FittedBox(
                                fit: BoxFit.none,
                                child: UiUtils.getSvg(AppIcons.arrowLeft,
                                    color: context.color.tertiaryColor))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.rh(context),
                  ),
                  Text("Enquery From"),
                  SizedBox(
                    height: 15.rh(context),
                  ),
                  // CustomTextFormField(
                  //   controller: _subject,
                  //   hintText: UiUtils.getTranslatedLabel(context, "subject"),
                  // ),
                  // SizedBox(
                  //   height: 15.rh(context),
                  // ),
                  // CustomTextFormField(
                  //   controller: _email,
                  //   isReadOnly: true,
                  //   hintText:
                  //   UiUtils.getTranslatedLabel(context, "companyEmailLbl"),
                  // ),

                  CustomTextFormField(
                    controller: _text,
                    maxLine: 100,
                    hintText:
                    UiUtils.getTranslatedLabel(context, "writeSomething"),
                    minLine: 5,
                  ),
                  SizedBox(
                    height: 15.rh(context),
                  ),
                  UiUtils.buildButton(context, onPressed: () async {
                    if(_text.text.isNotEmpty??false) {
                      Widgets.showLoader(context);
                      await context.read<AuthCubit>().enquerySend(
                          context,
                          message: _text.text,
                          id: widget.id
                      );
                      Widgets.hideLoder(context);
                      Navigator.pop(context);
                    }
                    else{
                      HelperUtils.showSnackBarMessage(context,
                          UiUtils.getTranslatedLabel(context, "Feild is required"));
                    }
                    // HelperUtils.showSnackBarMessage(context,
                    //     UiUtils.getTranslatedLabel(context, "lblchecknetwork"));
                  },

                    height: 50.rh(context),
                      buttonTitle:
                      UiUtils.getTranslatedLabel(context, "Send Enquery"),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}