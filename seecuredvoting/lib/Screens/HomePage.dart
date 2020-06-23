import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seecuredvoting/main.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'UserMainDrawer.dart';
import 'package:http/http.dart';

import 'package:path/path.dart' show join, dirname;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Seecured Election E-voting'),
        centerTitle: true,
        backgroundColor: Colors.indigo.withOpacity(0.8),
      ),
//      body: Image.asset("assets/image/candidate.jpg"),
      body: Column(
        children: <Widget>[
          SizedBox(height: hp(8, context)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCandidate(
                  "assets/image/candidate1.jpg",
                  "Candidate 1",
                  () async {
                    playground();
//                    if (await showPopup("omar"))
//                      print("Voted for omar");
//                    else
//                      print("Selection Canceled");
                  },
                ),
                buildCandidate(
                  "assets/image/candidate.jpg",
                  "Candidate 2",
                  () async {
                    if (await showPopup("Amr"))
                      print("Voted for Amr");
                    else
                      print("Selection Canceled");
                  },
                ),
              ],
            ),
          ),
          Container(
            height: hp(10, context),
            color: Colors.transparent,
          ),
          Image.asset(
            "assets/image/BUELOGO.png",
            scale: 1,
            fit: BoxFit.cover,
          ),
          SizedBox(height: hp(4, context)),
        ],
      ),
      drawer: MainDrawer(),
    );
  }

  Future<bool> showPopup(String candidate) async {
    bool answer = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: Text("Do you want to vote for $candidate"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  answer = true;
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  answer = false;
                },
                child: Text("No"),
              ),
            ],
          );
        });
    return answer;
  }

  Widget buildCandidate(String image, String name, Function onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 8)),
              child: CircleAvatar(
                backgroundImage: AssetImage(image),
                radius: 75,
              ),
            ),
            SizedBox(height: hp(2, context)),
            RaisedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: wp(2, context), vertical: hp(1.5, context)),
                child: Text(name,
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
              onPressed: onPressed,
              color: Colors.red,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void playground() async {
    /// For extracting public key from private key
    Credentials credentials = EthPrivateKey.fromHex(
        "a0af77a6ea033a316c6e883dbcbc87c95f6b3a160017149eaca22c6c49b2f7d9");
    var address = await credentials.extractAddress();
    print(address.hex);

    var apiUrl = "https://kovan.infura.io/v3/cbc6700679974ee0bb0c6c62a480438c";

    var httpClient = new Client();
    var ethClient = new Web3Client(apiUrl, httpClient);

    /// For getting the current balance
    EtherAmount balance = await ethClient.getBalance(address);
    print(balance.getValueInUnit(EtherUnit.ether));

    /// For getting the network Id
    int networkId = await ethClient.getNetworkId();
    print(networkId);

    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x7ec18be60161f17414103ac70f2413da96bc7720');

    String data =
        await DefaultAssetBundle.of(context).loadString("Election.json");
    final jsonResult = json.decode(data);
    print(jsonResult);

    final client = Web3Client(apiUrl, Client());

    final contract = DeployedContract(
        ContractAbi.fromJson(json.encode(jsonResult['abi']), jsonResult['contractName']), contractAddr);

    final numCandidatesFunction = contract.function('getNumCandidates');
    final candidatesFunction = contract.function('candidates');

    final numCandidates = await client.call(
        contract: contract, function: numCandidatesFunction, params: []);
    print(numCandidates);
    print('We have ${numCandidates.first} candidates');

    final candidates = await client.call(
        contract: contract, function: candidatesFunction, params: [BigInt.from(1)]);
    print(candidates);
    print('those are the candidates ${candidates.first} candidates');
  }
}
//class _Counter extends State<HomePage> {
//  int _totalVoteCounter = 0;
//
//  void _IncrementCounter() {
//    setState(() {
//      _totalVoteCounter++;
//    });
//  }
//}

//RaisedButton(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.all(Radius.circular(10.0))),
//onPressed: () {
//Navigator.pop(context);
//},
//color: Colors.indigo,
//textColor: Colors.white,
//child: Text(
//'Back',
//style: TextStyle(
//fontSize: 20.0,
//),
//),
//)
