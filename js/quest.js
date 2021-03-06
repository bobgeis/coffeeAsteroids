// Generated by CoffeeScript 1.10.0
(function() {
  "Quest\n\nThese are messages that the player will see when they dock at one of the stations.\n";
  var Q, b0, l0;

  Q = {};

  _first.offer('quest', Q);

  Q.getNextQuest = function(base, crystal, lifepod, mousepod) {
    if (base === "lucky") {
      return Q.lucky[0];
    } else {
      return Q.build[0];
    }
  };

  l0 = ["Welcome to Doctor Lucky's Research Hospital and Veterinary Clinic!", " ", "Now accepting new patients!", " ", "We service colony and medical ships traveling between the colony at New Dilgan", "and the lattice at Alpha Octolindis.", " ", "Bring us any shipwreck survivors you find.  We'll take care of them, and then have", "our lab mice take a look at your shields."];

  b0 = ["Welcome to B&M Guild Fuel Depot and Refinery at Subspace Locus 1457.", " ", "Thanks for coming to clear out these space rocks!", " ", "We service mining and construction ships doing business between the lattice at", "Alpha Octolindis and the colony at New Dilgan.", " ", "Bring us any space crystals you find.  We can use them to improve your disruptor."];

  Q.lucky = [l0];

  Q.build = [b0];

}).call(this);
