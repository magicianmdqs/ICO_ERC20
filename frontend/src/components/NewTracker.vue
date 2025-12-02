<template>
  <div class="w-full bg-gray-800/70 backdrop-blur-sm overflow-hidden rounded-b-3xl shadow-md relative">
    <!-- sliding container -->
    <div
      ref="ticker"
      class="flex whitespace-nowrap py-2 px-4 animate-slide"
      @mouseover="pause"
      @mouseleave="play"
    >
      <span
        v-for="(item, index) in news"
        :key="index"
        class="mx-4 px-2 py-1 bg-gray-700/50 rounded-lg hover:bg-green-500/70 transition-all duration-300 cursor-pointer"
      >
        {{ item }}
      </span>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";

// Example news/project details
const news = ref([
  "🔥 Pre-Launch Sale Live!",
  "💰 Funding",
  "🚀 Project Pre-Sale",
  "📢 Marketing Campaign Started",
  "👨‍💻 AirDrop will be among early apes.",
]);

const ticker = ref(null);
let tickerAnimation;

onMounted(() => {
  // Using CSS animation with infinite scroll
  const width = ticker.value.scrollWidth;
  ticker.value.style.setProperty("--scroll-width", `${width}px`);
});

function pause() {
  ticker.value.style.animationPlayState = "paused";
}

function play() {
  ticker.value.style.animationPlayState = "running";
}
</script>

<style>
@keyframes slide {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(calc(-1 * var(--scroll-width)));
  }
}

.animate-slide {
  display: inline-flex;
  animation: slide 20s linear infinite;
}
</style>
