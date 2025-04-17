// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameProgressCertificate {
    struct Progress {
        bool completed;
        uint256 coinsCollected;
        uint256 certificateId;
    }

    uint256 public nextCertificateId = 1;

    mapping(address => mapping(uint256 => Progress)) public progressByUser; // user => level => Progress

    event LevelCompleted(
        address indexed player,
        uint256 level,
        uint256 coinsCollected,
        uint256 certificateId
    );

    function recordLevelCompletion(uint256 level, uint256 coinsCollected) external {
        require(!progressByUser[msg.sender][level].completed, "Level already completed");

        uint256 certificateId = nextCertificateId++;
        progressByUser[msg.sender][level] = Progress(true, coinsCollected, certificateId);

        emit LevelCompleted(msg.sender, level, coinsCollected, certificateId);
    }

    function getCertificateId(address user, uint256 level) external view returns (uint256) {
        require(progressByUser[user][level].completed, "Level not completed yet");
        return progressByUser[user][level].certificateId;
    }

    function hasCompleted(address user, uint256 level) external view returns (bool) {
        return progressByUser[user][level].completed;
    }
}
