<template>
  <!-- Postcard Drop Animation -->
  <div
      v-if="showPostcard"
      :class="[
    'postcard-container fixed top-0 left-1/2 -translate-x-1/2 z-[9999] flex flex-col items-center',
    pullingUp ? 'postcard-pullup' : 'postcard-fall-frame'
  ]"
  >
    <!-- Thread -->
    <div class="thread w-[2px] bg-gray-300"></div>

    <!-- Postcard -->
    <div
        class="postcard bg-gray-800 text-green-300 font-bold px-6 py-4 rounded-xl shadow-xl"
        :class="pullingUp ? 'postcard-stop-swing' : ''"
    >
      ABRADACABRA BITCH!
    </div>
  </div>


  <header
      class="relative bg-gradient-to-b from-gray-900/80 to-gray-800/80 backdrop-blur-xl rounded-b-3xl shadow-[0_0_30px_rgba(0,255,120,0.2)] px-6 py-6 flex justify-between items-center">

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
  state: {type: Boolean, required: true}
});

import {ref, onMounted} from 'vue';

const showPostcard = ref(false);
const pullingUp = ref(false);

onMounted(() => {
  const seen = localStorage.getItem("abracadabra_drop");

  if (!seen) {
    showPostcard.value = true;
    localStorage.setItem("abracadabra_drop", "1");

    // Wait before pulling it back up
    setTimeout(() => {
      pullingUp.value = true;

      // remove element after pull-up animation finishes
      setTimeout(() => {
        showPostcard.value = false;
      }, 2000); // matches CSS animation duration
    }, 10000);
  }
});
</script>


<style>
/* ===================== */
/* FALL ANIMATION        */
/* ===================== */

@keyframes postcard-fall {
  0% {
    transform: translateY(-220px) rotate(0deg);
    opacity: 0;
  }
  40% {
    opacity: 1;
    transform: translateY(0px) rotate(6deg);
  }
  60% {
    transform: translateY(12px) rotate(-5deg);
  }
  80% {
    transform: translateY(0px) rotate(3deg);
  }
  100% {
    transform: translateY(0px) rotate(0deg);
  }
}

.postcard-fall-frame {
  animation: postcard-fall 1.5s ease-out forwards;
}

.thread {
  height: 90px;
  animation: thread-stretch 0.8s ease-out forwards;
}

/* ===================== */
/* SWING ANIMATION       */
/* ===================== */
@keyframes postcard-swing {
  0% {
    transform: rotate(3deg);
  }
  100% {
    transform: rotate(-3deg);
  }
}

.postcard {
  animation: postcard-swing 2s ease-in-out infinite alternate;
  transform-origin: top center;
}

/* When pulling up, stop the swing instantly */
.postcard-stop-swing {
  animation: none !important;
}


/* ===================== */
/* ELEGANT PULL-UP        */
/* ===================== */

@keyframes postcard-pull {
  0% {
    transform: translateY(0px);
  }
  40% {
    transform: translateY(-20px); /* small tug */
  }
  70% {
    transform: translateY(-40px); /* more tension */
  }
  100% {
    transform: translateY(-220px); /* pulled out of screen */
  }
}

@keyframes thread-pull {
  0% {
    height: 90px;
  }
  40% {
    height: 70px;
  }
  70% {
    height: 50px;
  }
  100% {
    height: 20px;
  }
}

.postcard-pullup {
  animation: postcard-pull 2s cubic-bezier(0.40, 0.00, 0.25, 1.00) forwards;
}

.postcard-pullup .thread {
  animation: thread-pull 2s cubic-bezier(0.40, 0.00, 0.25, 1.00) forwards;
}


/* Postcard falling and swinging */
@keyframes postcard-fall {
  0% {
    transform: translateY(-200px) rotate(0deg);
    opacity: 0;
  }
  40% {
    opacity: 1;
    transform: translateY(0px) rotate(5deg);
  }
  60% {
    transform: translateY(10px) rotate(-4deg);
  }
  80% {
    transform: translateY(0px) rotate(2deg);
  }
  100% {
    transform: translateY(0px) rotate(0deg);
  }
}

.postcard-container {
  animation: postcard-fall 1.6s ease-out forwards;
}

.postcard {
  animation: postcard-swing 2s ease-in-out infinite alternate;
  transform-origin: top center;
}

@keyframes postcard-swing {
  0% {
    transform: rotate(3deg);
  }
  100% {
    transform: rotate(-3deg);
  }
}


/* Neon ping animation */
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

/* iPhone-style large notch */
.notch {
  background-color: #0a0a0a;
  width: 20%; /* notch wide enough for text + dot */
  height: 48px; /* enough for dot + text */
  border-radius: 24px 24px 16px 16px; /* smooth rounded corners */
  box-shadow: 0 0 8px rgba(0, 0, 0, 0.5);
  z-index: 20;
  padding-left: 10px;
  padding-right: 10px;
}
</style>
