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
      App.listenForEvents();
      return App.render();
    });
  },
  listenForEvents: function () {
    App.contracts.Election.deployed().then(function (instance) {
      instance.votedEvent({}, {
        fromBlock: 'latest',
        toBlock: 'latest'
      }).watch(function (error, event) {
        console.log("event triggered", event);
        // Reload when a new vote is recorded
        console.log("Hey Amr, It worked");
        App.render();
      });
    });
  },
  render: function () {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.Election.deployed().then(function (instance) {
      electionInstance = instance;
      return electionInstance.candidatesCount();
    }).then(function (candidatesCount) {
      var candidatesResults = $("#candidatesResults");
      candidatesResults.empty();

      var candidatesSelect = $('#candidatesSelect');
      candidatesSelect.empty();

      for (var i = 1; i <= candidatesCount; i++) {
        electionInstance.candidates(i).then(function (candidate) {
          var id = candidate[0];
          var name = candidate[1];
          var studentID = candidate[2];
          var committee = candidate[3];
          var voteCount = candidate[4];


          // Render candidate Result
          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</th><td>" + studentID + "</td><td>" + committee + "</td><td>" + voteCount + "</td></tr>";
          candidatesResults.append(candidateTemplate);

          // Render candidate ballot option
          var candidateOption = "<option value='" + id + "' >" + name + "</ option>";
          candidatesSelect.append(candidateOption);
        });
      }
      return electionInstance.voters(App.account).then(function (voters) {
        hasVoted = voters[1];
      })
    }).then(function () {
      // Do not allow a user to vote
      console.log("Hello");

      if (hasVoted) {
        $('form').hide();
      }
      loader.hide();
      content.show();
    }).catch(function (error) {
      console.warn(error);
      alert("Sorry Amr, You Need to Focus More");
    });
  },
  castVote: function () {
    var candidateId = $('#candidatesSelect').val();
    App.contracts.Election.deployed().then(function (instance) {
      return instance.vote(candidateId, {
        from: App.account
      });
    }).then(function (result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function (err) {
      console.error(err);
    });
  }
};

function reloadPage() {
  location.reload(true);
}
$(function () {
  $(window).load(function () {
    App.init();
  });
});