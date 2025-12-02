<template>
  <!-- Full-page background canvas -->
  <canvas ref="canvas" class="bg-canvas"></canvas>
</template>

<script setup>
import { onMounted, ref, onBeforeUnmount } from "vue";

const canvas = ref(null);
let ctx, particles = [], animationId;

// ↓ Reduced to half as you asked
const PARTICLE_COUNT = 40;
const TENTACLE_DISTANCE = 110;
const MOUSE_FORCE = 0.04;

class Particle {
  constructor(w, h) {
    this.x = Math.random() * w;
    this.y = Math.random() * h;
    this.vx = (Math.random() - 0.5) * 0.5;
    this.vy = (Math.random() - 0.5) * 0.5;
    this.radius = Math.random() * 2 + 1.5;

    this.offsetX = Math.random() * 1000;
    this.offsetY = Math.random() * 1000;
  }

  move(w, h, t) {
    this.x += Math.sin(t + this.offsetX) * 0.15;
    this.y += Math.cos(t + this.offsetY) * 0.15;

    this.x += this.vx;
    this.y += this.vy;

    if (this.x < 0 || this.x > w) this.vx *= -1;
    if (this.y < 0 || this.y > h) this.vy *= -1;
  }
}

onMounted(() => {
  const c = canvas.value;
  ctx = c.getContext("2d");

  function resize() {
    c.width = window.innerWidth * window.devicePixelRatio;
    c.height = window.innerHeight * window.devicePixelRatio;
    ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
  }
  resize();
  window.addEventListener("resize", resize);

  for (let i = 0; i < PARTICLE_COUNT; i++) {
    particles.push(new Particle(window.innerWidth, window.innerHeight));
  }

  const mouse = { x: null, y: null, smoothX: 0, smoothY: 0 };
  c.addEventListener("mousemove", (e) => {
    mouse.x = e.clientX;
    mouse.y = e.clientY;
  });
  c.addEventListener("mouseleave", () => {
    mouse.x = null;
  });

  let t = 0;
  function animate() {
    t += 0.01;

    ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

    if (mouse.x !== null) {
      mouse.smoothX += (mouse.x - mouse.smoothX) * 0.1;
      mouse.smoothY += (mouse.y - mouse.smoothY) * 0.1;
    }

    particles.forEach((p) => {
      p.move(window.innerWidth, window.innerHeight, t);

      ctx.beginPath();
      ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
      ctx.fillStyle = "rgba(80,255,200,1)";
      ctx.shadowColor = "rgba(80,255,200,0.7)";
      ctx.shadowBlur = 7;
      ctx.fill();
    });

    for (let i = 0; i < PARTICLE_COUNT; i++) {
      const p = particles[i];

      if (mouse.x !== null) {
        const dx = p.x - mouse.smoothX;
        const dy = p.y - mouse.smoothY;
        const dist = Math.sqrt(dx * dx + dy * dy);

        if (dist < TENTACLE_DISTANCE) {
          const pull = 1 - dist / TENTACLE_DISTANCE;

          p.x -= dx * (MOUSE_FORCE * pull);
          p.y -= dy * (MOUSE_FORCE * pull);

          const cx = (p.x + mouse.smoothX) / 2 + (dx * 0.3);
          const cy = (p.y + mouse.smoothY) / 2 + (dy * -0.3);

          ctx.beginPath();
          ctx.moveTo(mouse.smoothX, mouse.smoothY);
          ctx.quadraticCurveTo(cx, cy, p.x, p.y);

          ctx.strokeStyle = `rgba(120,255,220,${pull})`;
          ctx.lineWidth = 1.8;
          ctx.shadowColor = "rgba(120,255,220,0.8)";
          ctx.shadowBlur = 8;
          ctx.stroke();
        }
      }
    }

    animationId = requestAnimationFrame(animate);
  }

  animate();
});

onBeforeUnmount(() => cancelAnimationFrame(animationId));
</script>

<style scoped>
.bg-canvas {
  position: fixed;
  inset: 0;
  width: 100vw;
  height: 100vh;
  z-index: -1;
  pointer-events: none; /* important: keeps UI clickable */
  background: radial-gradient(circle at center, #0f1516, #050607);
}
</style>
