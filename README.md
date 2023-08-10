"ERC721H is an implementation of IERC721 that introduces "Hooks", bringing additional flexibility and control to creators and collections. The Cre8ors contract will be a hybrid ERC721ACH with ownership of an ERC6551 smart wallet. We collaborated with external security consultants to verify the solidity of our approach. We advocate for the community to embrace this implementation to maximize creator ownership of their collections onchain IP." https://mirror.xyz/sweetman.eth/gKpHCW-6wviwbQn_zzG7vQDZ-TxoV9GwWFdXaT_QzC4


"They’re a novel collection of 8,888 Artificially Intelligent
Protocol-Enabled Pictures, or AiPEP’s that blend B&W
AI photography with colorful 2D-characters into one
stand-out avatar. PFP’s will never be the same."

"Imagine minting a musician that creates music for you, or a writer
that writes for you. As artificial intelligence improves, so does your
NFT. One day your Cre8or might make a hit song, or write a best-
selling novel. If you own the NFT then you own the IP; and since
you own the IP, you reap all the rewards. PFPs that you’ll pass
down to your grandkids for generations to come."

"Cre8ors PFP’s are a new interactive ERC-721ACH hybrid token that comes with ownership of its own
ERC-6551 smart wallet. Each PFP comes with a creative DNA card NFT inside. This card represents your
Cre8ors archetype trait. Trade your cards and change your traits without the need to sell your entire PFP."

"We believe IP is one of the most valuable utilities for NFT
holders, so why stop at just the artwork? Our in-house IP
management and licensing department can help you license
your Cre8ors IP. From the artwork to the co-creations you make
with the community, Cre8ors mission is to unleash your creative
potential and unlock financial freedom for our members."

"Cre8ors Protocol is an interoperable smart contract that
uses novel community-bonding mechanics to generate
composable media catalogs at scale. But, WTF does that
mean? We’re building a series of remix dApps that make it fun
and easy for holders to collaborate, license, and get
paid when co-creating on-chain with friends and other
communities."


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
