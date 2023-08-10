// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Vm} from "forge-std/Vm.sol";
import {DSTest} from "ds-test/test.sol";
import {Cre8ors} from "../src/Cre8ors.sol";
import {DummyMetadataRenderer} from "./utils/DummyMetadataRenderer.sol";
import {IERC721Drop} from "../src/interfaces/IERC721Drop.sol";
import {IERC721A} from "lib/ERC721A/contracts/IERC721A.sol";
import {IERC2981, IERC165} from "lib/openzeppelin-contracts/contracts/interfaces/IERC2981.sol";
import {IOwnable} from "../src/interfaces/IOwnable.sol";
import {ERC6551Registry} from "lib/ERC6551/src/ERC6551Registry.sol";
import {Account} from "lib/tokenbound/src/Account.sol";
import {AccountGuardian} from "lib/tokenbound/src/AccountGuardian.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {Cre8ing} from "../src/Cre8ing.sol";
import {TransferHook} from "../src/hooks/Transfers.sol";
import {ICre8ors} from "../src/interfaces/ICre8ors.sol";
import {Cre8orTestBase} from "./utils/Cre8orTestBase.sol";
import {IERC721ACH} from "ERC721H/interfaces/IERC721ACH.sol";
import {IAfterTokenTransfersHook} from "ERC721H/interfaces/IAfterTokenTransfersHook.sol";
import {IERC6551Registry} from "lib/ERC6551/src/interfaces/IERC6551Registry.sol";
import {Subscription} from "../src/subscription/Subscription.sol";
import {TransferHook} from "../src/hooks/Transfers.sol";
import "forge-std/console.sol";

error NotAuthorized();

