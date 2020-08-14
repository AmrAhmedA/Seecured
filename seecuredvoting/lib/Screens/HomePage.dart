import 'dart:convert';
import 'dart:io';

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
//    winnerEvent();
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
                  color: Colors.red,
                  fontSize: 22.0),
            ),
            SizedBox(
              height: hp(5, context),
            ),
            initBallot(),
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

  Widget initBallot() {
    return Container(
      child: haveCandidates == null
          ? Center(
              child: Padding(
              padding: EdgeInsets.symmetric(vertical: hp(8, context)),
              child: CircularProgressIndicator(),
            ))
          : haveCandidates
              ? buildBallot()
              : Center(
                  child: Text(
                    "Failed to load candidates, please try again later",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
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
                  candidates = [];
                  haveCandidates = null;
                  setState(() {
                  });
//                  voteTransaction(selectedVoterId);
                  await getCandidates();
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
        0: FractionColumnWidth(0.09),
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
            candidate.name + " - " + candidate.cid.toString(),
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
                candidate.name + " - " + candidate.cid.toString(),
                style: TextStyle(fontFamily: "Gotham"),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void voteTransaction(int selectedVoterId) async {
    /// For extracting public key from private key
    Credentials credentials = EthPrivateKey.fromHex(
        "8448d0a584b4d8cc753206ded81c176d05b077e64e326f5cbf3c324bb0cc64e5");
    var address = await credentials.extractAddress();
    print("Account Address: " + address.hex);

    /// Initializing web3
    var apiUrl = "https://kovan.infura.io/v3/cbc6700679974ee0bb0c6c62a480438c";

    var httpClient = new Client();
    var ethClient = new Web3Client(apiUrl, httpClient);

    /// For getting the current balance
    EtherAmount balance = await ethClient.getBalance(address);
    var amount = balance.getValueInUnit(EtherUnit.ether);
    print(
        'Balance before : ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');

    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x6d88896a12cf7f6e557734ef9c5fac9ff5dbda8d');

    /// Loading ABI
    String data =
        await DefaultAssetBundle.of(context).loadString("Election.json");
    final jsonResult = json.decode(data);
//    print(jsonResult);

    final client = Web3Client(apiUrl, Client());

    final contract = DeployedContract(
        ContractAbi.fromJson(
            json.encode(jsonResult['abi']), jsonResult['contractName']),
        contractAddr);

    var networkId = await client.getNetworkId();
    print('networkId: $networkId');

    final voteFunction = contract.function('vote');
    final voted = contract.event('votedEvent');

    var nonce = await client.getTransactionCount(address);
    print('nonce: $nonce');
    print("Test1");
    try {
      var txHash = await client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: voteFunction,
            parameters: [BigInt.from(selectedVoterId)],
            gasPrice:
                EtherAmount.fromUnitAndValue(EtherUnit.gwei, BigInt.from(10)),
//            nonce: await client.getTransactionCount(address,
//                atBlock: BlockNum.pending()),
            maxGas: 700000,
//            nonce: 10,
            from: address),
        fetchChainIdFromNetworkId: true,
      );
      print("Test2");
      print('Transaction hash: $txHash');
      await Future.delayed(const Duration(seconds: 5));
//      await Future.delayed(const Duration(seconds: 20));
//      final votedEvent = client
//          .events(FilterOptions.events(contract: contract, event: voted))
//          .take(1)
//          .listen((event) {
//        print("Event Fired");
//      });
//      await votedEvent.asFuture();
//      await votedEvent.cancel();
//
      var transactionReceipt = await client.getTransactionReceipt(txHash);
      print('Transaction receipt: $transactionReceipt');

      balance = await client.getBalance(address);
      print(
          'Balance after transaction: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');
    } catch (err) {
      print(err.toString());
    }
  }

  winnerEvent() async {
    /// For extracting public key from private key
    Credentials credentials = EthPrivateKey.fromHex(
        "8448d0a584b4d8cc753206ded81c176d05b077e64e326f5cbf3c324bb0cc64e5");
    var address = await credentials.extractAddress();

    /// Initializing web3

    var apiUrl = "https://kovan.infura.io/v3/cbc6700679974ee0bb0c6c62a480438c";

    var httpClient = new Client();
    var ethClient = new Web3Client(apiUrl, httpClient);

    /// For getting the current balance
    EtherAmount balance = await ethClient.getBalance(address);

    /// For getting the network Id
    int networkId = await ethClient.getNetworkId();

    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x6d88896a12cf7f6e557734ef9c5fac9ff5dbda8d');

    String data =
        await DefaultAssetBundle.of(context).loadString("Election.json");
    final jsonResult = json.decode(data);
//    print(jsonResult);

    final client = Web3Client(apiUrl, Client());

    final contract = DeployedContract(
        ContractAbi.fromJson(
            json.encode(jsonResult['abi']), jsonResult['contractName']),
        contractAddr);

    final winnerEvent = contract.event('votedEvent');

    print("#################################");
    //listen for the Transfer event when it's emitted by the contract above
    final winnerTrigger = client
        .events(FilterOptions.events(contract: contract, event: winnerEvent))
        .take(1)
        .listen((event) {
      final decoded = winnerEvent.decodeResults(event.topics, event.data);
    });
    await winnerTrigger.asFuture();
    await winnerTrigger.cancel();
  }

  Future<void> getCandidates() async {
    /// For extracting public key from private key
    Credentials credentials = EthPrivateKey.fromHex(
        "8448d0a584b4d8cc753206ded81c176d05b077e64e326f5cbf3c324bb0cc64e5");
    var address = await credentials.extractAddress();
    print('Account public address: ${address.hex}');

    /// Initializing web3

    var apiUrl = "https://kovan.infura.io/v3/cbc6700679974ee0bb0c6c62a480438c";

    var httpClient = new Client();
    var ethClient = new Web3Client(apiUrl, httpClient);

    /// For getting the current balance
    EtherAmount balance = await ethClient.getBalance(address);
    print('Balance: ${balance.getValueInUnit(EtherUnit.ether)}');

    /// For getting the network Id
    int networkId = await ethClient.getNetworkId();
    print(networkId);

    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0x6d88896a12cf7f6e557734ef9c5fac9ff5dbda8d');

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
    print('Total number of candidates: ${numCandidates.first}');

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
      client.dispose();
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

//@override
//void dispose() {
//  subscription.cancel();
//  client.dispose();
//  super.dispose();
//}

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
