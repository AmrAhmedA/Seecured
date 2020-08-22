App = {
    web3Provider: null,
    contracts: {},
    account: '0x0',
    hasVoted: false,
    isEligable: false,
    init: function() {
        const metamaskInstalled = typeof window.web3 !== 'undefined';
        if (metamaskInstalled) {
            return App.initWeb3();
        } else {
            if (!metamaskInstalled) {
                alert("Please Install MetaMask");
                var loader = $("#loader");
                loader.empty();
                var result = `<h2 class='text-center'> Please Install MetaMask </h2> <img class='img-responsive center-block' src='images/metamask.png' alt='Seecured Logo' height='250' width='150'></img>`
                loader.append(result);
                return;
            }
        }
    },
    //Function To Initialize Seecured Connection to the Client Side Application
    initWeb3: function() {
        if (typeof web3 !== 'undefined') {
            // If a web3 instance is already provided by Meta Mask (A node has the ability to view and interact with Ethereum)
            App.web3Provider = web3.currentProvider;
            // App.web3Provider = new Web3.providers.HttpProvider("https://kovan.infura.io/v3/cbc6700679974ee0bb0c6c62a480438c");
            ethereum.eth_requestAccounts;
            web3 = new Web3(web3.currentProvider);
            // web3 = new Web3(new Web3.providers.HttpProvider("https://kovan.infura.io/v3/cbc6700679974ee0bb0c6c62a480438c"));
        } else {
            alert("Please Install MetaMask");
            // Specify default instance if no web3 instance provided - Ganache as default provider
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
            ethereum.eth_requestAccounts;
            web3 = new Web3(App.web3Provider);
        }
        return App.initContract();
    },
    initContract: function() {
        $.getJSON("/Election.json", function(election) {
            // Instantiate a new truffle contract from the artifact
            App.contracts.Election = TruffleContract(election);
            // Connect provider to interact with contract
            App.contracts.Election.setProvider(App.web3Provider);
            App.winnerEventListener();
            App.endElectionListener();
            console.log("Testing");
            return App.render();
        });
    },
    votedEventListener: function() {
        App.contracts.Election.deployed().then(function(instance) {
            instance.votedEvent({}, {
                // subscribe for voted events since the contract creation 
                // fromBlock: 0,
                // toBlock: 'latest'
            }).watch(function(error, event) {
                if (!error) {
                    console.log("event triggered", event);
                    // Reload when a new vote is recorded
                    console.log("Hey Amr, It worked");
                    App.render();
                } else {
                    console.log("Error", error);
                }
            });
        });
    },
    winnerEventListener: function() {
        App.contracts.Election.deployed().then(function(instance) {
            instance.winnerEvent({}, {
                fromBlock: 0,
                toBlock: 'latest'
            }).watch(function(error, event) {
                if (!error) {
                    console.log("Winner has been announced");
                    console.log("event triggered", event);
                    instance.electionWinner.call().then(function(winnerBUE) {
                        var content = $("#content");
                        content.empty();
                        var result = `<h2 class='text-center'> The Winner is: ` + winnerBUE + `</h2>`
                        content.append(result);
                        console.log("Winner is: " + winnerBUE);
                    });
                } else {
                    console.log("Error", error);
                }
            });
        });
    },
    endElectionListener: async function() {
        App.contracts.Election.deployed().then(function(instance) {
            instance.endElection({}, {
                fromBlock: 0,
                toBlock: 'latest'
            }).watch(function(error, event) {
                if (!error) {
                    console.log("Election Finished");
                    console.log("event triggered", event);
                    var content = $("#content");
                    content.empty();
                    var result = `<h1 class='text-center'> Election Finished </h1>`
                    content.append(result);
                } else {
                    console.log("Error", error);
                }
            });
        });
    },
    render: function() {
        var electionInstance;
        var loader = $("#loader");
        var content = $("#content");

        loader.show();
        content.hide();

        // Load account data
        web3.eth.getCoinbase(function(err, account) {
            if (err === null) {
                App.account = account;
                $("#accountAddress").html("Your Account: " + account);
            }
        });

        // Load Timer Data
        App.electionTimer();

        // Load contract data
        App.contracts.Election.deployed().then(function(instance) {
            electionInstance = instance;
            return electionInstance.candidatesCount();
        }).then(function(candidatesCount) {
            var candidatesResults = $("#candidatesResults");
            candidatesResults.empty();

            var candidatesSelect = $('#candidatesSelect');
            candidatesSelect.empty();

            for (var i = 1; i <= candidatesCount; i++) {
                electionInstance.candidates(i).then(function(candidate) {
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
            return electionInstance.voters(App.account).then(function(voters) {
                isEligable = voters[0];
                hasVoted = voters[1];
            })
        }).then(function() {
            console.log("----Checking Voter Status----");
            console.log("Eligibility to vote: " + isEligable);
            console.log("Voted: " + hasVoted);

            // Do not allow a user to vote
            if (!isEligable || hasVoted) {
                $('form').hide();
            }
            loader.hide();
            content.show();
        }).catch(function(error) {
            console.warn(error);
            alert("Sorry Amr, You Need to Focus More");
        });

    },
    electionTimer: function() {
        App.contracts.Election.deployed().then(function(instance) {
            electionInstance = instance;
            return electionInstance.electionDate();
        }).then(function(electionDate) {
            console.log("Election End-Date: " + electionDate);

            // extracting election day
            var electionDay = electionDate.slice(0, 2);

            // extracting election month    
            var electionMonth = electionDate.slice(3, 5);

            // extracting election year
            var electionYear = electionDate.slice(6, 10);

            console.log(electionDay);
            // set the date we're counting down to
            var target_date = new Date(electionDay + ',' + electionMonth + ',' + electionYear).getTime();

            // variables for time units
            var days, hours, minutes, seconds;

            // get tag element
            var countdown = document.getElementById('countdown');

            // update the tag with id "countdown" every 1 second
            setInterval(function() {

                // find the amount of "seconds" between now and target
                var current_date = new Date().getTime();
                var seconds_left = (target_date - current_date) / 1000;

                // do some time calculations
                days = parseInt(seconds_left / 86400);
                seconds_left = seconds_left % 86400;

                hours = parseInt(seconds_left / 3600);
                seconds_left = seconds_left % 3600;

                minutes = parseInt(seconds_left / 60);
                seconds = parseInt(seconds_left % 60);

                // format countdown string + set tag value
                countdown.innerHTML = '<span class="days">' + days + ' <label>Days</label></span> <span class="hours">' + hours + ' <label>Hours</label></span> <span class="minutes">' +
                    minutes + ' <label>Minutes</label></span> <span class="seconds">' + seconds + ' <label>Seconds</label></span>';

            }, 1000);
        }).catch(function(error) {
            console.warn(error);
        });
    },
    castVote: function() {
        var candidateId = $('#candidatesSelect').val();
        App.contracts.Election.deployed().then(function(instance) {
            return instance.vote(candidateId, {
                from: App.account
            });
        }).then(function(result) {
            // Wait for votes to update
            $("#content").hide();
            $("#loader").show();
            App.votedEventListener();
        }).catch(function(err) {
            console.error(err);
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