contract ERC6551Test is DSTest, Cre8orTestBase {
    Cre8ing public cre8ingBase;
    address constant DEAD_ADDRESS =
        address(0x000000000000000000000000000000000000dEaD);
    Subscription public subscription;

    function setUp() public {
        Cre8orTestBase.cre8orSetup();
        subscription = _setupSubscriptionContract(cre8orsNFTBase);

        cre8ingBase = new Cre8ing();
        _setupErc6551();
        transferHook = _setupTransferHook();
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        transferHook.setCre8ing(address(cre8ingBase));
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );
        vm.stopPrank();
    }

    function test_Erc6551Registry() public {
        _setupErc6551();
        address tokenBoundAccount = getTBA(1);
        assertTrue(!isContract(tokenBoundAccount));
    }

    function test_setErc6551Registry_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setErc6551Registry(address(erc6551Registry));
    }

    function test_setErc6551Implementation_revert_Access_OnlyAdmin() public {
        vm.expectRevert(IERC721Drop.Access_OnlyAdmin.selector);
        transferHook.setErc6551Implementation(address(erc6551Implementation));
    }

    function test_createAccount(uint256 _quantity) public {
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 18);

        address tokenBoundAccount = getTBA(_quantity);
        assertTrue(!isContract(tokenBoundAccount));

        // MINT REGISTERS WITH ERC6511
        cre8orsNFTBase.purchase(_quantity);
        emit log_address(address(tokenBoundAccount));
        assertTrue(isContract(tokenBoundAccount));
    }

    function test_createMultipleAccounts(uint256 _quantity) public {
        vm.assume(_quantity > 0);
        vm.assume(_quantity < 100);

        // No ERC6551 before purchase
        for (uint256 i = 1; i <= _quantity; i++) {
            address tokenBoundAccount = getTBA(i);
            assertTrue(!isContract(tokenBoundAccount));
        }

        // MINT REGISTERS WITH ERC6511
        cre8orsNFTBase.purchase(_quantity);

        // All CRE8ORS have ERC6551 after purchase
        for (uint256 i = 1; i <= _quantity; i++) {
            address tokenBoundAccount = getTBA(i);
            assertTrue(isContract(tokenBoundAccount));
        }
    }

    function test_sendWithTBA(
        uint256 _initialQuantity,
        uint256 _smartWalletQuantity
    ) public {
        vm.assume(_initialQuantity > 0);
        vm.assume(_initialQuantity < 19);
        vm.assume(_smartWalletQuantity > 0);
        vm.assume(_smartWalletQuantity < 19);

        address payable tokenBoundAccount = payable(getTBA(_initialQuantity));

        // MINT REGISTERS WITH ERC6511
        assertTrue(!isContract(tokenBoundAccount));
        cre8orsNFTBase.purchase(_initialQuantity);
        assertTrue(isContract(tokenBoundAccount));

        // TBA used to mint another CRE8OR
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
        uint256 value;
        bytes memory data = abi.encodeWithSignature(
            "purchase(uint256)",
            _smartWalletQuantity
        );
        bytes memory response = Account(tokenBoundAccount).executeCall(
            address(cre8orsNFTBase),
            value,
            data
        );
        uint256 tokenId = abi.decode(response, (uint256));
        assertEq(
            cre8orsNFTBase.balanceOf(tokenBoundAccount),
            _smartWalletQuantity
        );

        // use TBA to burn CRE8OR
        data = abi.encodeWithSignature(
            "safeTransferFrom(address,address,uint256)",
            tokenBoundAccount,
            DEAD_ADDRESS,
            tokenId + 1
        );
        Account(tokenBoundAccount).executeCall(
            address(cre8orsNFTBase),
            value,
            data
        );
        assertEq(
            cre8orsNFTBase.balanceOf(tokenBoundAccount),
            _smartWalletQuantity - 1
        );
    }

    function test_sendWithTBA_revert_NotAuthorized(
        uint256 _initialQuantity,
        uint256 _smartWalletQuantity
    ) public {
        vm.assume(_initialQuantity > 0);
        vm.assume(_initialQuantity < 19);
        vm.assume(_smartWalletQuantity > 0);
        vm.assume(_smartWalletQuantity < 19);

        address payable tokenBoundAccount = payable(getTBA(_initialQuantity));

        // MINT REGISTERS WITH ERC6511
        assertTrue(!isContract(tokenBoundAccount));
        vm.prank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.purchase(_initialQuantity);
        assertTrue(isContract(tokenBoundAccount));

        // TBA used to mint another CRE8OR
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
        uint256 value;
        bytes memory data = abi.encodeWithSignature(
            "purchase(uint256)",
            _smartWalletQuantity
        );
        vm.expectRevert(NotAuthorized.selector);
        Account(tokenBoundAccount).executeCall(
            address(cre8orsNFTBase),
            value,
            data
        );
        assertEq(cre8orsNFTBase.balanceOf(tokenBoundAccount), 0);
    }

    function test_transfer_only(uint256 _quantity) public {
        vm.assume(_quantity < 100);
        vm.assume(_quantity > 0);

        // ERC6551 setup
        _setupErc6551();

        address BUYER = address(0x123);
        vm.startPrank(BUYER);
        cre8orsNFTBase.purchase(_quantity);
        for (uint256 i = 1; i <= _quantity; i++) {
            cre8orsNFTBase.safeTransferFrom(BUYER, DEAD_ADDRESS, i);
        }
    }

    function _setMinterRole(address _assignee) internal {
        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        cre8orsNFTBase.grantRole(
            cre8orsNFTBase.MINTER_ROLE(),
            address(_assignee)
        );
        vm.stopPrank();
    }

    function _setupSubscriptionContract(
        Cre8ors cre8orsNFT_
    ) internal returns (Subscription _subscription) {
        _subscription = new Subscription({
            cre8orsNFT_: address(cre8orsNFT_),
            minRenewalDuration_: 1 days,
            pricePerSecond_: 38580246913 // Roughly calculates to 0.1 ether per 30 days
        });
    }

    function _setupTransferHook() internal returns (TransferHook) {
        transferHook = new TransferHook(
            address(cre8orsNFTBase),
            address(erc6551Registry),
            address(erc6551Implementation)
        );
        _setMinterRole(address(transferHook));

        vm.startPrank(DEFAULT_OWNER_ADDRESS);
        // set hook
        cre8orsNFTBase.setHook(
            IERC721ACH.HookType.AfterTokenTransfers,
            address(transferHook)
        );
        // set subscription
        transferHook.setSubscription(
            address(cre8orsNFTBase),
            address(subscription)
        );
        vm.stopPrank();

        return transferHook;
    }
}
