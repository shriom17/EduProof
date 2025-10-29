// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EduProof {

    // Owner (e.g., admin who can approve institutions)
    address public owner;

    constructor() {
        owner = msg.sender; // contract deployer becomes the owner
    }

    // Structure to store certificate details
    struct Certificate {
        string studentName;
        string courseName;
        string institution;
        string issueDate;
        bool isValid;
    }

    // Mapping certificate ID => Certificate data
    mapping(string => Certificate) private certificates;

    // Events for logging
    event CertificateIssued(string certificateId, string studentName, string courseName, string institution);
    event CertificateRevoked(string certificateId);

    // Modifier: only owner can do some actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // Function to issue a new certificate
    function issueCertificate(
        string memory _certificateId,
        string memory _studentName,
        string memory _courseName,
        string memory _institution,
        string memory _issueDate
    ) public onlyOwner {
        require(!certificates[_certificateId].isValid, "Certificate ID already exists");

        certificates[_certificateId] = Certificate({
            studentName: _studentName,
            courseName: _courseName,
            institution: _institution,
            issueDate: _issueDate,
            isValid: true
        });

        emit CertificateIssued(_certificateId, _studentName, _courseName, _institution);
    }

    // Function to verify certificate by ID
    function verifyCertificate(string memory _certificateId) public view returns (
        string memory studentName,
        string memory courseName,
        string memory institution,
        string memory issueDate,
        bool isValid
    ) {
        Certificate memory cert = certificates[_certificateId];
        return (
            cert.studentName,
            cert.courseName,
            cert.institution,
            cert.issueDate,
            cert.isValid
        );
    }

    // Function to revoke certificate
    function revokeCertificate(string memory _certificateId) public onlyOwner {
        require(certificates[_certificateId].isValid, "Certificate not found or already revoked");
        certificates[_certificateId].isValid = false;
        emit CertificateRevoked(_certificateId);
    }
}

