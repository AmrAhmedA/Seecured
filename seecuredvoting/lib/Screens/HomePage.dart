import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seecuredvoting/Models/Candidate.dart';
import 'package:seecuredvoting/main.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'UserMainDrawer.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Candidate> candidates = List();

  bool haveCandidates;

  int selectedVoterId = 1;

  @override
  void initState() {
    super.initState();
    getCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/image/BUE.png",
              scale: 1,
              width: 400,
              height: 200,
            ),
            SizedBox(
              height: hp(5, context),
            ),
            Text(
              "Student Union Election",
              style: TextStyle(
                  fontFamily: "Gotham",
                  fontWeight: FontWeight.bold,
                  color: Colors.red,fontSize: 22.0),
            ),
            SizedBox(
              height: hp(5, context),
            ),
            haveCandidates == null
                ? Center(child: CircularProgressIndicator())
                : haveCandidates
                    ? buildBallot()
                    : Center(
                        child: Text(
                            "Failed to load candidates. please try again later"),
                      ),
            SizedBox(
              height: hp(5, context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: hp(2, context), horizontal: wp(2, context)),
        child: Image.asset(
          "assets/image/BUELOGO.png",
          height: 80,
          scale: 1,
        ),
      ),
      drawer: MainDrawer(),
    );
  }

  Future<bool> showVerificationPopup(String candidateName) async {
    bool answer = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to vote for $candidateName"),
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

  Widget buildBallot() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: wp(5, context)),
      child: Column(
        children: <Widget>[
          buildTable(),
          SizedBox(
            height: hp(4, context),
          ),
          buildVotingMenu(),
          ButtonTheme(
            minWidth: 150.0,
            height: 40.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              onPressed: () async {
                String selectedCandidateName =
                    candidates.firstWhere((candidate) {
                  return candidate.id == selectedVoterId;
                }).name;

                if (await showVerificationPopup(selectedCandidateName)) {
                  // TODO: send vote transaction
                  print("Voting for $selectedVoterId");
                } else {
                  // do nothing
                }
              },
              child: Text(
                "Vote",
                style: TextStyle(fontFamily: "Gotham"),
              ),
              color: Colors.red,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTable() {
    return Table(
      columnWidths: {
        0: FractionColumnWidth(0.08),
        1: FractionColumnWidth(0.48),
        2: FractionColumnWidth(0.3),
      },
      border: TableBorder(
        horizontalInside: BorderSide(color: Colors.black, width: 1),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: hp(1, context)),
            child: Text("ID",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Gotham")),
          ),
          Text("Name",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Gotham")),
          Text("Committee",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Gotham")),
          Text("Votes",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: "Gotham")),
        ]),
        ...buildCandidatesRows(),
      ],
    );
  }

  buildCandidatesRows() {
    return candidates.map((candidate) {
      return TableRow(children: [
        Text(
          candidate.id.toString(),
          style: TextStyle(fontFamily: "Gotham"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: hp(2, context)),
          child: Text(
            candidate.name,
            style: TextStyle(fontFamily: "Gotham"),
          ),
        ),
        Text(
          candidate.committee,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Gotham"),
        ),
        Text(
          candidate.votes.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ]);
    }).toList();
  }

  Widget buildVotingMenu() {
    return Column(
      children: <Widget>[
        Text(
          "Select Candidate",
          style: TextStyle(
              fontFamily: "Gotham",
              fontWeight: FontWeight.bold,
              color: Colors.red),
        ),
        DropdownButton(
          onChanged: (selected) {
            setState(() {
              selectedVoterId = selected;
            });
          },
          value: selectedVoterId,
          style: TextStyle(color: Colors.black),
          underline: Divider(color: Colors.red),
          items: candidates.map((candidate) {
            return DropdownMenuItem(
              value: candidate.id,
              child: Text(
                candidate.name,
                style: TextStyle(fontFamily: "Gotham"),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void getCandidates() async {
    /// For extracting public key from private key
    Credentials credentials = EthPrivateKey.fromHex(
        "a0af77a6ea033a316c6e883dbcbc87c95f6b3a160017149eaca22c6c49b2f7d9");
    var address = await credentials.extractAddress();
    print(address.hex);

    /// Initializing web3

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
//    print(jsonResult);

    final client = Web3Client(apiUrl, Client());

    final contract = DeployedContract(
        ContractAbi.fromJson(
            json.encode(jsonResult['abi']), jsonResult['contractName']),
        contractAddr);

    final numCandidatesFunction = contract.function('getNumCandidates');
    final candidatesFunction = contract.function('candidates');

    final numCandidates = await client
        .call(contract: contract, function: numCandidatesFunction, params: []);
    print(numCandidates);
    print('We have ${numCandidates.first} candidates');

    try {
      for (int i = 1; i <= num.parse(numCandidates.first.toString()); i++) {
        final candidate = await client.call(
            contract: contract,
            function: candidatesFunction,
            params: [BigInt.from(i)]);

        candidates.add(Candidate(
            id: num.parse(candidate[0].toString()),
            name: candidate[1],
            cid: num.parse(candidate[2].toString()),
            committee: candidate[3],
            votes: num.parse(candidate[4].toString())));
      }
      setState(() {
        haveCandidates = true;
      });
    } catch (err) {
      print(err.toString());
      setState(() {
        haveCandidates = false;
      });
    }
  }

  buildAppBar() {
    return PreferredSize(
      preferredSize: Size(wp(100, context), hp(10, context)),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: wp(4, context), vertical: hp(1, context)),
          child: Row(
            children: <Widget>[
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.menu, size: 30),
                    ),
                  );
                },
              ),
              Spacer(),
              Text(
                "Seecured E-Voting",
                style: TextStyle(
                    fontFamily: "Gotham",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Image.asset(
                "assets/image/Seecured.png",
                height: hp(8, context),
                width: wp(22, context),
              ),
            ],
          ),
        ),
      ),
    );
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
