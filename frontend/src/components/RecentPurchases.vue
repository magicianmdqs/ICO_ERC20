<template>
  <div class="p-4 bg-gray-900 rounded-3xl shadow-xl space-y-3 max-h-64 overflow-y-auto">
    <h3 class="text-lg font-bold text-green-400 mb-2">
      Recent Purchases
    </h3>

    <!-- Empty state -->
    <div v-if="purchases.length === 0" class="text-gray-400 text-sm text-center py-4">
      No purchases yet.
    </div>

    <!-- Purchases list -->
    <div
      v-for="(p, index) in purchases"
      :key="index"
      class="flex items-center justify-between bg-gray-800 rounded-xl px-3 py-2
             hover:bg-gray-700 transition-colors"
    >
      <div class="flex items-center space-x-3">
        <!-- Avatar -->
        <div class="w-8 h-8 rounded-full bg-green-500 flex items-center justify-center
                    font-bold text-white text-sm">
          {{ p.user.slice(2, 4).toUpperCase() }}
        </div>

        <!-- Address -->
        <span class="text-white font-mono truncate w-28">
          {{ shorten(p.user) }}
        </span>
      </div>

      <!-- Amount -->
      <span class="font-bold text-yellow-400">
        {{ p.amount.toLocaleString() }} Tokens
      </span>
    </div>
  </div>
</template>

<script setup>
import { ref, watchEffect } from "vue";
import { BrowserProvider, Contract } from "ethers";
import { CONTRACT_ADDRESS, ABI } from "../utils/web3.js";

const purchases = ref([]);

const props = defineProps({
  owner: { type: String, required: true },   // NOW reactive
});

/**
 * Utility to shorten ETH address
 */
const shorten = (addr) =>
  addr ? `${addr.slice(0, 6)}...${addr.slice(-4)}` : "";

/**
 * REACTIVE fetch: auto-runs when owner changes.
 * No more "empty for 2 seconds then suddenly loads".
 */
watchEffect(async () => {
  if (!props.owner || props.owner.length < 20) return; // wait until owner loaded

  try {
    if (!window.ethereum) return;

    const provider = new BrowserProvider(window.ethereum);
    await provider.send("eth_requestAccounts", []);

    const contract = new Contract(CONTRACT_ADDRESS, ABI, provider);

    // Transfer(owner → anyone)
    const filter = contract.filters.Transfer(props.owner, null);

    const currentBlock = await provider.getBlockNumber();
    const fromBlock = Math.max(currentBlock - 20000, 0);

    const events = await contract.queryFilter(filter, fromBlock, currentBlock);

    purchases.value = events
      .slice(-5)
      .reverse()
      .map((e) => ({
        user: e.args.to || e.args._to,
        amount:
          Number(e.args.value || e.args._value) /
          10 ** 6, // your decimals
      }));
  } catch (err) {
    console.error("Failed to fetch purchases:", err);
  }
});
</script>

