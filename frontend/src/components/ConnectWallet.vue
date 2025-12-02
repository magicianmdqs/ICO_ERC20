<template>
  <button
    @click="connect"
    :disabled="connected"
    :class="[
      'px-5 py-2 rounded-2xl font-bold text-white transition-transform transform',
      connected
        ? 'bg-green-500 hover:scale-105'
        : 'bg-gradient-to-r from-purple-600 to-indigo-600 hover:scale-105',
      connecting ? 'opacity-60 cursor-not-allowed' : ''
    ]"
  >
    <span v-if="connecting">Connecting...</span>
    <span v-else-if="connected">{{ short(account) }}</span>
    <span v-else>Connect Wallet</span>
  </button>
</template>

<script setup>
import { ref } from "vue";
import { getSigner } from "../utils/web3.js";

const connected = ref(false);
const account = ref("");
const connecting = ref(false);

function short(addr) {
  if (!addr) return "";
  return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
}

async function connect() {
  if (connecting.value) return;

  try {
    connecting.value = true;

    const signer = await getSigner();
    const addr = await signer.getAddress();

    account.value = addr;
    connected.value = true;

    // 🔥 Reload to refresh app state after wallet connects
    window.location.reload();

  } catch (e) {
    console.error("Wallet connection failed:", e);
    alert(e.message || "Failed to connect wallet.");
  } finally {
    connecting.value = false;
  }
}


// 🔥 Auto-detect wallet on page load (after reload)
if (window.ethereum) {
  window.ethereum.request({ method: "eth_accounts" }).then(accounts => {
    if (accounts.length > 0) {
      account.value = accounts[0];
      connected.value = true;
    }
  });
}
</script>
