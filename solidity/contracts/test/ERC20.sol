// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.22;
import '@openzeppelin/contracts-5.0.1/token/ERC20/ERC20.sol';

contract ERC20Mock is ERC20 {
  constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

  function mint(address _account, uint256 _amount) external {
    _mint(_account, _amount);
  }

  function burn(address _account, uint256 _amount) external {
    _burn(_account, _amount);
  }
}
