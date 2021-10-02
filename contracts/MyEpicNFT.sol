// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

//open zeppelin imports
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

//import hardhat
import "hardhat/console.sol";

//import helper functions
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    //random word pool
    string[] firstWords = [
        "Red",
        "Blue",
        "Green",
        "Orange",
        "Yellow",
        "Black",
        "Purple",
        "White",
        "Brown",
        "Pink",
        "Lime",
        "Turquise",
        "Pearl",
        "Magenta",
        "Onyx"
    ];
    string[] secondWords = [
        "Cookie",
        "Coffee",
        "IceCream",
        "Chocolate",
        "Candy",
        "Sushi",
        "Steak",
        "Burrito",
        "Chips",
        "Tempura",
        "Tapas",
        "Pizza",
        "Gindara",
        "PekingDuck",
        "Gambas"
    ];
    string[] thirdWords = [
        "Cat",
        "Dog",
        "Rat",
        "Pig",
        "Cow",
        "Dragon",
        "Phoenix",
        "Ox",
        "Donkey",
        "Monkey",
        "Rooster",
        "Duck",
        "Lion",
        "Gazelle",
        "Owl"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("WordAnimals", "WONIMALS") {
        console.log("This is my NFT contract");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );

        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );

        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );

        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        //create id
        uint256 newItemId = _tokenIds.current();

        //pick the words
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        //combine word
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        //add to svg
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        //create the JSON metadata
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        //set title of NFT as combined word
                        combinedWord,
                        '", "description": "A highly acclaimed collection of Animals.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        //prepend JSON data to data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        //mint nft
        _safeMint(msg.sender, newItemId);

        //set nft data
        _setTokenURI(newItemId, finalTokenUri);

        //increment token id for future nft mint
        _tokenIds.increment();

        console.log(
            "An NFT with id %s has been minted to  address %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
