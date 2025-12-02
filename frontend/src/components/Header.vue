<template>
  <header
    class="flex justify-between items-center px-6 py-4 bg-gradient-to-b from-gray-900/80 to-gray-800/80 backdrop-blur-xl rounded-b-3xl shadow-[0_0_30px_rgba(0,255,120,0.2)]"
  >
    <!-- Title -->
    <h1 class="text-3xl font-bold text-green-400 drop-shadow-[0_0_12px_rgba(16,185,129,0.8)]">
      SHXT Token Sale
    </h1>

    <!-- Status Indicator -->
    <div class="flex items-center space-x-3">
      <div class="relative w-4 h-4">
        <span
          class="absolute inset-0 rounded-full"
          :class="state ? 'bg-green-500 animate-ping-neon' : 'bg-red-500 animate-pulse'"
        ></span>
        <span
          class="absolute inset-0 rounded-full"
          :class="state ? 'bg-green-600' : 'bg-red-600'"
        ></span>
      </div>
      <span
        class="text-lg font-semibold"
        :class="state ? 'text-green-400' : 'text-red-400'"
      >
        {{ state ? "LIVE" : "OFFLINE" }}
      </span>
    </div>

    <!-- Right side controls -->
    <div class="flex items-center space-x-2">
      <slot></slot>
    </div>
  </header>
</template>

<script setup>
defineProps({
  state: { type: Boolean, required: true }
});
</script>

<style>
@keyframes ping-neon {
  0% {
    transform: scale(1);
    opacity: 0.8;
    box-shadow: 0 0 6px #10B981, 0 0 12px #10B98155;
  }
  50% {
    transform: scale(1.8);
    opacity: 0.4;
    box-shadow: 0 0 12px #10B981, 0 0 24px #10B98166;
  }
  100% {
    transform: scale(2.2);
    opacity: 0;
    box-shadow: 0 0 24px #10B98133, 0 0 36px #10B98122;
  }
}
.animate-ping-neon {
  animation: ping-neon 2.5s infinite;
}
</style>
