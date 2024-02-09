import 'dart:convert';

import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:ebroker/utils/responsiveSize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../../data/cubits/auth/auth_cubit.dart';
import '../../../data/helper/widgets.dart';
import '../../../data/model/enquery_model.dart';
import '../../../utils/AppIcon.dart';
import '../../../utils/helper_utils.dart';
import '../../../utils/ui_utils.dart';
import '../widgets/AnimatedRoutes/blur_page_route.dart';
import '../widgets/custom_text_form_field.dart';
import 'enquery2_from.dart';
class Enquery2Screen extends StatefulWidget {
  const Enquery2Screen({super.key});

  @override
  State<Enquery2Screen> createState() => _Enquery2ScreenState();
}

class _Enquery2ScreenState extends State<Enquery2Screen> {
@override
  void initState() {
    // TODO: implement initState
  getData();
    super.initState();
  }
  EnqueryModel enqueryModel=EnqueryModel();
  getData() async {


    var response= await context.read<AuthCubit>().enqueryGetData(
        context,


    );
    enqueryModel=EnqueryModel.fromJson(response);

    setState(() {

    });

  }
_onTapCall(String url) async {


  //{contactNumber.data}
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            BlurredRouter(
              builder: (context) =>
                  Enquery2From(
                  ),
            ));

      },
        backgroundColor: context.color.tertiaryColor,
        child: Icon(Icons.add),
      ),
      backgroundColor: context.color.backgroundColor,
      appBar: UiUtils.buildAppBar(context,
          title: UiUtils.getTranslatedLabel(context, "Enquery"),
          showBackButton: true),
      body:Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: enqueryModel.data?.length??0,
                itemBuilder: (context,index){
              return  Card(
                child: ListTile(
                  onTap: (){
                  //  _onTapCall("${viewEnqueryModel.data?[index].phone??""}");
                  },
                  title:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${enqueryModel.data?[index].name} "),
                      Text("${enqueryModel.data?[index].schoolName??""}"),
                      Text("${enqueryModel.data?[index].subject??""}"),
                      Text("${enqueryModel.data?[index].description??""}"),
                    ],
                  ),
                  subtitle: Text("${enqueryModel.data?[index].mobile}",),
                  trailing:"${enqueryModel.data?[index].pdfStatus}"=="0"?SizedBox.shrink(): InkWell(
                      onTap: (){
                        print("${enqueryModel.data?[index].pdf}+++++++++++");
                        _onTapCall("${enqueryModel.data?[index].pdf}");
                      },
                      child: Icon(Icons.download)),
                ),
              );
            }),
          )
        ],
      ) ,
    );

  }
}
