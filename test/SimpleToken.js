const {
    loadFixture
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

const { expect } = require("chai");

describe("Simple Token", function () {

    async function deploymentFixture() {
        // Contracts are deployed using the first signer/account by default
        const [owner, otherAccount] = await ethers.getSigners();

        const SimpleToken = await ethers.getContractFactory("SimpleToken");
        const simpleToken = await SimpleToken.deploy();

        return { simpleToken, owner, otherAccount };
    }

    describe("Deployment", function () {
        it("Deploy to network", async function () {
            const { simpleToken } = await loadFixture(deploymentFixture);

            expect(simpleToken).not.to.equal(null, "Deployment Failed!");
            expect(simpleToken).not.to.equal(undefined, "Deployment Failed!");
        });

        it("Check Properties", async function () {
            const { simpleToken, owner } = await loadFixture(deploymentFixture);

            const name = await simpleToken.name();
            const symbol = await simpleToken.symbol();
            const tokenOwner = await simpleToken.owner();

            expect(name).to.equal("Simple Token", "Invalid Token Name!");
            expect(symbol).to.equal("SIMPLET", "Invalid Token Symbol!");
            expect(tokenOwner).to.equal(owner.address, "Invalid Token Owner!");
        });

        it("Check Pause", async function () {
            const { simpleToken } = await loadFixture(deploymentFixture);

            const status = await simpleToken.paused();
            expect(status).to.equal(false, "Status must not be TRUE!");

            await simpleToken.pause();
            const isPaused = await simpleToken.paused();

            expect(isPaused).to.equal(true, "Cannot set as PAUSED!");

            await simpleToken.unpause();
            const isUnPaused = await simpleToken.paused();

            expect(isUnPaused).to.equal(false, "Cannot set as UNPAUSED!");
        });

        it("Check Mint With Owner", async function () {
            const balance = "10000";

            const { simpleToken, owner } = await loadFixture(deploymentFixture);

            const totalSupplyBefore = await simpleToken.totalSupply();
            expect(totalSupplyBefore).to.equal("0", "Invalid Total Supply Before Value!");

            const accountBalanceBefore = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceBefore).to.equal("0", "Invalid Account Balance Before Value!");

            await simpleToken.mint(owner.address, balance);

            const totalSupplyAfter = await simpleToken.totalSupply();
            expect(totalSupplyAfter).to.equal(balance, "Invalid Total Supply After Value!");

            const accountBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceAfter).to.equal(balance, "Invalid Account Balance After Value!");
        });

        it("Check Burn", async function () {
            const before = "10000";
            const after = "9000";

            const { simpleToken, owner } = await loadFixture(deploymentFixture);

            await simpleToken.mint(owner.address, before);

            const totalSupplyBefore = await simpleToken.totalSupply();
            expect(totalSupplyBefore).to.equal(before, "Invalid Total Supply Before Value!");

            const accountBalanceBefore = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceBefore).to.equal(before, "Invalid Account Balance Before Value!");

            await simpleToken.burn("1000");


            const totalSupplyAfter = await simpleToken.totalSupply();
            expect(totalSupplyAfter).to.equal(after, "Invalid Total Supply After Value!");

            const accountBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceAfter).to.equal(after, "Invalid Account Balance After Value!");
        });
    })
});