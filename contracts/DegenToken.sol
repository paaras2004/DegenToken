// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    uint256 total_skin;
    uint256 total_NFT;
    uint256 total_Heals;
    uint256 internal constant NFT_PRICE = 200;
    uint256 internal constant SKIN_PRICE = 150;
    uint256 internal constant HEALS_PRICE = 500;
    mapping(address => mapping(string => uint256)) public userPurchases;

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }


    function InGameStore() public pure returns (string memory) {
        return "you can buy 1)-skin(150 DGN) 2)-NFT (200 DGN) 3)-Heals(500 DGN)";
    }

    function RedeemToken(uint256 SELECT_1_for_SKIN_2_NFT_3_HEALS, uint256 quantity) public {
        require(SELECT_1_for_SKIN_2_NFT_3_HEALS == 1 || SELECT_1_for_SKIN_2_NFT_3_HEALS == 2 || SELECT_1_for_SKIN_2_NFT_3_HEALS == 3, "invalid choice use 1,2,3 only");

        if (SELECT_1_for_SKIN_2_NFT_3_HEALS == 1) {
            _purchaseItem("SKIN", SKIN_PRICE, quantity);
        } else if (SELECT_1_for_SKIN_2_NFT_3_HEALS == 2) {
            _purchaseItem("NFT", NFT_PRICE, quantity);
        } else if (SELECT_1_for_SKIN_2_NFT_3_HEALS == 3) {
            _purchaseItem("HEALS", HEALS_PRICE, quantity);
        }
    }

    function _purchaseItem(string memory itemType, uint256 price, uint256 quantity) internal {
        uint256 totalCost = price * quantity;
        _burn(msg.sender, totalCost);
        userPurchases[msg.sender][itemType] += quantity;
    }

    function send_gifts(address reciever,string memory itemType,uint256 quantity) public {
        require(userPurchases[msg.sender][itemType]>=quantity,"Know your limits brother");
        userPurchases[msg.sender][itemType]-=quantity;
        userPurchases[reciever][itemType]+=quantity;
    
    
    }
}
