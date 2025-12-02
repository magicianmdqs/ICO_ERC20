<template>
  <footer class="relative w-full h-48 bg-gradient-to-t from-gray-900/90 to-transparent overflow-hidden">
    <!-- Particle background -->
    <canvas ref="footerCanvas" class="absolute inset-0 w-full h-full"></canvas>

    <!-- Text overlay -->
    <div class="relative z-10 flex flex-col items-center justify-center h-full text-center select-none">
      <p class="text-gray-300 text-lg md:text-xl font-semibold relative inline-block">
        Created without
        <span
          class="text-green-400 font-bold neon-text relative cursor-default"
          @mouseenter="hover = true"
          @mouseleave="hover = false"
        >
          Love by Magician
          <span
            v-for="n in sparkles"
            :key="n.id"
            class="absolute w-1 h-1 rounded-full bg-green-400 pointer-events-none"
            :style="{
              left: n.x + '%',
              top: n.y + '%',
              opacity: n.opacity,
              transform: 'scale(' + n.scale + ')',
            }"
          ></span>
        </span>
      </p>
    </div>
  </footer>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";

const footerCanvas = ref(null);
const hover = ref(false);
const sparkles = ref([]);

const PARTICLE_COUNT = 40; // fewer than main canvas for subtlety
const MAX_DISTANCE = 120;
let particles = [];
let animationId;

// Particle class
class Particle {
  constructor(w, h) {
    this.x = Math.random() * w;
    this.y = Math.random() * h;
    this.vx = (Math.random() - 0.5) * 0.4;
    this.vy = (Math.random() - 0.5) * 0.4;
    this.radius = Math.random() * 2 + 1;
  }
  move(w, h) {
    this.x += this.vx;
    this.y += this.vy;
    if (this.x < 0 || this.x > w) this.vx *= -1;
    if (this.y < 0 || this.y > h) this.vy *= -1;
  }
}

// Sparkles setup
const createSparkles = () => {
  sparkles.value = [];
  for (let i = 0; i < 6; i++) {
    sparkles.value.push({
      id: i,
      x: Math.random() * 100,
      y: Math.random() * 100,
      scale: Math.random() * 1.2 + 0.5,
      opacity: Math.random(),
    });
  }
};

onMounted(() => {
  const c = footerCanvas.value;
  if (!c) return;
  const ctx = c.getContext("2d");
  if (!ctx) return;

  const resize = () => {
    const ratio = window.devicePixelRatio || 1;
    c.width = c.clientWidth * ratio;
    c.height = c.clientHeight * ratio;
    ctx.scale(ratio, ratio);
  };
  resize();
  window.addEventListener("resize", resize);

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    particles.push(new Particle(c.clientWidth, c.clientHeight));
  }

  const mouse = { x: null, y: null };
  c.addEventListener("mousemove", (e) => {
    const rect = c.getBoundingClientRect();
    mouse.x = e.clientX - rect.left;
    mouse.y = e.clientY - rect.top;
  });
  c.addEventListener("mouseleave", () => {
    mouse.x = mouse.y = null;
  });

  const animate = (t) => {
    ctx.clearRect(0, 0, c.clientWidth, c.clientHeight);

    // Draw particles
    ctx.shadowBlur = 6;
    ctx.shadowColor = "rgba(16,255,130,0.6)";
    const pulse = (Math.sin(t * 0.002) + 1) / 2;
    const particleColor = `hsl(${140 + pulse * 40}, 80%, 55%)`;

    particles.forEach((p) => {
      p.move(c.clientWidth, c.clientHeight);

      ctx.beginPath();
      ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
      ctx.fillStyle = particleColor;
      ctx.fill();
    });

    // Lines between close particles
    ctx.shadowBlur = 0;
    for (let i = 0; i < PARTICLE_COUNT; i++) {
      for (let j = i + 1; j < PARTICLE_COUNT; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < MAX_DISTANCE) {
          const alpha = 1 - dist / MAX_DISTANCE;
          ctx.strokeStyle = `rgba(16,255,130,${alpha * 0.6})`;
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.stroke();
        }
      }

      // Connect to mouse
      if (mouse.x !== null) {
        const dx = particles[i].x - mouse.x;
        const dy = particles[i].y - mouse.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < MAX_DISTANCE) {
          const alpha = 1 - dist / MAX_DISTANCE;
          ctx.strokeStyle = `rgba(16,255,140,${alpha})`;
          ctx.lineWidth = 1.2;
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(mouse.x, mouse.y);
          ctx.stroke();
        }
      }
    }

    // Update sparkles
    sparkles.value.forEach((s) => {
      s.opacity -= 0.02;
      if (s.opacity < 0) s.opacity = 0;
    });

    animationId = requestAnimationFrame(animate);
  };

  animate(0);

  setInterval(() => {
    if (hover.value) createSparkles();
  }, 120);
});

onBeforeUnmount(() => {
  cancelAnimationFrame(animationId);
});
</script>

<style scoped>
.neon-text {
  transition: text-shadow 0.3s ease;
}
.neon-text:hover {
  text-shadow: 0 0 4px #10b981, 0 0 10px #10b981, 0 0 20px #10b981;
}
</style>
