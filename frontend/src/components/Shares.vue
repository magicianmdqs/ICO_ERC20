<template>
  <div class="p-6 md:p-8 bg-gray-900 rounded-3xl shadow-xl m-4 text-white">
    <h2 class="text-2xl font-bold text-green-400 mb-6">Token Distribution</h2>

    <div class="flex flex-col md:flex-row items-center md:space-x-8">
      <!-- Pie Chart container with fixed max width & height -->
      <div class="w-full md:w-1/2 max-w-[300px] h-[300px]">
        <Pie
          :data="chartData"
          :options="chartOptions"
        />
      </div>

      <!-- Legend -->
      <ul class="mt-6 md:mt-0 space-y-2 w-full md:w-1/2">
        <li
          v-for="(share, index) in shares"
          :key="index"
          class="flex justify-between items-center px-4 py-2 rounded-xl"
          :class="share.bg"
        >
          <span class="font-semibold">{{ share.label }}</span>
          <span>{{ share.value }}%</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { reactive, computed } from "vue";
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement } from "chart.js";
import { Pie } from "vue-chartjs";

ChartJS.register(Title, Tooltip, Legend, ArcElement);

const shares = reactive([
  { label: "Pre‑Launch Sale", value: 40, bg: "bg-green-800/40" },
  { label: "Public Sale", value: 50, bg: "bg-blue-800/40" },
  { label: "Marketing", value: 5, bg: "bg-purple-800/40" },
  { label: "AirDrop", value: 2.5, bg: "bg-red-800/40" },
  { label: "Dev Hold", value: 2.5, bg: "bg-yellow-800/40" },
]);

const chartData = computed(() => ({
  labels: shares.map(s => s.label),
  datasets: [
    {
      data: shares.map(s => s.value),
      backgroundColor: ["#10B981", "#3B82F6", "#8B5CF6", "#EF4444","yellow"],
      borderColor: "#0d0d0f",
      borderWidth: 2,
    },
  ],
}));

const chartOptions = {
  responsive: true,
  maintainAspectRatio: true,
  plugins: {
    legend: { display: false },
    tooltip: {
      callbacks: {
        label: ctx => `${ctx.label}: ${ctx.parsed}%`,
      },
    },
  },
};
</script>
