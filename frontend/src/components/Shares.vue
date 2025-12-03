<template>
  <div class="p-6 md:p-8 bg-gray-900 rounded-3xl shadow-xl m-4 text-white">
    <h2 class="text-2xl font-bold text-green-400 mb-6">
      Token Distribution
    </h2>

    <div class="flex flex-col md:flex-row items-center md:space-x-8 w-full">
      <!-- Pie Chart -->
      <div class="w-full md:w-1/2 max-w-[300px] h-[300px] transition-all duration-300">
        <Pie :data="chartData" :options="chartOptions" ref="chartRef" />
      </div>

      <!-- Legend List -->
      <ul class="mt-6 md:mt-0 space-y-2 w-full md:w-1/2">
        <li
          v-for="(share, index) in shares"
          :key="index"
          class="flex justify-between items-center px-4 py-3 rounded-xl cursor-pointer transition-all duration-300"
          :class="[
            share.bg,
            hoveredIndex === index
              ? 'ring-2 ring-green-400 shadow-lg scale-[1.03]'
              : ''
          ]"
          @mouseover="hoveredIndex = index"
          @mouseleave="hoveredIndex = null"
        >
          <span class="font-semibold">{{ share.label }}</span>
          <span>{{ share.value }}%</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, watch } from "vue";
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement } from "chart.js";
import { Pie } from "vue-chartjs";

ChartJS.register(Title, Tooltip, Legend, ArcElement);

const hoveredIndex = ref(null);
const chartRef = ref(null);

const shares = reactive([
  { label: "Pre-Launch Sale", value: 40, bg: "bg-green-800/40" },
  { label: "Public Sale", value: 50, bg: "bg-blue-800/40" },
  { label: "Marketing", value: 5, bg: "bg-purple-800/40" },
  { label: "AirDrop", value: 2.5, bg: "bg-red-800/40" },
  { label: "Dev Hold", value: 2.5, bg: "bg-yellow-700/40" },
]);

const baseColors = ["#10B981", "#3B82F6", "#8B5CF6", "#EF4444", "#FACC15"];

const chartData = computed(() => ({
  labels: shares.map((s) => s.label),
  datasets: [
    {
      data: shares.map((s) => s.value),
      backgroundColor: baseColors,
      borderColor: "#0d0d0f",
      borderWidth: 2,
      hoverOffset: 10, // bigger pop on hover
      hoverBorderColor: "#6dd8b4",
      hoverBorderWidth: 2,
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
        label: (ctx) => `${ctx.label}: ${ctx.parsed}%`,
      },
    },
  },
  animation: { duration: 300 },
};

/* --- LEGEND HOVER → CHART SLICE HIGHLIGHT --- */
watch(hoveredIndex, (i) => {
  const chart = chartRef.value?.chart;
  if (!chart) return;

  chart.setActiveElements(
    i !== null
      ? [{ datasetIndex: 0, index: i }]
      : []
  );
  chart.update();
});
</script>

<style scoped>
/* smooth legend effects */
li {
  backdrop-filter: blur(6px);
}
</style>
