// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract HealthcareCommunication {
    // Struct to store medical communication data
    struct Communication {
        address sender;
        string encryptedMessage;
        uint256 timestamp;
        bool isUrgent;
        bool isAcknowledged;
        string messageType; // e.g., "LAB_RESULT", "PRESCRIPTION", "REFERRAL"
    }

    // Mapping of communication IDs to Communication structs
    mapping(uint256 => Communication) public communications;
    
    // Mapping to track authorized healthcare providers
    mapping(address => bool) public authorizedProviders;
    
    // Mapping to track patient-provider relationships
    mapping(address => mapping(address => bool)) public patientProviderRelationship;
    
    // Counter for communication IDs
    uint256 private communicationCounter;
    
    // Events
    event NewCommunication(uint256 indexed communicationId, address indexed sender, address indexed recipient, bool isUrgent);
    event CommunicationAcknowledged(uint256 indexed communicationId, address indexed acknowledgedBy);
    event ProviderAuthorized(address indexed provider);
    event ProviderRevoked(address indexed provider);
    
    // Contract owner
    address public owner;
    
    constructor() {
        owner = msg.sender;
        authorizedProviders[msg.sender] = true;
        communicationCounter = 0;
    }
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    modifier onlyAuthorizedProvider() {
        require(authorizedProviders[msg.sender], "Only authorized providers can perform this action");
        _;
    }
    
    // Functions to manage providers
    function authorizeProvider(address provider) public onlyOwner {
        authorizedProviders[provider] = true;
        emit ProviderAuthorized(provider);
    }
    
    function revokeProvider(address provider) public onlyOwner {
        authorizedProviders[provider] = false;
        emit ProviderRevoked(provider);
    }
    
    // Function to establish patient-provider relationship
    function establishRelationship(address patient) public onlyAuthorizedProvider {
        patientProviderRelationship[patient][msg.sender] = true;
    }
    
    // Function to send a new communication
    function sendCommunication(
        address recipient,
        string memory encryptedMessage,
        bool isUrgent,
        string memory messageType
    ) public onlyAuthorizedProvider returns (uint256) {
        require(patientProviderRelationship[recipient][msg.sender] || 
                authorizedProviders[recipient], 
                "No established relationship with recipient");
        
        uint256 communicationId = communicationCounter++;
        
        communications[communicationId] = Communication({
            sender: msg.sender,
            encryptedMessage: encryptedMessage,
            timestamp: block.timestamp,
            isUrgent: isUrgent,
            isAcknowledged: false,
            messageType: messageType
        });
        
        emit NewCommunication(communicationId, msg.sender, recipient, isUrgent);
        return communicationId;
    }
    
    // Function to acknowledge receipt of communication
    function acknowledgeCommunication(uint256 communicationId) public {
        require(authorizedProviders[msg.sender], "Only authorized providers can acknowledge");
        require(!communications[communicationId].isAcknowledged, "Already acknowledged");
        
        communications[communicationId].isAcknowledged = true;
        emit CommunicationAcknowledged(communicationId, msg.sender);
    }
    
    // Function to get communication details
    function getCommunication(uint256 communicationId) public view returns (
        address sender,
        string memory encryptedMessage,
        uint256 timestamp,
        bool isUrgent,
        bool isAcknowledged,
        string memory messageType
    ) {
        Communication storage comm = communications[communicationId];
        return (
            comm.sender,
            comm.encryptedMessage,
            comm.timestamp,
            comm.isUrgent,
            comm.isAcknowledged,
            comm.messageType
        );
    }
    
    // Function to check if message is urgent
    function isMessageUrgent(uint256 communicationId) public view returns (bool) {
        return communications[communicationId].isUrgent;
    }
    
    // Function to get unacknowledged urgent messages count
    function getUnacknowledgedUrgentCount() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < communicationCounter; i++) {
            if (communications[i].isUrgent && !communications[i].isAcknowledged) {
                count++;
            }
        }
        return count;
        }
}
