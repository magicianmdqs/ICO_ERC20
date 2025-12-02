import {BrowserProvider, Contract, parseEther} from "ethers";
// abi is in ./ERC20.json
export const CONTRACT_ADDRESS = "0x937F49a1C5BEA53c21fd76ECfE7f645B38CA9cfD";
export const ABI = [
    // ERC20 basics
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function decimals() pure returns (uint8)",
    "function totalSupply() view returns (uint256)",
    "function balanceOf(address) view returns (uint256)",
    "function transfer(address to, uint256 value) returns (bool)",
    "function transferFrom(address from, address to, uint256 value) returns (bool)",
    "function approve(address spender, uint256 value) returns (bool)",
    "function allowance(address owner, address spender) view returns (uint256)",

    // Contract-specific
    "function Price() view returns (uint256)",
    "function StoredTime() view returns (uint256)",
    "function STATE() view returns (bool)",
    "function Owner() view returns (address)",
    "function totalPhases() view returns (uint256)",
    "function divertState()",
    "function Doubling()",
    "function burn(uint256 amount)",

    // Events
    "event Transfer(address indexed _from, address indexed _to, uint256 _value)",
    "event Approval(address indexed _owner, address indexed _spender, uint256 _value)"
];

export async function getProvider() {
    if (!window.ethereum) throw new Error("MetaMask not installed");
    return new BrowserProvider(window.ethereum);
}

export async function getSigner() {
    const provider = await getProvider();
    await provider.send("eth_requestAccounts", []);
    return provider.getSigner();
}

export async function getContract(signer = null) {
    if (!signer) signer = await getSigner();
    return new Contract(CONTRACT_ADDRESS, ABI, signer);
}

export async function buyTokenDirect(ethAmount) {
    const provider = await getProvider();
    const tx = await (await provider.getSigner()).sendTransaction({
        to: CONTRACT_ADDRESS,
        value: parseEther(ethAmount.toString()),
    });
    return tx.wait();
}
