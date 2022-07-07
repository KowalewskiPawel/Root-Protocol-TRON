// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.0;

library DataTypes {
    
    struct Member {
        uint256 userId;
        string username;
        string profilePicture;
        uint256 followers;
        uint256 posts;
    }

    struct Comment {
        string idOfPost;
        string content;
        uint authorId;
        uint date;
    }

    struct Post {
        string id;
        string title;
        string content;
        string picture;
        string video;
        uint authorId;
        uint date;
    }

    struct PostClient {
        string title;
        string content;
        string picture;
        string video;
    }
}