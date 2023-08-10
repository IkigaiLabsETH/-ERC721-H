1. Minting 2 tokens - cre8ors PFP & DNA card
2. Creating an ERC6551 smart wallet
3. Putting your NFT into stacking 
4. Registering your cre8or liquid license
5. Setting your cre8or lock-up

The gas that had to be paid would include 3 transactions: 

1. Minting PFP
2. Creating a smart wallet
3. Minting DNA card


# CRE8ORS

- the CRE8ORS

<img width="571" alt="Screenshot 2022-12-01 at 12 04 32 PM" src="https://user-images.githubusercontent.com/23249402/205087429-8f33a283-07a7-4ec4-bbeb-c9ad293bf107.png">

### Getting Started

- install [forge](https://mirror.xyz/crisgarner.eth/BhQzl33tthkJJ3Oh2ehAD_2FXGGlMupKlrUUcDk0ALA)
- run `forge test`

### Features

- `purchase(uint256 quantity)`
- `purchasePresale(...)`
- `adminMint(address recipient, uint256 quantity)`
- `adminMintAirdrop(address[] calldata recipients)`
- Royalties - IERC2981

### Admin capabilities

- `setOwner()`
- `setFundsRecipient()`
- `setSaleConfiguration()`
- `setMetadataRenderer()`
- `withdraw()`
