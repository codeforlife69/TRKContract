// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TestContract is ERC20, Ownable, Pausable  {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        uint256 _decimals = 18;
        uint256 _totalSupply = 100_000_000 * 10**_decimals;
        _mint(msg.sender, _totalSupply);
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyOwner whenNotPaused {
       _pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyOwner whenPaused {
       _unpause();
    }

    /**
    * @dev See {ERC20-transfer}.
    *
    * Requirements:
    *
    * - `recipient` cannot be the zero address.
    * - the caller must have a balance of at least `amount`.
    */
    function transfer(address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

      /**
    * @dev See {ERC20-transferFrom}.
    *
    * Emits an {Approval} event indicating the updated allowance. This is not
    * required by the EIP. See the note at the beginning of {BEP20};
    *
    * Requirements:
    * - `sender` and `recipient` cannot be the zero address.
    * - `sender` must have a balance of at least `amount`.
    * - the caller must have allowance for `sender`'s tokens of at least
    * `amount`.
    */
    function transferFrom(address sender, address recipient, uint256 amount) public override whenNotPaused returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }

    /**
    * @dev See {ERC20-approve}.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
    function approve(address spender, uint256 amount) public override whenNotPaused returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
    * @dev Atomically increases the allowance granted to `spender` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {ERC20-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
    function increaseAllowance(address spender, uint256 addedValue) public override whenNotPaused returns (bool) {
        super.increaseAllowance(spender, addedValue);
        return true;
    }

    /**
    * @dev Atomically decreases the allowance granted to `spender` by the caller.
    *
    * This is an alternative to {approve} that can be used as a mitigation for
    * problems described in {ERC20-approve}.
    *
    * Emits an {Approval} event indicating the updated allowance.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    * - `spender` must have allowance for the caller of at least
    * `subtractedValue`.
    */
    function decreaseAllowance(address spender, uint256 subtractedValue) public override whenNotPaused returns (bool) {
        super.decreaseAllowance(spender, subtractedValue);
        return true;
    }

    /**
    * @dev Not allow transferring owner role to another in case of the contract is hacked.
    */
    function transferOwnership(address newOwner) public override onlyOwner {
        revert("Not allow transferring ownership");
    }

    /**
    * @dev In case of the contract is hacked, renounce ownership to address(0) to make the contract run normally (without pausable)
    */
    function renounceOwnership() public override onlyOwner {
        if (paused()) {
            _unpause();
        }

        super.renounceOwnership();
    }
}
