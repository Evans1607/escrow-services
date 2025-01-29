# escrow-services: A Clarity Smart Contract for Secure Escrow

This Clarity smart contract implements a secure and trustless escrow system. It allows two parties to engage in a transaction where funds are held by the contract until predefined conditions are met.

## Features

* **Secure Escrow:** Funds are held in the contract until released by the payer or refunded due to cancellation.
* **Trustless Execution:** The contract logic ensures fair execution without reliance on a third party.
* **Clarity Implementation:** Leveraging the security and predictability of the Clarity smart contract language.

## How it Works

1. **Initialization (`initialize`)**: The payer initializes the contract with the payee's principal and the amount to be escrowed.  The payer is automatically set to the transaction sender.
2. **Deposit (`deposit`)**: The payer deposits the specified amount of STX into the contract. The contract becomes locked, preventing further deposits.
3. **Release (`release`)**: Once the agreed-upon conditions are met, the payer can release the funds to the payee.
4. **Cancellation (`cancel`)**: If the transaction needs to be cancelled, the payer can retrieve the locked funds.

## Public Functions

* **`initialize(new-payee: principal, new-amount: uint)`**: Initializes the escrow contract. Returns `true` on success, or an error code:
    * `u100`: Escrow already initialized.
    * `u110`: Amount must be greater than zero.
    * `u111`: Invalid payee address (cannot be the contract itself).

* **`deposit()`**: Deposits the escrow amount into the contract. Returns `true` on success, or an error code:
    * `u101`: Only payer can deposit.
    * `u102`: Escrow already funded.
    * `u103`: Transfer failed.

* **`release()`**: Releases the escrowed funds to the payee. Returns `true` on success, or an error code:
    * `u104`: Only payer can release funds.
    * `u105`: Escrow not funded.
    * `u106`: Transfer failed.

* **`cancel()`**: Cancels the escrow and refunds the payer. Returns `true` on success, or an error code:
    * `u107`: Only payer can cancel.
    * `u108`: Escrow not funded.
    * `u109`: Refund failed.

## Error Codes

* `u100` - `u109`: As described above.
* `u110`: Amount must be greater than zero.
* `u111`: Invalid payee address.


## Getting Started

1. **Prerequisites:** Ensure you have the Clarity development environment set up.
2. **Clone the Repository:** `git clone https://github.com/your-username/your-repo-name`
3. **Deploy:** Deploy the `Xcrows.clar` contract to your preferred Stacks node.
4. **Interact:** Use the contract's public functions to interact with the escrow system.

## Development

Contributions are welcome! Please open an issue or submit a pull request.
