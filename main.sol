// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IdentityVerification {
    struct Identity {
        string name;
        string email;
        address verifier;
        bool verified;
    }

    mapping(address => Identity) public identities;

    event IdentityCreated(address indexed user, string name, string email);
    event IdentityVerified(address indexed user, address indexed verifier);
    event IdentityRevoked(address indexed user);

    modifier onlyVerifier() {
        require(msg.sender == identities[msg.sender].verifier, "Not a trusted verifier");
        _;
    }

    function createIdentity(string memory _name, string memory _email) public {
        identities[msg.sender] = Identity(_name, _email, msg.sender, false);
        emit IdentityCreated(msg.sender, _name, _email);
    }

    function verifyIdentity(address _user) public onlyVerifier {
        identities[_user].verified = true;
        emit IdentityVerified(_user, msg.sender);
    }

    function revokeIdentity(address _user) public onlyVerifier {
        identities[_user].verified = false;
        emit IdentityRevoked(_user);
    }

    function getIdentity(address _user) public view returns (Identity memory) {
        return identities[_user];
    }
}
