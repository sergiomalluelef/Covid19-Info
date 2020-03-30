import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/src/models/data_api_model.dart';
import 'package:game/src/provider/data_cod19.dart';
import 'package:game/src/utils/network/Utils.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

class ListaPaises extends StatefulWidget {
  @override
  _ListaPaisesState createState() => _ListaPaisesState();
}

class _ListaPaisesState extends State<ListaPaises> {
  TextEditingController controller = new TextEditingController();
  String _textSearch = '';
  List<String> _checked = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<DataCov19>(builder: (context, dataCod19, _) {
      return Scaffold(
        endDrawer: Drawer(child: DrawerHeader(child: Column(
          children: <Widget>[
            Text('Ordenar'),
            CheckboxGroup(
              labels: <String>[
                "Confirmados",
                "Fallecidos",
                "Recuperados",
              ],
              checked: _checked,
              activeColor: Colors.grey,
              onChange: (bool isChecked, String label, int index){
                print("isChecked: $isChecked   label: $label  index: $index");

                if(!isChecked){
                  Provider.of<DataCov19>(context, listen: false).getOrderDataApiCod19(0);
                }else{
                  Provider.of<DataCov19>(context, listen: false).getOrderDataApiCod19(index);
                }

              },
              onSelected: (List selected) => setState(() {
                Navigator.of(context).pop();
                resetSearch(Provider.of<DataCov19>(context, listen: false));
                if (selected.length > 1) {
                  selected.removeAt(0);
                  print('selected length  ${selected.length}');
                } else {
                  print("only one");
                }
                _checked = selected;
              }),
            ),
          ],
        ),)),
        body: Container(
          padding: EdgeInsets.only(top: 36.0),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[

              Card(
                color: Colors.black45,
                margin: EdgeInsets.only(left: 15,right: 15, bottom: 7.5, top: 7.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),),
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.only(left: 8, right: 8),
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                            hintText: 'Buscar', border: InputBorder.none),
                        onChanged: (text) {
                          dataCod19.getSearchDataApiCod19(text);
                          _textSearch = text;
                          print('Buscando: ' + text);
                        }),
                    trailing: new IconButton(
                      icon: _textSearch.isNotEmpty
                          ? const Icon(Icons.cancel)
                          : Container(),
                      onPressed: () {
                        resetSearch(dataCod19);
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child:           Builder(
                  builder: (context) => GestureDetector(
                    onTap: (){
                      Scaffold.of(context).openEndDrawer();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Text('Ordenado por ' + (_checked.isEmpty ? 'confirmados' : _checked[0].toLowerCase())),
                        ),
                        Icon(Icons.playlist_add_check),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: Scrollbar(
                    child: dataCod19.searchResult.isEmpty && _textSearch.isEmpty
                        ? ListView.builder(
                      itemCount: dataCod19.listDataApi.length,
                      itemBuilder: (BuildContext context, int i) {
                        DataApiModel cases = dataCod19.listDataApi[i];
                        return Card(
                          color: Colors.black45,
                            margin: EdgeInsets.only(left: 15,right: 15, bottom: 4.5, top: 4.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),),
                            elevation: 1,
                            child: Container(
                              padding: EdgeInsets.only(top: 6,bottom: 6),
                              child: ListTile(
                                leading:  CachedNetworkImage(imageUrl: cases.countryInfo.flag, imageBuilder: (context, imageProvider) => Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill),
                                  ),
                                ),),
                                title: Text(
                                  cases.country,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "${Utils.setFormatNumberToString(cases.cases)} confirmados"),
                                          Text(
                                              "${Utils.setFormatNumberToString(cases.deaths)} fallecidos"),
                                        ],
                                      ),
                                      Text(
                                          "${Utils.setFormatNumberToString(cases.recovered)} recuperados"),

                                    ]),
                              ),
                            ));
                      },
                    )
                        : ListView.builder(
                      itemCount: dataCod19.searchResult.length,
                      itemBuilder: (BuildContext context, int i) {
                        DataApiModel cases = dataCod19.searchResult[i];
                        return Card(
                            color: Colors.black45,
                            margin: EdgeInsets.only(left: 15,right: 15, bottom: 4.5, top: 4.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),),
                            elevation: 1,
                            child: Container(
                              padding: EdgeInsets.only(top: 6,bottom: 6),
                              child: ListTile(
                                leading:  CachedNetworkImage(imageUrl: cases.countryInfo.flag, imageBuilder: (context, imageProvider) => Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.fill),
                                  ),
                                ),),
                                title: Text(
                                  cases.country,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              "${Utils.setFormatNumberToString(cases.cases)} confirmados"),
                                          Text(
                                              "${Utils.setFormatNumberToString(cases.deaths)} fallecidos"),
                                        ],
                                      ),
                                      Text(
                                          "${Utils.setFormatNumberToString(cases.recovered)} recuperados"),

                                    ]),
                              ),
                            ));
                      },
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }
  void resetSearch(DataCov19 dataCod19) {
    FocusScope.of(context).unfocus();
    controller.clear();
    print('Buscando: clear');
    dataCod19.getSearchDataApiCod19('');
    _textSearch = '';
  }
}
