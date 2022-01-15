const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PHO", function () {
  it("Should return the SVG code without header", async function () {
    const PHO_Factory = await ethers.getContractFactory("PHO");
    const PHO = await PHO_Factory.deploy();
    await PHO.deployed();

    var res = await PHO._getSVG(0,1);
    console.log(res);
    res = await PHO._getSVG(1,1);
    console.log(res);
    res = await PHO._getSVG(2,16);
    console.log(res);
    res = await PHO._getSVG(3,0);
    console.log(res);
    res = await PHO._getSVG(4,0);
    console.log(res);
    res = await PHO._getSVG(5,0);
    console.log(res);

  });
});
