async function main() {
    // Using 'ethers' which is a JavaScript library to interact with Ethereum,
    // we are grabbing the Fundraising contract, compiling it and then we are deploying it one argument.
    const Fundraising = await ethers.getContractFactory("Fundraising");
    // This is the argument that the constructor or our contract needs, the `targetAmount` of money that we want to raise in our campaign.
    const contract = await Fundraising.deploy(ethers.utils.parseEther("100.0"));
    console.log("Contract address is:", contract.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
  });