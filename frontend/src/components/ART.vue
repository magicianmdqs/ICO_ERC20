<template>
  <canvas ref="canvas" class="w-full h-64 rounded-2xl"></canvas>
</template>

<script setup>
import { onMounted, ref, onBeforeUnmount } from "vue";

const canvas = ref(null);
let ctx, particles = [], animationId;

const PARTICLE_COUNT = 90;
const MAX_DISTANCE = 140;

class Particle {
  constructor(w, h) {
    this.x = Math.random() * w;
    this.y = Math.random() * h;
    this.vx = (Math.random() - 0.5) * 0.6;
    this.vy = (Math.random() - 0.5) * 0.6;
    this.radius = Math.random() * 2.5 + 1;
  }

  move(w, h) {
    this.x += this.vx;
    this.y += this.vy;
    if (this.x < 0 || this.x > w) this.vx *= -1;
    if (this.y < 0 || this.y > h) this.vy *= -1;
  }
}

onMounted(() => {
  const c = canvas.value;
  ctx = c.getContext("2d");

  // ⭐ High DPI canvas scaling for sharp resolution
  function resize() {
    const ratio = window.devicePixelRatio || 1;
    c.width = c.clientWidth * ratio;
    c.height = c.clientHeight * ratio;
    ctx.scale(ratio, ratio);
  }
  resize();
  window.addEventListener("resize", resize);

  // Init particles
  for (let i = 0; i < PARTICLE_COUNT; i++) {
    particles.push(new Particle(c.clientWidth, c.clientHeight));
  }

  // Mouse tracking
  const mouse = { x: null, y: null };
  c.addEventListener("mousemove", (e) => {
    const rect = c.getBoundingClientRect();
    mouse.x = e.clientX - rect.left;
    mouse.y = e.clientY - rect.top;
  });
  c.addEventListener("mouseleave", () => {
    mouse.x = mouse.y = null;
  });

  function animate(t) {
    ctx.clearRect(0, 0, c.clientWidth, c.clientHeight);

    // Neon glow shadow settings
    ctx.shadowBlur = 12;
    ctx.shadowColor = "rgba(0,255,180,0.8)";

    // Pulsing neon effect
    const pulse = (Math.sin(t * 0.001) + 1) / 2;
    const particleColor = `hsl(${150 + pulse * 30}, 90%, 60%)`;

    particles.forEach((p) => {
      p.move(c.clientWidth, c.clientHeight);

      ctx.beginPath();
      ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
      ctx.fillStyle = particleColor;
      ctx.fill();
    });

    // Lines
    ctx.shadowBlur = 0;
    for (let i = 0; i < PARTICLE_COUNT; i++) {
      for (let j = i + 1; j < PARTICLE_COUNT; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < MAX_DISTANCE) {
          const alpha = 1 - dist / MAX_DISTANCE;
          ctx.strokeStyle = `rgba(0,255,180,${alpha * 0.7})`;
          ctx.lineWidth = 1.2;

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
          ctx.strokeStyle = `rgba(0,255,200,${alpha})`;
          ctx.lineWidth = 1.4;

          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(mouse.x, mouse.y);
          ctx.stroke();
        }
      }
    }

    animationId = requestAnimationFrame(animate);
  }

  animate();
});

onBeforeUnmount(() => {
  cancelAnimationFrame(animationId);
});
</script>

<style scoped>
canvas {
  background: radial-gradient(circle at center, #0d0d0f, #0a0a0c 80%);
}
</style>
