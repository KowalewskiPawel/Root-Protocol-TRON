// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.0;

library DataTypes {
    struct Comment {
        string content;
        uint authorId;
        uint date;
    }

    struct Post {
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
