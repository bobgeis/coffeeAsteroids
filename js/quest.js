// Generated by CoffeeScript 1.10.0
(function() {
  "Quest\n\nThese are messages that the player will see when they dock at one of the stations.\n";
  var Q;

  Q = {};

  _first.offer('quest', Q);

  Q.lucky = [["Welcome to Doctor Lucky's Research Hospital and Veterinary Clinic!", " ", "Thank you for coming to clear out the rocks here. We don't know where they came", "from, but they are a hazard.  We can respin your drive core whenever you need.", " ", "We serve the medical needs of the community here in Subspace Locus 1457.", "Right now that community is just you, our sister base a klick to the Southeast,", "and the few ships that pass through here on their way between New Dilgan", "and Alpha Octolindis.", " ", "We also have few research projects on the side.  We are far from any sources of", "funding or fame.  But on the other hand we are also far from any oversight or", "ethics committees!", " ", "Be careful out there.  And please refer any potential patients. Especially any", "vertebrates; we just got a new mammal scanner!"], ["Welcome back to Doctor Lucky's Research Hospital and Veterinary Clinic!", " ", "Oh a patient referral!  Shipwreck survivors weren't what we were thinking, but", "we'll take all the business we can get.", " ", "To thank you, we're going to give your ship's computer access to the base ", "transponder system.  This should help you navigate while you're in the locus."]];

  Q.build = [["Welcome to Pick & Hammer Guilds' Crystal Depot and Refinery.", " ", "Thank you for coming to clear out the rocks here at Subspace Locus 1457.  They", "interfere with shipping between Alpha Octolindis and New Dilgan.", " ", "If any of the rocks happen to contain space crystals, then bring them here and", "we can assess their worth.", " ", "Either way we'll respin your drive core whenver you dock.  Good luck."], ["Welcome back to Pick & Hammer Guilds' Crystal Depot and Refinery.", " ", "Oh you found space crystals!  We'll send for an expert from Alpha Octolindis to", "assess them and maybe we can find out where they're coming from.", " ", "In the mean time, we're going to outfit a targeting laser to your ship. It", "should make mining easier, particularly against the small rocks.  Keep bringing", "us any space crystals you find!"]];

  Q.getNextQuest = function(base, crystal, lifepod, mousepod) {
    if (base === "lucky") {
      return Q.lucky[0];
    } else {
      return Q.build[0];
    }
  };

}).call(this);
