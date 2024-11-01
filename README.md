HealthcareCommunication Smart Contract
The HealthcareCommunication smart contract provides a secure, decentralized communication platform for healthcare providers to share and acknowledge sensitive medical data. This contract ensures that only authorized healthcare providers can send and acknowledge communications, and it maintains secure patient-provider relationships.

Features
Authorized Healthcare Providers: Only approved healthcare providers can interact with patient data.
Patient-Provider Relationship Management: Enables establishing trusted relationships between providers and patients.
Secure Communication: Allows providers to send encrypted, timestamped messages tagged by message type.
Acknowledgement and Urgency Tracking: Communications can be marked as urgent, and providers can acknowledge receipt.
Query Functions: Retrieve communication details and unacknowledged urgent message counts.
Contract Structure
Variables
Communication: A struct to store details of each communication (sender, encrypted message, timestamp, urgency, acknowledgment status, and message type).
authorizedProviders: Mapping of addresses to determine authorized healthcare providers.
patientProviderRelationship: Mapping to track existing patient-provider relationships.
communicationCounter: Counter to assign unique communication IDs.
owner: Address of the contract owner.
Modifiers
onlyOwner: Restricts access to contract owner.
onlyAuthorizedProvider: Restricts access to authorized providers only.
Functions
Provider Management
authorizeProvider(address provider): Allows the contract owner to add an authorized provider.
revokeProvider(address provider): Allows the contract owner to remove an authorized provider.
Relationship Management
establishRelationship(address patient): Creates a patient-provider relationship.
Communication
sendCommunication(address recipient, string memory encryptedMessage, bool isUrgent, string memory messageType): Sends a new encrypted communication to a patient or provider.
acknowledgeCommunication(uint256 communicationId): Marks a communication as acknowledged.
getCommunication(uint256 communicationId): Retrieves details of a specific communication.
isMessageUrgent(uint256 communicationId): Checks if a message is urgent.
getUnacknowledgedUrgentCount(): Returns the count of unacknowledged urgent communications.
Events
NewCommunication: Emitted when a new communication is sent.
CommunicationAcknowledged: Emitted when a communication is acknowledged.
ProviderAuthorized: Emitted when a new provider is authorized.
ProviderRevoked: Emitted when a provider's authorization is revoked.
Usage
Deploy the Contract: Only the contract owner can authorize providers.
Establish Patient-Provider Relationships: Providers create relationships with patients before sending messages.
Send Communications: Authorized providers send encrypted messages, marked urgent if necessary.
Acknowledge Communications: Authorized providers acknowledge receipt of communications, especially for urgent messages.
Query Communication Details: Anyone can view the public details of a communication.
Example Workflow
Authorize a Provider: The owner authorizes a healthcare provider.

solidity
Copy code
authorizeProvider(providerAddress);
Establish Relationship: A provider establishes a relationship with a patient.

solidity
Copy code
establishRelationship(patientAddress);
Send a Communication: An authorized provider sends an encrypted message to a patient.

solidity
Copy code
sendCommunication(patientAddress, "encryptedMessageHere", true, "PRESCRIPTION");
Acknowledge Communication: The recipient or provider acknowledges receipt.

solidity
Copy code
acknowledgeCommunication(communicationId);
Get Urgent Communication Count: Anyone can check the number of unacknowledged urgent communications.

solidity
Copy code
getUnacknowledgedUrgentCount();
