// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./libraries/Base64.sol";
import "./libraries/IterableMappingPosts.sol";

import {DataTypes} from "./DataTypes.sol";

contract Root is ERC721 {
    struct Member {
        string username;
        string profilePicture;
        uint64 followers;
        uint256 posts;
    }

    using SafeMath for uint64;
    using IterableMappingPosts for IterableMappingPosts.Map;

    using Counters for Counters.Counter;

    Counters.Counter private _profileId;
    Counters.Counter private _postNumber;

    mapping(uint256 => Member) public members;
    mapping(uint256 => address) public profilesOwners;
    IterableMappingPosts.Map private postsMapping;
    mapping(uint256 => string[]) public profilePosts;
    mapping(string => DataTypes.Comment[]) public postComments;
    mapping(string => bool) public doesPostExist;


    event ProfileNFTMinted(address sender, uint256 profileId);
    
    constructor() ERC721("Profile", "ROOT") {
    }

    modifier isProfileOwner(uint256 _memberId) {
        require(profilesOwners[_memberId] == msg.sender, "Not the owner of the profile");
        _;
    }

    modifier postExist(string memory _postToCheck) {
        require(doesPostExist[_postToCheck], "Post doesn't exist!");
        _;
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
        string memory followers = Strings.toString(memberAttributes.followers);
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
                        '","attributes": [ { "trait_type": "Followers", "value": ',
                        followers,
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
            followers: 0,
            posts: 0
        });

        profilesOwners[newProfileId] = msg.sender;

        _profileId.increment();

        emit ProfileNFTMinted(msg.sender, newProfileId);
    }

    function addPost(DataTypes.PostClient calldata _postToAdd, uint256 _memberId) external isProfileOwner(_memberId) {
        string memory postId = string(abi.encodePacked(Strings.toString(_memberId),'-',Strings.toString(_postNumber.current())));
        _postNumber.increment();
        profilePosts[_memberId].push(postId);
        uint256 postsLength = profilePosts[_memberId].length;
        Member storage member = members[_memberId];
        member.posts = postsLength;
        doesPostExist[postId] = true;

        DataTypes.Post memory newPost = DataTypes.Post({
            title: _postToAdd.title,
            content: _postToAdd.content,
            picture: _postToAdd.picture,
            video: _postToAdd.video,
            authorId: _memberId,
            date: block.timestamp
        });
        
        postsMapping.set(postId, newPost);
    }

    function getPost(string memory _postId) public view returns(DataTypes.Post memory) {
        DataTypes.Post memory userPosts = postsMapping.get(_postId);
        return userPosts;
    }

    function getUsersPostsIds(uint256 _memberId) public view returns(string[] memory) {
        string[] memory postsIds = profilePosts[_memberId];
        return postsIds;
    }

    function addComment(string memory _commentToAdd, string memory _postId, uint256 _memberId) external postExist(_postId) isProfileOwner(_memberId) {
        DataTypes.Comment memory newComment = DataTypes.Comment({
            content: _commentToAdd,
            authorId: _memberId,
            date: block.timestamp
        });
        postComments[_postId].push(newComment);
    }

    function getComments(string memory _postId) public view postExist(_postId) returns(DataTypes.Comment[] memory){
        return postComments[_postId];
    }
}