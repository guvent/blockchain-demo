const {
    loadFixture
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

const { expect } = require("chai");

describe("Simple Token", function () {

    async function deploymentFixture() {
        // Contracts are deployed using the first signer/account by default
        const [owner, muzo, omer, eren, ecem] = await ethers.getSigners();

        const SimpleToken = await ethers.getContractFactory("SimpleToken");
        const simpleToken = await SimpleToken.deploy();

        const connectMuzo = await simpleToken.connect(muzo);
        const connectOmer = await simpleToken.connect(muzo);
        const connectEren = await simpleToken.connect(muzo);
        const connectEcem = await simpleToken.connect(muzo);

        return {
            simpleToken, owner,
            muzo, omer, eren, ecem,
            connectMuzo, connectOmer, connectEren, connectEcem
        };
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
            const before = "0";

            const { simpleToken, owner } = await loadFixture(deploymentFixture);

            const totalSupplyBefore = await simpleToken.totalSupply();
            expect(totalSupplyBefore).to.equal(before, "Invalid Total Supply Before Value!");

            const accountBalanceBefore = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceBefore).to.equal(before, "Invalid Account Balance Before Value!");

            await simpleToken.mint(owner.address, balance);

            const totalSupplyAfter = await simpleToken.totalSupply();
            expect(totalSupplyAfter).to.equal(balance, "Invalid Total Supply After Value!");

            const accountBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceAfter).to.equal(balance, "Invalid Account Balance After Value!");
        });

        it("Check Burn", async function () {
            const before = "10000";
            const after = "9000";
            const burn = "1000";

            const { simpleToken, owner } = await loadFixture(deploymentFixture);

            await simpleToken.mint(owner.address, before);

            const totalSupplyBefore = await simpleToken.totalSupply();
            expect(totalSupplyBefore).to.equal(before, "Invalid Total Supply Before Value!");

            const accountBalanceBefore = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceBefore).to.equal(before, "Invalid Account Balance Before Value!");

            await simpleToken.burn(burn);


            const totalSupplyAfter = await simpleToken.totalSupply();
            expect(totalSupplyAfter).to.equal(after, "Invalid Total Supply After Value!");

            const accountBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(accountBalanceAfter).to.equal(after, "Invalid Account Balance After Value!");
        });

        it("Check Transfer To", async function () {
            const beforeOwner = "10000";
            const beforeOmer = "0";
            const send = "1000";
            const afterOwner = "9000";
            const afterOmer = "1000";

            const { simpleToken, owner, omer } = await loadFixture(deploymentFixture);

            await simpleToken.mint(owner.address, beforeOwner);

            const ownerBalanceMint = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceMint).to.equal(beforeOwner, "Mint Failed (Owner Account)!");

            const omerBalanceMint = await simpleToken.balanceOf(omer.address);
            expect(omerBalanceMint).to.equal(beforeOmer, "Mint Failed (Omer Account)!");

            await simpleToken.transferTo(omer.address, send);

            const ownerBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceAfter).to.equal(afterOwner, "Transfer Failed (Owner Account)!");

            const omerBalanceAfter = await simpleToken.balanceOf(omer.address);
            expect(omerBalanceAfter).to.equal(afterOmer, "Transfer Failed (Omer Account)!");
        });

        it("Check Transfer From", async function () {
            const beforeOwner = "10000";
            const beforeMuzo = "0";
            const beforeEren = "0";

            const send = "1000";
            const afterOwner = "9000";
            const afterMuzo = "1000";
            const afterEren = "0";

            const transfer = "200";
            const transferOwner = "8800";
            const transferMuzo = "1000";
            const transferEren = "200";

            const { simpleToken, owner, muzo, eren, connectMuzo } = await loadFixture(deploymentFixture);

            await simpleToken.mint(owner.address, beforeOwner);

            const ownerBalanceMint = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceMint).to.equal(beforeOwner, "Mint Failed (Owner Account)!");

            const muzoBalanceMint = await simpleToken.balanceOf(muzo.address);
            expect(muzoBalanceMint).to.equal(beforeMuzo, "Mint Failed (Muzo Account)!");

            const erenBalanceMint = await simpleToken.balanceOf(eren.address);
            expect(erenBalanceMint).to.equal(beforeEren, "Mint Failed (Eren Account)!");

            await simpleToken.transferTo(muzo.address, send);

            const ownerBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceAfter).to.equal(afterOwner, "Transfer Failed (Owner Account)!");

            const muzoBalanceAfter = await simpleToken.balanceOf(muzo.address);
            expect(muzoBalanceAfter).to.equal(afterMuzo, "Transfer Failed (Muzo Account)!");

            const erenBalanceAfter = await simpleToken.balanceOf(eren.address);
            expect(erenBalanceAfter).to.equal(afterEren, "Transfer Failed (Eren Account)!");

            try {
                await connectMuzo.transferFrom(owner.address, eren.address, send);
                expect(false).to.equal(true, "Must be allowance error!");
            } catch (error) {
                console.info("\t >", error.message);
            }

            await simpleToken.approve(muzo.address, transfer);

            const allowance = await simpleToken.allowance(owner.address, muzo.address);
            expect(allowance).to.equal(transfer, "Approve Error!");

            await connectMuzo.transferFrom(owner.address, eren.address, transfer);

            const ownerBalanceTransfer = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceTransfer).to.equal(transferOwner, "Transfer From Failed (Owner Account)!");

            const muzoBalanceTransfer = await simpleToken.balanceOf(muzo.address);
            expect(muzoBalanceTransfer).to.equal(transferMuzo, "Transfer From Failed (Muzo Account)!");

            const erenBalanceTransfer = await simpleToken.balanceOf(eren.address);
            expect(erenBalanceTransfer).to.equal(transferEren, "Transfer From Failed (Eren Account)!");
        });

        it("Check Pause & Blacklist Transfer", async function () {
            const beforeOwner = "10000";
            const beforeMuzo = "0";
            const beforeEren = "0";

            const send = "1000";
            const afterOwner = "9000";
            const afterMuzo = "1000";
            const afterEren = "0";

            const transfer = "200";
            const transferOwner = "8800";
            const transferMuzo = "1000";
            const transferEren = "200";

            const { simpleToken, owner, muzo, eren, connectMuzo } = await loadFixture(deploymentFixture);

            await simpleToken.mint(owner.address, beforeOwner);

            const ownerBalanceMint = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceMint).to.equal(beforeOwner, "Mint Failed (Owner Account)!");

            const muzoBalanceMint = await simpleToken.balanceOf(muzo.address);
            expect(muzoBalanceMint).to.equal(beforeMuzo, "Mint Failed (Muzo Account)!");

            const erenBalanceMint = await simpleToken.balanceOf(eren.address);
            expect(erenBalanceMint).to.equal(beforeEren, "Mint Failed (Eren Account)!");

            await simpleToken.transferTo(muzo.address, send);

            const ownerBalanceAfter = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceAfter).to.equal(afterOwner, "Transfer Failed (Owner Account)!");

            const muzoBalanceAfter = await simpleToken.balanceOf(muzo.address);
            expect(muzoBalanceAfter).to.equal(afterMuzo, "Transfer Failed (Muzo Account)!");

            const erenBalanceAfter = await simpleToken.balanceOf(eren.address);
            expect(erenBalanceAfter).to.equal(afterEren, "Transfer Failed (Eren Account)!");

            try {
                await connectMuzo.transferFrom(owner.address, eren.address, send);
                expect(false).to.equal(true, "Must be allowance error!");
            } catch (error) {
                console.info("\t >", error.message);
            }

            await simpleToken.approve(muzo.address, transfer);

            const allowance = await simpleToken.allowance(owner.address, muzo.address);
            expect(allowance).to.equal(transfer, "Approve Error!");

            await simpleToken.pause();

            try {
                await connectMuzo.transferFrom(owner.address, eren.address, transfer);
                expect(false).to.equal(true, "Must be paused error!");
            } catch (error) {
                console.info("\t >", error.message);
                expect(error.message).to.contain("Token Paused!");
            }

            await simpleToken.unpause();

            await connectMuzo.transferFrom(owner.address, eren.address, transfer);

            const ownerBalanceTransfer = await simpleToken.balanceOf(owner.address);
            expect(ownerBalanceTransfer).to.equal(transferOwner, "Transfer From Failed (Owner Account)!");

            const muzoBalanceTransfer = await simpleToken.balanceOf(muzo.address);
            expect(muzoBalanceTransfer).to.equal(transferMuzo, "Transfer From Failed (Muzo Account)!");

            const erenBalanceTransfer = await simpleToken.balanceOf(eren.address);
            expect(erenBalanceTransfer).to.equal(transferEren, "Transfer From Failed (Eren Account)!");

            await simpleToken.approve(muzo.address, transfer);

            await simpleToken.blacklistAccount(muzo.address);

            try {
                await connectMuzo.transferFrom(owner.address, eren.address, transfer);
                expect(false).to.equal(true, "Must be blacklist error!");
            } catch (error) {
                console.info("\t >", error.message);
                expect(error.message).to.contain("Sender Account Blocked!");
            }
        });

        it("Check Increase Decrease Allowance", async function () {
            const approve = "100";

            const { simpleToken, owner, ecem } = await loadFixture(deploymentFixture);

            await simpleToken.approve(ecem.address, approve);

            const allowance = await simpleToken.allowance(owner.address, ecem.address);
            expect(allowance).to.equal(approve, "Approve Error!");

            await simpleToken.increaseAllowance(ecem.address, "10");
            const increase = await simpleToken.allowance(owner.address, ecem.address);
            expect(increase).to.equal("110", "Increase Approve Error!");

            await simpleToken.decreaseAllowance(ecem.address, "20");
            const decrease = await simpleToken.allowance(owner.address, ecem.address);
            expect(decrease).to.equal("90", "Decrease Approve Error!");
        });
    })
});