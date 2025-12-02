<template>
  <div class="p-6 bg-gray-900 rounded-3xl shadow-xl space-y-4 text-white">
    <h2 class="text-2xl font-fredoka text-green-400 drop-shadow-md">Token Info</h2>

    <div class="flex flex-col space-y-2">
      <div class="flex justify-between">
        <span class="font-semibold">Total Supply:</span>
        <span>{{ formattedTotalSupply }} Tokens</span>
      </div>

      <div class="flex justify-between">
        <span class="font-semibold">Current Price:</span>
        <span>{{ formattedCurrentPrice }} ETH</span>
      </div>

      <div class="flex justify-between">
        <span class="font-semibold">Unlocked Amount:</span>
        <span>{{ formattedUnlockedAmount }} Tokens</span>
      </div>
      <div class="flex justify-between">
        <span class="font-semibold">Contract Address:</span>
        <a :href="Contract_Link" target="_blank" v-on:click=""
           class="text-green-400 hover:text-green-300 font-bold transition-colors"
        >{{ CONTRACT_ADDRESS }}</a>
      </div>
    </div>
  </div>
</template>

<script setup>
import {computed} from "vue";
import {CONTRACT_ADDRESS} from "../utils/web3.js";

const Contract_Link = `https://hoodi.etherscan.io/address/${CONTRACT_ADDRESS}`;

const props = defineProps({
  state: Boolean,
  totalSupply: Number,
  price: Number,
  decimals: Number,
  totalPhases: Number
});

// unlockedAmount auto-updates with props
const unlockedAmount = computed(() => {
  if (props.totalPhases == 0) {
    return props.totalSupply
  }
  return props.totalSupply * 4 / 10 * Math.abs(props.totalPhases - 9) / 10;
});

// formatted display
const formattedTotalSupply = computed(() => props.totalSupply.toLocaleString());
const formattedCurrentPrice = computed(() => props.price.toFixed(6));
const formattedUnlockedAmount = computed(() =>
    unlockedAmount.value.toLocaleString()
);
</script>

