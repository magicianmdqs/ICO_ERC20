<template>
  <header class="relative bg-gradient-to-b from-gray-900/80 to-gray-800/80 backdrop-blur-xl rounded-b-3xl shadow-[0_0_30px_rgba(0,255,120,0.2)] px-6 py-6 flex justify-between items-center">

    <!-- iPhone-style central notch -->
    <div class="notch absolute top-3 left-1/2 -translate-x-1/2 flex items-center justify-center space-x-2 px-4">

      <!-- Dot wrapper -->
      <div class="relative w-5 h-5 flex-shrink-0">
        <!-- Pulsing background -->
        <span class="absolute inset-0 rounded-full"
          :class="state ? 'bg-green-500 animate-ping-neon' : 'bg-red-500 animate-pulse'">
        </span>
        <!-- Main dot -->
        <span class="absolute inset-0 rounded-full"
          :class="state ? 'bg-green-600' : 'bg-red-600'">
        </span>
      </div>

      <!-- Live/Offline text -->
      <span class="text-lg font-semibold drop-shadow-[0_0_6px_rgba(0,0,0,0.5)]"
        :class="state ? 'text-green-400' : 'text-red-400'">
        {{ state ? 'LIVE' : 'OFFLINE' }}
      </span>
    </div>

    <!-- Title -->
    <h1 class="text-2xl font-bold text-green-400 drop-shadow-[0_0_12px_rgba(16,185,129,0.8)] z-10">
      SHXT Token
    </h1>

    <!-- Right side slot -->
    <div class="flex items-center space-x-2 z-10">
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
/* Neon ping animation */
@keyframes ping-neon {
  0% { transform: scale(1); opacity: 0.8; box-shadow: 0 0 6px #10B981, 0 0 12px #10B98155; }
  50% { transform: scale(1.8); opacity: 0.4; box-shadow: 0 0 12px #10B981, 0 0 24px #10B98166; }
  100% { transform: scale(2.2); opacity: 0; box-shadow: 0 0 24px #10B98133, 0 0 36px #10B98122; }
}
.animate-ping-neon { animation: ping-neon 2.5s infinite; }

/* iPhone-style large notch */
.notch {
  background-color: #0a0a0a;
  width: 20%;       /* notch wide enough for text + dot */
  height: 48px;       /* enough for dot + text */
  border-radius: 24px 24px 16px 16px; /* smooth rounded corners */
  box-shadow: 0 0 8px rgba(0,0,0,0.5);
  z-index: 20;
  padding-left: 10px;
  padding-right: 10px;
}
</style>
