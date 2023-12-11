# Crowdfunding Smart Contract

This repository contains a simple crowdfunding smart contract implemented in Solidity. The contract allows contributors to fund a project, and an administrator can create funding requests that require approval from contributors before payments are made.

## Overview

The Crowdfunding smart contract includes the following features:

- **Contributions**: Contributors can send funds to the contract, and their contributions are tracked.

- **Refunds**: Contributors can request refunds if the crowdfunding goal is not met by the specified deadline.

- **Funding Requests**: The administrator can create funding requests, specifying the description, recipient address, and amount. Contributors can vote on these requests.

- **Payments**: Once a funding request has received enough votes, the administrator can make a payment to the specified recipient.

## Smart Contract Details

### State Variables

- `contributors`: Mapping to store contributors and their contributed amounts.
- `admin`: Address of the administrator.
- `noOfContributors`: Number of contributors.
- `minimumContribution`: Minimum contribution required from each contributor.
- `deadline`: Crowdfunding deadline.
- `goal`: Funding goal.
- `raisedAmount`: Total amount raised.
- `requests`: Mapping to store funding requests.
- `numRequests`: Number of funding requests.

### Struct

- `Request`: Struct representing a funding request, including description, recipient address, requested amount, completion status, number of voters, and a mapping to track voters.

### Events

- `ContributeEvent`: Event emitted when a contribution is made.
- `CreateRequestEvent`: Event emitted when a funding request is created.
- `MakePaymentEvent`: Event emitted when a payment is made for a funding request.

### Functions

- `contribute`: Allows contributors to contribute funds.
- `getBalance`: Retrieves the balance of the contract.
- `getRefund`: Allows contributors to request a refund if the goal is not met by the deadline.
- `onlyAdmin`: Modifier to restrict access to only the administrator.
- `createRequest`: Allows the administrator to create a funding request.
- `voteRequest`: Allows contributors to vote on a funding request.
- `makePayment`: Allows the administrator to make a payment for a completed funding request.

## Usage

To use this smart contract, deploy it to a compatible Ethereum Virtual Machine (EVM) and interact with it using a compatible wallet or script.

## License

This smart contract is licensed under the [GNU General Public License v3.0](https://opensource.org/licenses/GPL-3.0).
