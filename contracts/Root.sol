// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./libraries/Base64.sol";
import "./libraries/IterableMapping.sol";

contract Root is ERC721 {
    struct Member {
        string username;
        string profilePicture;
        uint64 friends;
        uint64 posts;
    }

    struct Post {
        string title;
        string content;
        string picture;
        string video;
    }

    using SafeMath for uint64;
    using IterableMapping for IterableMapping.Map;

    using Counters for Counters.Counter;

    Counters.Counter private _profileId;

    mapping(uint256 => Member) public members;
    mapping(uint256 => address) public profilesOwners;
    mapping(uint256 => Post[]) public postsMapping;

    event ProfileNFTMinted(address sender, uint256 profileId);
    
    constructor() ERC721("Profile", "ROOT") {
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        Member memory memberAttributes = members[
            _tokenId
        ];

        string
            memory profilePicture = memberAttributes.profilePicture;
        string memory friends = Strings.toString(memberAttributes.friends);
        string memory posts = Strings.toString(memberAttributes.posts);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                         '{"username": "',
                        memberAttributes.username,
                        "Member No: ",
                        Strings.toString(_tokenId),
                        '", "description": "Profile NFT", "image": "',
                        profilePicture,
                        '","attributes": [ { "trait_type": "Friends", "value": ',
                        friends,
                        '}, { "trait_type": "Posts", "value": ',
                        posts,
                        '}} ]}'
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function checkProfileOwner(uint256 _memberProfileId) public view returns (Member memory) {
        if (profilesOwners[_memberProfileId] == msg.sender) {
            return members[_memberProfileId];
        } else {
            revert("Not the owner of the profile");
        }
    }

        function mintProfileNFT(string memory _username, string memory _profilePicture)
        external
    {
        uint256 newProfileId = _profileId.current();

        _safeMint(msg.sender, newProfileId);

        members[newProfileId] = Member({
            username: _username,
            profilePicture: _profilePicture,
            friends: 0,
            posts: 0
        });

        profilesOwners[newProfileId] = msg.sender;

        _profileId.increment();

        emit ProfileNFTMinted(msg.sender, newProfileId);
    }
}