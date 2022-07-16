require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.0",
  networks: {
   goerli: {
     url: "https://ethereum-goerli-rpc.allthatnode.com/EKoNpBaKpMvs3GYnJgUw5V4r3pOWNcqO",
     accounts: ['d5fee00e51c9d775d1097a9f24ca1feb73d3c6c80c66553a5d80b8f48c4ece22']
   
   },
  },
};