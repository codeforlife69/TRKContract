// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TRKTestToken is ERC20, Ownable, Pausable  {
    bool private _disableTransferOwner;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        _disableTransferOwner = true;
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
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
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
        if (_disableTransferOwner) {
            revert("Not allow transferring ownership");
        } else {
            super.transferOwnership(newOwner);
        }
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
