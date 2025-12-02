<template>
  <canvas ref="canvas" class="w-full h-64 rounded-2xl"></canvas>
</template>

<script setup>
import { onMounted, ref, onBeforeUnmount } from "vue";

const canvas = ref(null);
let ctx, particles = [], animationId;

const PARTICLE_COUNT = 80;
const MAX_DISTANCE = 120;

class Particle {
  constructor(w, h) {
    this.x = Math.random() * w;
    this.y = Math.random() * h;
    this.vx = (Math.random() - 0.5) * 0.8;
    this.vy = (Math.random() - 0.5) * 0.8;
    this.radius = Math.random() * 3 + 1;
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

  // Resize canvas
  function resize() {
    c.width = c.clientWidth;
    c.height = c.clientHeight;
  }
  resize();
  window.addEventListener("resize", resize);

  // Init particles
  for (let i = 0; i < PARTICLE_COUNT; i++) {
    particles.push(new Particle(c.width, c.height));
  }

  // Mouse tracking
  const mouse = { x: null, y: null };
  c.addEventListener("mousemove", (e) => {
    const rect = c.getBoundingClientRect();
    mouse.x = e.clientX - rect.left;
    mouse.y = e.clientY - rect.top;
  });
  c.addEventListener("mouseleave", () => {
    mouse.x = null;
    mouse.y = null;
  });

  function animate() {
    ctx.clearRect(0, 0, c.width, c.height);

    // Move & draw particles
    particles.forEach((p) => {
      p.move(c.width, c.height);
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
      ctx.fillStyle = "#10B981"; // green color
      ctx.fill();
    });

    // Draw lines between close particles
    for (let i = 0; i < PARTICLE_COUNT; i++) {
      for (let j = i + 1; j < PARTICLE_COUNT; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < MAX_DISTANCE) {
          ctx.strokeStyle = `rgba(16, 185, 129, ${1 - dist / MAX_DISTANCE})`;
          ctx.lineWidth = 1;
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.stroke();
        }
      }

      // Connect to mouse
      if (mouse.x !== null && mouse.y !== null) {
        const dx = particles[i].x - mouse.x;
        const dy = particles[i].y - mouse.y;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < MAX_DISTANCE) {
          ctx.strokeStyle = `rgba(16, 185, 129, ${1 - dist / MAX_DISTANCE})`;
          ctx.lineWidth = 1;
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
  background: linear-gradient(135deg, #0d0d0f, #1a1a1d);
}
</style>
