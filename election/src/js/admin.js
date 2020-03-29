App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  hasVoted: false,
  test: false,

  init: function () {
    return App.initWeb3();
  },
  //Function To Initialize our Connection to the Client Side Application
  initWeb3: function () {
    // TODO: refactor conditional
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      ethereum.enable();
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      ethereum.enable();
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function () {
    $.getJSON("Election.json", function (election) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Election = TruffleContract(election);
      // Connect provider to interact with contract
      App.contracts.Election.setProvider(App.web3Provider);

      return App.render();
    });
  },
  render: function () {
    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });
  },
  addCandidate: function () {
    var candidatecomittee = $('#candidatecomittee').val();
    var candidatename = $("#candidatename").val();
    var candidateid = $("#candidateid").val();
    App.contracts.Election.deployed().then(function (instance) {
      return instance.addCandidate(candidatename, candidateid, candidatecomittee, {
        from: App.account
      });
    }).then(function (result) {
      alert("Candidate Added Successfully");
    }).catch(function (err) {
      console.error(err);
    });
  }
};
