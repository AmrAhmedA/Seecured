App = {
    web3Provider: null,
    contracts: {},
    account: '0x0',
    hasVoted: false,

    init: function() {
        const metamaskInstalled = typeof window.web3 !== 'undefined';
        if (metamaskInstalled) {
            return App.initWeb3();
        } else {
            if (!metamaskInstalled) {
                var loader = $("#content");
                loader.empty();
                var result = `<h2 class='text-center'> Please Install MetaMask </h2> <img class='img-responsive center-block' src='../images/metamask.png' alt='Seecured Logo' height='250' width='150'></img>`
                loader.append(result);
                return;
            }
        }
    },
    //Function To Initialize our Connection to the Client Side Application
    initWeb3: function() {
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

    initContract: function() {
        $.getJSON("../Election.json", function(election) {
            // Instantiate a new truffle contract from the artifact
            App.contracts.Election = TruffleContract(election);
            // Connect provider to interact with contract
            App.contracts.Election.setProvider(App.web3Provider);

            return App.render();
        });
    },
    render: function() {
        // Load account data
        web3.eth.getCoinbase(function(err, account) {
            if (err === null) {
                App.account = account;
                $("#accountAddress").html("Your Account: " + account);
            }
            // account = web3.eth.accounts[0];
            // var accountInterval = setInterval(function () {
            //   if (web3.eth.accounts[0] !== account) {
            //     account = web3.eth.accounts[0];
            //     updateInterface();
            //   }
            // }, 100);
        });
    },
    addNewcandidate: function() {
        var candidatecomittee = $('#candidatecomittee').val();
        var candidatename = $('#candidatename').val();
        var candidateid = $('#candidateid').val();
        App.contracts.Election.deployed().then(function(instance) {
            return instance.addCandidate(candidatename, candidateid, candidatecomittee, {
                from: App.account
            });
        }).then(function(result) {
            alert("Candidate Added Successfully");
        }).catch(function(err) {
            console.error(err);
        });
    },
    authorizeStudent: function() {
        var StudentAccount = $('#studentaccount').val();
        App.contracts.Election.deployed().then(function(instance) {
            return instance.authorize(StudentAccount, {
                from: App.account
            });
        });
    },
    announceWinner: function() {
        App.contracts.Election.deployed().then(function(instance) {
            var x = instance.winnerName({from:App.account});
            console.log(x);
        });
    }
};

function reloadPage() {
    location.reload(true);
}
$(function() {
    $(window).load(function() {
        App.init();
    });
});