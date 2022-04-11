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
        ...User,
        deadline:UInt,
        bidFloor:UInt,
     });
    const Bidder = API('Bidder', { 
       //inteeract interface goes here
       ...User,
       isHighestBidder: Fun([],Bool),
    });
    //MetaMask injects a global API into websites visited by its users at window.ethereum.
    //This API allows websites to request users' Ethereum accounts, read data from blockchains the user is connected to,
    //and suggest that the user sign messages and transactions. The presence of the provider object indicates an Ethereum user. 
    //We recommend using @metamask/detect-provider (opens new window)to detect our provider, on any platform or browser.
    init();

    Creator.only(()=>{
        //do something
        const deadline=declassify(interact.deadline);
        const bidFloor=declassify(interact.bidFloor);
    });
    Creator.publish(deadline);
    Creator.publish(bidFloor);
    commit();

    const deadlineBlock = relativeTime(deadline);
    const Prices = new Set();
    Prices.insert(bidFloor)

    const [ keepGoing ,howmany , priceBid ] = 
      parallelReduce([ true, 0, bidFloor ])
        .invariant(Prices.Map.size() == howMany)
        .while(keepGoing)
        .api(Bidder.seePrice,
            (k)=>{ 
              const priceBid = k;
              Prices.insert(priceBid)
              return [ keepGoing, howmany+1, Prices[-2] ] 
            },)
         .timeout(deadlineBlock, () => {
            showOutcome(TIMEOUT)();
            return [ false, howmany, Prices[-2] ]; 
          
      });
      transfer(priceBid).to(Creator);
      commit();
      exit();
});

/*// This function detects most providers injected at window.ethereum
import detectEthereumProvider from '@metamask/detect-provider';

const provider = await detectEthereumProvider();

if (provider) {
  // From now on, this should always be true:
  // provider === window.ethereum
  startApp(provider); // initialize your app
} else {
  console.log('Please install MetaMask!');
}*/