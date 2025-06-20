const { ethers } = require("hardhat");

async function main() {
  const CrowdfundingCampaign = await ethers.getContractFactory("CrowdfundingCampaign");

  // Customize these arguments as needed
  const campaignName = "Save the Rainforest";
  const goalAmount = ethers.utils.parseEther("10"); // 10 ETH goal
  const durationInDays = 30;

  const contract = await CrowdfundingCampaign.deploy(campaignName, goalAmount, durationInDays);

  await contract.deployed();

  console.log("✅ CrowdfundingCampaign deployed to:", contract.address);
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});
