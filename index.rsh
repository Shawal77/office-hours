'reach 0.1';
'use strict';

//interface to be used by all users
const User={
    seePrice: Fun([],UInt),
    getDescription: Fun([],Bytes(128)),
};

//three participants creator bidder buyer
export const main=Reach.App(()=>{
    const Creator = Participant('Creator', { 
        //inteeract interface goes here
        ...User
     });
    const Bidder = API('Bidder', { 
       //inteeract interface goes here
       ...User,
       isHighestBidder: Fun([],Bool),
    });
});
init();

Creator.only(()=>{
    //do something
});

Bidder.only(()=>{//local step
    //do something
    const price = declassify(interact.seePrice);//only use interact in only,each or case
});//local step
Bidder.publish(price) //consensus step
    .pay(price);

Buyer.only(()=>{
    //do something
    const description=declassify(interact.getDescription);
});
Buyer.publish(description);