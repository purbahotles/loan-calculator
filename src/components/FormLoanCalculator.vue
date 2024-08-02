<template>
  <div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">Loan Calculator</h1>
    <form @submit.prevent="calculateSchedule" class="space-y-4">
      <!-- Plafond Input -->
      <div class="grid grid-cols-2 gap-4">
        <label class="label-input">Plafond (Loan Amount):</label>
        <div>
          <input
            type="text"
            :value="formattedPlafond"
            @input="updatePlafond"
            class="input"
            :class="{'border-red-500': errors.plafond}"
            required
          />
          <span v-if="errors.plafond" class="error-text">
            {{ errors.plafond }}
          </span>
        </div>
      </div>
      
      <!-- Lama Pinjaman Input -->
      <div class="grid grid-cols-2 gap-4">
        <label class="label-input">Lama Pinjaman (Loan Term in months):</label>
        <div class="relative">
          <input
            type="number"
            v-model.number="lamaPinjaman"
            class="input"
            :class="{'border-red-500': errors.lamaPinjaman}"
            required
          />
          <span v-if="errors.lamaPinjaman" class="error-text">
            {{ errors.lamaPinjaman }}
          </span>
        </div>
      </div>
      
      <!-- Suku Bunga Input -->
      <div class="grid grid-cols-2 gap-4">
        <label class="label-input">Suku Bunga (Annual Interest Rate):</label>
        <div class="relative">
          <input
            type="number"
            v-model.number="sukuBunga"
            class="input"
            :class="{'border-red-500': errors.sukuBunga}"
            required
          />
          <span v-if="errors.sukuBunga" class="error-text">
            {{ errors.sukuBunga }}
          </span>
        </div>
      </div>
      
      <!-- Tanggal Mulai Angsuran Input -->
      <div class="grid grid-cols-2 gap-4">
        <label class="label-input">Tanggal Mulai Angsuran (Start Date):</label>
        <div class="relative">
          <input
            type="date"
            v-model="tanggalMulai"
            class="input"
            :class="{'border-red-500': errors.tanggalMulai}"
            required
          />
          <span v-if="errors.tanggalMulai" class="error-text">
            {{ errors.tanggalMulai }}
          </span>
        </div>
      </div>
      
      <div class="flex justify-center pt-5 pl-24">
        <button type="submit" class="bg-blue-500 text-white p-2 rounded">Calculate</button>
      </div>
    </form>
    
    <table v-if="repaymentSchedule.length" class="mt-4 w-full border">
      <thead>
        <tr class="bg-gray-200">
          <th class="border px-4 py-2">Angsuran ke</th>
          <th class="border px-4 py-2">Tanggal</th>
          <th class="border px-4 py-2">Total Angsuran</th>
          <th class="border px-4 py-2">Angsuran Pokok</th>
          <th class="border px-4 py-2">Angsuran Bunga</th>
          <th class="border px-4 py-2">Sisa Angsuran Pokok</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="installment in repaymentSchedule" :key="installment.angsuranKe">
          <td class="border px-4 py-2">{{ installment.angsuranKe }}</td>
          <td class="border px-4 py-2">{{ installment.tanggal }}</td>
          <td class="border px-4 py-2">{{ formatRupiah(installment.totalAngsuran) }}</td>
          <td class="border px-4 py-2">{{ formatRupiah(installment.angsuranPokok) }}</td>
          <td class="border px-4 py-2">{{ formatRupiah(installment.angsuranBunga) }}</td>
          <td class="border px-4 py-2">{{ formatRupiah(installment.sisaAngsuranPokok) }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import { logInfo, logDebug, logError } from '@/services/logger';

const plafond = ref(0);
const lamaPinjaman = ref(0);
const sukuBunga = ref(0);
const tanggalMulai = ref('');
const repaymentSchedule = ref([]);
const errors = ref({});

const formatRupiah = (number) => {
  return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(number);
};

const updatePlafond = (event) => {
  const inputValue = event.target.value.replace(/[^0-9,]+/g, ''); // Remove non-numeric characters except comma
  const numericValue = parseFloat(inputValue.replace(/,/g, '')); // Remove comma and convert to number
  plafond.value = isNaN(numericValue) ? 0 : numericValue;
};

const formattedPlafond = computed(() => {
  return new Intl.NumberFormat('id-ID', { style: 'decimal' }).format(plafond.value);
});

// Function to validate inputs
const validateInputs = () => {
  errors.value = {}; // Reset errors

  if (!plafond.value || isNaN(plafond.value)) {
    errors.value.plafond = 'Plafond harus diisi dan berupa angka.';
  }

  if (!lamaPinjaman.value || isNaN(lamaPinjaman.value) || lamaPinjaman.value <= 0) {
    errors.value.lamaPinjaman = 'Lama pinjaman harus diisi dan berupa angka positif.';
  }

  if (!sukuBunga.value || isNaN(sukuBunga.value) || sukuBunga.value < 0) {
    errors.value.sukuBunga = 'Suku bunga harus diisi dan berupa angka non-negatif.';
  }

  if (!tanggalMulai.value) {
    errors.value.tanggalMulai = 'Tanggal mulai angsuran harus diisi.';
  }
};

// Watchers for each input to clear errors on change
watch(plafond, validateInputs);
watch(lamaPinjaman, validateInputs);
watch(sukuBunga, validateInputs);
watch(tanggalMulai, validateInputs);

const calculateSchedule = () => {
  validateInputs();
  if (Object.keys(errors.value).length > 0) {
    logError('Form validation errors', errors.value);
    return;
  }
  logInfo(`Calculating schedule with plafond: ${plafond.value}, lamaPinjaman: ${lamaPinjaman.value}, sukuBunga: ${sukuBunga.value}, tanggalMulai: ${tanggalMulai.value}`);
  try {
    repaymentSchedule.value = calculateLoanSchedule(plafond.value, lamaPinjaman.value, sukuBunga.value, tanggalMulai.value);
    logDebug('Schedule calculated successfully');
  } catch (error) {
    logError('Error calculating schedule', error);
  }
};

const calculateLoanSchedule = (plafond, lamaPinjaman, sukuBunga, startDate) => {
  // Convert annual interest rate to monthly interest rate
  const i = (sukuBunga / 100) / 12;
  const n = lamaPinjaman;

  // Calculate the monthly installment using the formula
  const A = (i * plafond * Math.pow(1 + i, n)) / (Math.pow(1 + i, n) - 1);

  let currentDate = new Date(startDate);
  let remainingPrincipal = plafond;
  let repaymentSchedule = [];

  // Helper function to round to nearest integer based on decimal value
  const roundToNearest = (value, precision) => {
    const factor = Math.pow(10, precision);
    const rounded = Math.round(value * factor);
    const remainder = rounded % factor;
    return (remainder < factor / 2 ? rounded - remainder : rounded + (factor - remainder)) / factor;
  };

  // Helper function to calculate interest for a given principal and month
  const calculateMonthlyInterest = (principal, annualRate, daysInMonth = 30) => {
    const monthlyRate = annualRate / 12 / 100;
    return (principal * monthlyRate * daysInMonth) / 30;
  };

  for (let month = 1; month <= n; month++) {
    // Calculate the interest for the current month
    const angsuranBunga = roundToNearest(calculateMonthlyInterest(remainingPrincipal, sukuBunga), 2);

    // Calculate the principal part of the installment
    const angsuranPokok = roundToNearest(A - angsuranBunga, 2);

    // Update the remaining principal
    remainingPrincipal = roundToNearest(remainingPrincipal - angsuranPokok, 2);

    // Update the repayment schedule
    repaymentSchedule.push({
      angsuranKe: month,
      tanggal: currentDate.toISOString().slice(0, 10), // Format date as YYYY-MM-DD
      totalAngsuran: A.toFixed(2),
      angsuranPokok: angsuranPokok.toFixed(2),
      angsuranBunga: angsuranBunga.toFixed(2),
      sisaAngsuranPokok: remainingPrincipal.toFixed(2)
    });

    // Move to the next month
    currentDate.setMonth(currentDate.getMonth() + 1);
  }

  return repaymentSchedule;
};
</script>

<style scoped>
/* Add any component-specific styles here */
</style>
