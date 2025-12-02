source .env
forge build
echo 'Pending...'
address=$(forge create ./src/ERC20.sol:ERC20 --private-key=$PriTestDeply --rpc-url=$ETH_HOODI2 --etherscan-api-key=$etherscan_API --broadcast --constructor-args shxt SHXT 1000000000000 0.0001ether --json|jq '.deployedTo')
echo 'Deployed to' $address
cast send $address "divertState()(bool)" --rpc-url=$ETH_HOODI2 --private-key=$PriTestDeply
state=$(cast call $address "STATE()" --rpc-url=$ETH_HOODI2)
echo 'Contract State: ' $state