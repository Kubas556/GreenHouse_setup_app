import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wifi_connect/flutter_wifi_connect.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_configuration_2/wifi_configuration_2.dart';
import 'package:udp/udp.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _wifilist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text("Seznam"),
      ),
      body: Container(
        child: Center(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              refreshWiFiList();
            },
            child:_wifilist == null ? Text("Loading") : _wifilist.isEmpty ?
            /*SingleChildScrollView(*/
              /*physics: const AlwaysScrollableScrollPhysics(),*/
              /*child: */Column(
                mainAxisAlignment: MainAxisAlignment.center,
                /*height: MediaQuery.of(context).size.height,*/
                children: [Center(
                    child: Column(
                        children:[
                          Text("žádná nalezené WiFi skleníku"),
                          OutlinedButton(
                            onPressed: refreshWiFiList,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh),
                                Text("Refresh"),
                              ],
                            ),
                          ),
                        ]
                    ),
                )],
            )
            /*)*/:
            ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: _wifilist.map((e) => WifiButton(name:e.ssid)).toList(),
              )
            ),
          )
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    refreshWiFiList();
  }

  Future<List<WifiResult>> getWiFiList() async {
    final arr = await Wifi.list("GreenHouse_setup_WiFi");
    return arr;
  }

  void refreshWiFiList() async {
    getWiFiList().then((value) => setState((){
      print(value);
      _wifilist = value;
    }));
  }

}

class WifiButton extends StatelessWidget {
  String name;
  WifiButton({this.name});


  Future<SimpleDialog> connectAndSend(String greenhouseWifiName, String wifiToConnect, BuildContext context) async {
    await FlutterWifiConnect.disconnect();
    print(greenhouseWifiName);
    print(wifiToConnect);
    await FlutterWifiConnect.connectToSecureNetwork(greenhouseWifiName,"DefaultSetupPassword");
    Navigator.pop(context);

    String password;

    return showDialog(
      context:context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Zadejte heslo k wifi "+wifiToConnect),
          children: [TextField(
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Heslo',
            ),
          ),TextButton(
            onPressed: () async {
              var sender = await UDP.bind(Endpoint.any(port: Port(12345)));
              //print(("WiFi-login|"+wifiToConnect+"|"+password+"\n").codeUnits);
              var dataLength = await sender.send(("WiFi-login|"+wifiToConnect+"|"+password+"|").codeUnits,Endpoint.broadcast(port: Port(12345)));
              Navigator.pop(context);
            },
            child: Text("Potvrdit"),
          )],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          Wifi.list("").then((wifiList) => {
              showDialog(
              context: context,
              builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('Vyber WiFi, ke které se skleník připojí'),
                children: [ConstrainedBox(
                  constraints: new BoxConstraints(maxHeight: 200),
                  child: ListView.separated(itemBuilder: (BuildContext context, int index) => (wifiList[index].ssid != "name" ?/*Center(child: */TextButton(child: Text('${wifiList[index].ssid}'), onPressed: () => connectAndSend(name,wifiList[index].ssid,context),)/*)*/:null),separatorBuilder: (BuildContext context, int index) => const Divider(), itemCount: wifiList.length)
                )]
                );
              })
          });
        },
        child: Text(name)
      ),
      height: 50,
    );
  }
}
