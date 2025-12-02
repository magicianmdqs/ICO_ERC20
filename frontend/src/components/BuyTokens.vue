<template>
  <div class="p-6 bg-gray-900 rounded-3xl shadow-xl flex flex-col items-center space-y-4">

    <!-- Amount Input -->
    <div class="w-full">
      <input
        v-model="ethAmount"
        type="number"
        min="0.001"
        step="0.001"
        placeholder="Enter ETH amount"
        class="w-full p-3 rounded-xl border-2 border-green-400 bg-gray-700 text-white
               focus:ring-2 focus:ring-green-400 focus:border-green-300 transition-all"
      />
      <p class="text-xs text-gray-400 mt-1">You get: {{tokenAmount}}</p>
      <p class="text-xs text-gray-400 mt-1">Minimum: 0.001 ETH</p>
    </div>

    <!-- Buy Button -->
    <button
      @click="buy"
      :disabled="loading || !state"
      class="px-6 py-2 bg-gradient-to-r from-green-400 to-blue-500 text-white font-bold
             rounded-2xl transform transition-all duration-200
             hover:scale-105 active:scale-95 disabled:opacity-40 disabled:cursor-not-allowed"
    >
      <span v-if="!loading">Buy Tokens</span>
      <span v-else class="flex items-center space-x-2">
        <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none"
             viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                  stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8v4l3-3-3-3v4a12 12 0 00-12 12h4z"/>
        </svg>
        <span>Processing...</span>
      </span>
    </button>

  </div>
</template>

<script setup>
import { defineProps, ref, computed } from "vue";
import { buyTokenDirect } from "../utils/web3.js";
import confetti from "canvas-confetti";

const props = defineProps({
  state: { type: Boolean, required: true },
  totalSupply: { type: Number, required: true },
  price: { type: Number, required: true },
});

const ethAmount = ref("0.01");
const loading = ref(false);

// reactive output for "You get:"
const tokenAmount = computed(() => {
  if (!props.price || !ethAmount.value) return 0;
  return (Number(ethAmount.value) / props.price).toFixed(3);
});

async function buy() {
  const amount = Number(ethAmount.value);

  if (!amount || amount < 0.001) {
    notify("Enter a valid ETH amount (min 0.001).");
    return;
  }

  try {
    loading.value = true;

    await buyTokenDirect(amount.toFixed(3));

    confetti({
      particleCount: 180,
      spread: 90,
      origin: { y: 0.6 },
    });

    notify("Purchase successful! 🎉");
  } catch (e) {
    const reason =
      e?.reason ||
      e?.data?.message ||
      e?.error?.message ||
      e?.message ||
      "Transaction failed.";

    notify(reason.replace("execution reverted: ", ""));
    console.error("TX Error:", e);
  } finally {
    loading.value = false;
  }
}

function notify(msg) {
  alert(msg);
}
</script>

