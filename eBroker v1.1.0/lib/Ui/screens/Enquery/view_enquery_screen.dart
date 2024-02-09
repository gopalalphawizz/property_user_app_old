

import 'dart:convert';

import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/helper/widgets.dart';
import '../../../data/model/view_enquery_model.dart';
import '../../../utils/ui_utils.dart';

class ViewEnqueryScreen extends StatefulWidget {
  final String id;
   ViewEnqueryScreen({
  required this.id,
  });

  @override
  State<ViewEnqueryScreen> createState() => _ViewEnqueryScreenState();
}

class _ViewEnqueryScreenState extends State<ViewEnqueryScreen> {

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  ViewEnqueryModel viewEnqueryModel=ViewEnqueryModel();
getData() async {

 // Widgets.showLoader(context);
 var response= await context.read<AuthCubit>().enqueryGet(
      context,

      id: widget.id
  );
 viewEnqueryModel=ViewEnqueryModel.fromJson(response);
 // Widgets.hideLoder(context);
 setState(() {

 });

}
  _onTapCall(String phone) async {
    var contactNumber = phone;

    var url = Uri.parse("tel: $contactNumber"); //{contactNumber.data}
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      appBar: UiUtils.buildAppBar(context,
          title: UiUtils.getTranslatedLabel(context, "View Enquery"),
          showBackButton: true),
       body: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           children: [
                Expanded(
                  child: viewEnqueryModel.data?.isNotEmpty??false?

                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewEnqueryModel.data?.length??0,
                      itemBuilder: (context,index){
                    return
                        Card(
                        child: ListTile(
                          onTap: (){
                            _onTapCall("${viewEnqueryModel.data?[index].phone??""}");
                          },
                            title:Text("${viewEnqueryModel.data?[index].firstName} "),
                          subtitle: Text("${viewEnqueryModel.data?[index].message}",),
                          trailing:  Text("${viewEnqueryModel.data?[index].phone??""}"),
                        ),
                      );
                  }):Center(child: Text("No Data Found"),),
                )
           ],
         ),
       ),
    );
  }
}
