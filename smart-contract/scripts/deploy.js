const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('HueWarriors');
  const gameContract = await gameContractFactory.deploy(
    ["Red warrior", "Green warrior", "Blue warrior"],       // Names
    ["https://huewarriors.web.app/img/warrior-red.png", // Images
    "https://huewarriors.web.app/img/warrior-green.png", 
    "https://huewarriors.web.app/img/warrior-blue.png"],
    [100, 200, 300],                    // Purity values
    [100, 50, 25],                      // Attack strength values
    [20, 10, 5]                         // Critical hit values
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #4");

  console.log("Done deploying and minting!");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();