<template>
  <section
    class="relative flex flex-col md:flex-row items-center justify-between p-8 md:p-12 rounded-3xl shadow-2xl
           bg-gradient-to-r from-green-900/80 via-teal-500/70 to-green-900/80 overflow-hidden"
  >
    <!-- Floating Neon Particles -->
    <canvas ref="neonCanvas" class="absolute inset-0 w-full h-full"></canvas>

    <!-- Text Content -->
    <div class="relative z-10 text-white space-y-6 md:max-w-lg">
      <h1
        class="text-4xl md:text-6xl font-fredoka drop-shadow-[0_0_20px_rgba(16,185,129,0.8)]
               animate-bounce"
      >
        Buy SHXT 💩
      </h1>
      <p class="text-lg md:text-2xl font-semibold text-gray-100/90">
        {{ infoText }}
      </p>
      <BuyTokens
        class="mt-6"
        :price="price"
        :totalSupply="totalSupply"
        :state="state"
      />
    </div>
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

// reactive text
const infoText = ref("Click On Dusts!");

interface Particle {
  x: number;
  y: number;
  vx: number;
  vy: number;
  size: number;
  alive: boolean;
}

interface Fragment {
  x: number;
  y: number;
  vx: number;
  vy: number;
  alpha: number;
  size: number;
}

onMounted(() => {
  if (!neonCanvas.value) return;
  const ctx = neonCanvas.value.getContext("2d");
  if (!ctx) return;

  const particles: Particle[] = [];
  const fragments: Fragment[] = [];
  const particleCount = 30;

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
      alive: true,
    });
  }

  const animate = () => {
    if (!ctx) return;
    ctx.clearRect(0, 0, neonCanvas.value!.width, neonCanvas.value!.height);

    // Draw particles
    for (let p of particles) {
      if (!p.alive) continue;

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

    // Draw fragments
    for (let i = fragments.length - 1; i >= 0; i--) {
      const f = fragments[i];
      f.x += f.vx;
      f.y += f.vy;
      f.alpha -= 0.03;
      f.vy += 0.05; // gravity

      if (f.alpha <= 0) {
        fragments.splice(i, 1);
        continue;
      }

      ctx.beginPath();
      ctx.arc(f.x, f.y, f.size, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(16, 255, 129, ${f.alpha})`;
      ctx.shadowColor = "rgba(16,255,130,0.8)";
      ctx.shadowBlur = 8;
      ctx.fill();
    }

    requestAnimationFrame(animate);
  };
  animate();

  // Handle click for particle explosion
  neonCanvas.value.addEventListener("click", (e) => {
    const rect = neonCanvas.value!.getBoundingClientRect();
    const mouseX = e.clientX - rect.left;
    const mouseY = e.clientY - rect.top;

    let clicked = false;

    for (let p of particles) {
      const dx = p.x - mouseX;
      const dy = p.y - mouseY;
      const dist = Math.sqrt(dx * dx + dy * dy);

      if (dist < 15 && p.alive) {
        clicked = true;
        p.alive = false;

        // Create fragments
        const fragmentCount = 8 + Math.floor(Math.random() * 5);
        for (let i = 0; i < fragmentCount; i++) {
          fragments.push({
            x: p.x,
            y: p.y,
            vx: (Math.random() - 0.5) * 4,
            vy: (Math.random() - 0.9) * 4,
            alpha: 1,
            size: Math.random() * 2 + 1,
          });
        }
      }
    }

    // If any particle was clicked, update the text
    if (clicked) {
      infoText.value = "🎉 Grab your tokens now!";
    }
  });
});
</script>
