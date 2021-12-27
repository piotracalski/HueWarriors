const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('HueWarriors');
  const gameContract = await gameContractFactory.deploy(
    ["Red warrior", "Green warrior", "Blue warrior"],       // Names
    ["https://huewarriors.web.app/img/warrior-red.png", // Images
    "https://huewarriors.web.app/img/warrior-green.png", 
    "https://huewarriors.web.app/img/warrior-blue.png"],
    [100, 200, 300],                    // Purity values
    [100, 50, 25],                      // Attack strength values
    [20, 10, 5],                         // Critical hit values
    "Lurid Giant", // boss name
    "https://huewarriors.web.app/img/lurid-giant.png", // boss image
    5000, // boss purity
    50, // boss damage
    25 // boss critical hit chance
  );
  
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);
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