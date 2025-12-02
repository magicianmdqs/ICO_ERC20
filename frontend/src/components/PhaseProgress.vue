<template>
  <div
      class="p-6 rounded-3xl bg-[#0d0d0f]/80 backdrop-blur-xl border border-white/5 shadow-[0_0_40px_rgba(0,255,120,0.08)]">
    <!-- header -->
    <div class="flex items-center justify-between mb-4">
      <div class="text-sm text-gray-300 font-semibold">Phases</div>
      <div class="text-xs text-gray-400">Active: <span class="font-medium text-white">#{{ currentPhase }}</span></div>
    </div>

    <!-- PHASE DOTS (wrap-safe) -->
    <div class="flex flex-wrap gap-4 mb-6">
      <div
          v-for="phase in phases"
          :key="phase.index"
          class="relative group"
      >
        <div
            class="w-12 h-12 rounded-full grid place-items-center text-white font-bold text-lg cursor-pointer transition-all duration-160 border"
            :class="{
            'bg-[#00ff88]/30 border-[#00ff88] shadow-[0_0_18px_#00ff8844] scale-110': phase.index + 1 === currentPhase,
            'bg-[#1a1a1d] border-[#333]': phase.index + 1 < currentPhase,
            'bg-[#0f0f12] border-[#252529] hover:border-[#444]': phase.index + 1 > currentPhase
          }"
        >
          {{ phase.index + 1 }}
        </div>

        <!-- instant custom tooltip -->
        <div
            v-if="phase.startTime"
            class="absolute -top-12 left-1/2 -translate-x-1/2 px-3 py-1 text-xs text-[#00ffcc] bg-[#050505]/92 border border-[#00ffcc33]
                 rounded-md pointer-events-none opacity-0 group-hover:opacity-100 transition-opacity duration-75 shadow-[0_0_10px_#00ffcc55] whitespace-nowrap"
        >
          {{ formatDate(phase.startTime) }}
        </div>
      </div>
    </div>

    <!-- DETAILS -->
    <ul class="space-y-2 text-gray-300 text-sm">
      <li v-for="phase in phases" :key="phase.index"
          class="flex flex-col md:flex-row md:items-center md:justify-between gap-1">
        <div>
          <span :class="phase.index + 1 === currentPhase ? 'text-[#00ff88] font-semibold' : 'text-gray-400'">
            Phase {{ phase.index + 1 }}
          </span>
          <span class="text-gray-500"> — Unlock: </span>
          <span class="text-white font-medium"> {{ (unlockedAmount).toLocaleString() }} </span>
        </div>
        <div class="text-gray-500 text-xs">
          {{ formatDate(phase.startTime) }}
        </div>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, watchEffect } from "vue";
import { getContract } from "../utils/web3.js";

const INITIAL_PHASES = 10;
const WEEK = 604_800n; // BigInt week

const phases = ref([]);
const currentPhase = ref(1);
const unlockedAmount = ref(0);

// safer date formatter
function formatDate(unixBigInt) {
  if (!unixBigInt || unixBigInt <= 0) return "TBD";

  const ts = Number(unixBigInt);
  if (!Number.isFinite(ts) || ts < 1_000_000_000) return "TBD";

  const d = new Date(ts * 1000);

  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");

  return `${year}-${month}-${day}`;
}

const props = defineProps({
  state: Boolean,
  totalSupply: Number,
  price: Number,
  decimals: Number,
  totalPhases: Number,
  storedTime: Number
});

/**
 * Reactive logic — recomputes when props update
 */
watchEffect(() => {
  // avoid running with empty props
  if (
    !props.totalSupply ||
    !props.totalPhases ||
    !props.storedTime
  ) {
    return;
  }

  // unlocked amount per phase (10%)
  unlockedAmount.value = Number(props.totalSupply*4/10) / 10;

  // compute current phase
  const remaining = Number(props.totalPhases);
  const phasesCompleted = Math.max(0, INITIAL_PHASES - remaining);
  currentPhase.value = Math.min(
    Math.max(1, phasesCompleted + 1),
    INITIAL_PHASES
  );

  const storedTime = BigInt(props.storedTime);

  // sanity guard: storedTime cannot be less than a week
  if (storedTime <= 0n) return;

  const currentPhaseStart = storedTime - WEEK;

  // build all phases safely
  phases.value = Array.from({ length: INITIAL_PHASES }, (_, i) => {
    const offset = BigInt(i - (currentPhase.value - 1));
    const start = currentPhaseStart + offset * WEEK;

    return {
      index: i,
      startTime: start > 0n ? start : 0n
    };
  });
});
</script>

