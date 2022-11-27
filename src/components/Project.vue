<template>
  <div class="flex flex-col border border-black p-4 gap-2">
    <div class="flex items-center gap-2">
      <span
        class="py-1.5 px-3 rounded-md text-white font-bold"
        :class="stateMap[project.currentState].class"
      >
        {{ stateMap[project.currentState].text }}
      </span>
      <h1 class="font-bold text-2xl text-gray-800">
        {{ project.projectTitle }}
      </h1>
    </div>
    <p class="text-sm">{{ project.projectDesc }}</p>

    <p>
      Up until:
      <span class="font-bold">{{ new Date(project.deadline * 1000) }}</span>
    </p>

    <p>
      Goal: <span class="font-bold">{{ project.goalAmount }} ETH</span>
    </p>

    <div>
      <p>Amount (in ETH)</p>
      <input
        type="number"
        placeholder="0 ETH"
        class="border-b border-black mr-2"
      />
      <button
        class="px-6 py-2.5 mb-10 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
      >
        FUND
      </button>
    </div>

    <div class="flex items-center gap-4 px-10">
      <p>{{ project.currentAmount }}</p>
      <div class="w-full bg-blue-100 rounded-full h-2.5">
        <div
          class="bg-blue-600 h-2.5 rounded-full"
          :style="calculatePercentage(project)"
        ></div>
      </div>
      <p>{{ project.goalAmount }}</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Project',

  props: {
    project: {
      type: Object,
      required: true
    }
  },

  data() {
    return {
      stateMap: [
        { class: 'bg-blue-600', text: 'Ongoing' },
        { class: 'bg-red-600', text: 'Expired' },
        { class: 'bg-green-600', text: 'Completed' }
      ]
    }
  },

  methods: {
    calculatePercentage(project) {
      const currentAmount = project.currentAmount
      const goalAmount = project.goalAmount
      return `width: ${(currentAmount / goalAmount) * 100}%`
    }
  }
}
</script>
