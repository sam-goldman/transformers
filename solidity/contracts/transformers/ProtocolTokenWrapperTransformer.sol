// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.8.7 <0.9.0;

import '@openzeppelin/contracts/interfaces/IERC20.sol';
import '../../interfaces/ITransformer.sol';

/// @title An implementaton of `ITransformer` for protocol token wrappers (WETH/WBNB/WMATIC)
contract ProtocolTokenWrapperTransformer is ITransformer {
  /**
   * @notice Returns the address that will represent the protocol's token
   * @return The address that will represent the protocol's token
   */
  address public constant PROTOCOL_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  /// @inheritdoc ITransformer
  function getUnderlying(address) external pure returns (address[] memory) {
    return _toUnderlying(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
  }

  /// @inheritdoc ITransformer
  function calculateTransformToUnderlying(address, uint256 _amountDependent) external pure returns (UnderlyingAmount[] memory) {
    return _toUnderylingAmount(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, _amountDependent);
  }

  /// @inheritdoc ITransformer
  function calculateTransformToDependent(address, UnderlyingAmount[] calldata _underlying) external pure returns (uint256 _amountDependent) {
    _amountDependent = _underlying[0].amount;
  }

  /// @inheritdoc ITransformer
  function transformToUnderlying(
    address _dependent,
    uint256 _amountDependent,
    address payable _recipient
  ) external returns (UnderlyingAmount[] memory) {
    IWETH9(_dependent).withdraw(_amountDependent);
    _recipient.transfer(_amountDependent);
    return _toUnderylingAmount(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, _amountDependent);
  }

  /// @inheritdoc ITransformer
  function transformToDependent(
    address _dependent,
    UnderlyingAmount[] calldata _underlying,
    address _recipient
  ) external payable returns (uint256 _amountDependent) {
    _amountDependent = _underlying[0].amount;
    IWETH9(_dependent).deposit{value: _amountDependent}();
    IWETH9(_dependent).transfer(_recipient, _amountDependent);
  }

  function _toUnderlying(address _underlying) internal pure returns (address[] memory _underlyingArray) {
    _underlyingArray = new address[](1);
    _underlyingArray[0] = _underlying;
  }

  function _toUnderylingAmount(address _underlying, uint256 _amount) internal pure returns (UnderlyingAmount[] memory _amounts) {
    _amounts = new UnderlyingAmount[](1);
    _amounts[0] = UnderlyingAmount({underlying: _underlying, amount: _amount});
  }
}

/// @title Interface for WETH9
interface IWETH9 is IERC20 {
  /// @notice Deposit ether to get wrapped ether
  function deposit() external payable;

  /// @notice Withdraw wrapped ether to get ether
  function withdraw(uint256) external;
}