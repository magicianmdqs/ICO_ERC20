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
    <!-- Text based on connection state -->
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

// Display shortened wallet address
function short(addr) {
  if (!addr) return "";
  return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
}

async function connect() {
  if (connecting.value) return; // Prevent spam click

  try {
    connecting.value = true;

    const signer = await getSigner();
    if (!signer) throw new Error("No signer returned.");

    const addr = await signer.getAddress();
    if (!addr) throw new Error("Failed to get wallet address.");

    account.value = addr;
    connected.value = true;

  } catch (e) {
    console.error("Wallet connection failed:", e);
    alert(e.message || "Failed to connect wallet.");
  } finally {
    connecting.value = false;
  }
}
</script>
