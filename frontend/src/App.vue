<template>
  <div class="min-h-screen bg-gradient-to-b from-gray-900 via-gray-800 to-gray-900 text-white font-comic">
    <!-- Header -->
    <Header :state="state">
      <ConnectWallet
          :account="account"
          :connected="connected"
          @connect="connectWallet"
      />
    </Header>

    <NewsTracker/>
    <section class="relative p-1 rounded-3xl shadow-xl m-4 bg-gray-900 border border-gray-700/40">
      <ART/>
    </section>

    <!-- Hero & Token Info -->
    <section class="relative p-8 md:p-12 rounded-3xl shadow-xl m-4 bg-gray-900 border border-gray-700/40">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-10 items-center">

        <!-- Left: Hero -->
        <div class="space-y-6">
          <Hero
              :price="price"
              :totalSupply="totalSupply"
              :state="state"
          />
        </div>

        <!-- Right: Token Info -->
        <div class="w-full">
          <TokenInfo
              :price="price"
              :totalSupply="totalSupply"
              :totalPhases="totalPhases"
              :decimals="decimals"
              state/>
        </div>

      </div>
    </section>

    <!-- Phases & Recent Purchases -->
    <section class="m-4 p-6 rounded-3xl bg-gray-900 border border-gray-700/40 shadow-xl">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

        <!-- Phase Progress -->
        <PhaseProgress
            class="bg-gray-800 rounded-2xl p-6 shadow-inner border border-gray-700/50"
            :price="price"
            :totalSupply="totalSupply"
            :totalPhases="totalPhases"
            :decimals="decimals"
            state
            :storedTime="storedTime"
        />

        <!-- Recent Purchases -->
        <RecentPurchases
            class="bg-gray-800 rounded-2xl p-6 shadow-inner border border-gray-700/50"
            :owner="owner"
        />

      </div>
    </section>

    <section
        class="relative p-8 md:p-12 rounded-3xl shadow-xl m-4 bg-gray-900 border border-gray-700/40 text-white"
    >
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <Shares/>
        <div class="space-y-4">
          <h2 class="text-2xl font-fredoka text-green-400 drop-shadow-md">About SHXT Token</h2>
          <p class="text-gray-300">
            SHXT is a deflationary meme token designed to bring the community together with fun and utility.
            It features pre-launch sale rewards, public sale access, and a portion reserved for marketing and
            development.
          </p>
          <ul class="list-disc list-inside text-gray-400 space-y-1">
            <li><strong>Total Supply:</strong> 2,000,000,000 SHXT</li>
            <li><strong>Pre-Launch Sale:</strong> 40% of total supply</li>
            <li><strong>Public Sale:</strong> 50% available</li>
            <li><strong>Marketing & Partnerships:</strong> 5%</li>
            <li><strong>Developer Reserve:</strong> 2.5%</li>
            <li><strong>Airdrop:</strong> 2.5%</li>
          </ul>
          <p class="text-gray-300">
            Owning SHXT gives you early access to community events, potential staking rewards, and governance rights for
            upcoming features.
          </p>
        </div>
      </div>
    </section>

  </div>
</template>

<script setup>
import {ref, onMounted} from "vue";
import {getContract, getSigner} from "./utils/web3.js";
import {formatUnits} from "ethers";

import Header from "./components/Header.vue";
import ConnectWallet from "./components/ConnectWallet.vue";
import TokenInfo from "./components/TokenInfo.vue";
import PhaseProgress from "./components/PhaseProgress.vue";
import Hero from "./components/Hero.vue";
import RecentPurchases from "./components/RecentPurchases.vue";
import Shares from "./components/Shares.vue";
import NewsTracker from "./components/NewTracker.vue";
import ART from "./components/ART.vue";

// Wallet state
const account = ref("");
const connected = ref(false);

// Contract data
const price = ref(0);
const totalSupply = ref(0);
const totalPhases = ref(0);
const storedTime = ref(0);
const state = ref(false);
const owner = ref("");
const decimals = ref(6)

// Connect wallet
async function connectWallet() {
  try {
    const signer = await getSigner();
    account.value = await signer.getAddress();
    connected.value = true;
  } catch (e) {
    alert(e.message);
  }
}

// Fetch contract data
async function fetchContractData() {
  try {
    const contract = await getContract();

    const [
      decimalsRaw,
      totalSupplyRaw,
      priceRaw,
      totalPhasesRaw,
      storedTimeRaw,
      stateRaw,
      ownerRaw,
    ] = await Promise.all([
      contract.decimals(),
      contract.totalSupply(),
      contract.Price(),
      contract.totalPhases(),
      contract.StoredTime(),
      contract.STATE(),
      contract.Owner(),
    ]);

    const d = Number(decimalsRaw);

    decimals.value = d;
    totalSupply.value = Number(formatUnits(totalSupplyRaw, d));
    price.value = Number(formatUnits(priceRaw, 18));
    totalPhases.value = Number(totalPhasesRaw);
    storedTime.value = Number(storedTimeRaw);
    state.value = stateRaw;
    owner.value = ownerRaw;
  } catch (e) {
    console.error("Failed to fetch contract data:", e);
  }
}


// Load contract data on mount
onMounted(fetchContractData);
</script>

