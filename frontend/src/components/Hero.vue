<template>
  <section
    class="relative flex flex-col md:flex-row items-center justify-between p-8 md:p-12 rounded-3xl shadow-2xl
           bg-gradient-to-r from-green-500/80 via-teal-600/70 to-blue-600/80 overflow-hidden"
  >
    <!-- Floating Neon Particles -->
    <canvas ref="neonCanvas" class="absolute inset-0 w-full h-full pointer-events-none"></canvas>

    <!-- Text Content -->
    <div class="relative z-10 text-white space-y-6 md:max-w-lg">
      <h1
        class="text-4xl md:text-6xl font-fredoka drop-shadow-[0_0_20px_rgba(16,185,129,0.8)]
               animate-bounce"
      >
        Buy SHXT 💩
      </h1>
      <p class="text-lg md:text-2xl font-semibold text-gray-100/90">
        Get your tokens before they’re gone!
      </p>
      <BuyTokens
        class="mt-6"
        :price="price"
        :totalSupply="totalSupply"
        :state="state"
      />
    </div>

    <!-- Optional Mascot Image -->
    <!--
    <img
      src="@/assets/pepe.gif"
      alt="Pepe Token"
      class="w-48 md:w-64 animate-bounce shadow-2xl rounded-xl z-10"
      loading="lazy"
    />
    -->
  </section>
</template>

<script setup lang="ts">
import { defineProps, onMounted, ref } from "vue";
import BuyTokens from "./BuyTokens.vue";

const props = defineProps({
  state: { type: Boolean, required: true },
  totalSupply: { type: Number, required: true },
  price: { type: Number, required: true },
});

const neonCanvas = ref<HTMLCanvasElement | null>(null);

onMounted(() => {
  if (!neonCanvas.value) return;
  const ctx = neonCanvas.value.getContext("2d");
  if (!ctx) return;

  const particles: { x: number; y: number; vx: number; vy: number; size: number }[] = [];
  const particleCount = 60;

  const resize = () => {
    neonCanvas.value!.width = neonCanvas.value!.offsetWidth;
    neonCanvas.value!.height = neonCanvas.value!.offsetHeight;
  };
  resize();
  window.addEventListener("resize", resize);

  for (let i = 0; i < particleCount; i++) {
    particles.push({
      x: Math.random() * neonCanvas.value!.width,
      y: Math.random() * neonCanvas.value!.height,
      vx: (Math.random() - 0.5) * 0.7,
      vy: (Math.random() - 0.5) * 0.7,
      size: Math.random() * 3 + 1,
    });
  }

  const animate = () => {
    if (!ctx) return;
    ctx.clearRect(0, 0, neonCanvas.value!.width, neonCanvas.value!.height);
    for (let p of particles) {
      p.x += p.vx;
      p.y += p.vy;

      // Bounce off edges
      if (p.x < 0 || p.x > neonCanvas.value!.width) p.vx *= -1;
      if (p.y < 0 || p.y > neonCanvas.value!.height) p.vy *= -1;

      ctx.beginPath();
      ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
      ctx.fillStyle = "rgba(16,185,129,0.8)";
      ctx.shadowColor = "#10B981";
      ctx.shadowBlur = 12;
      ctx.fill();
    }
    requestAnimationFrame(animate);
  };
  animate();
});
</script>
