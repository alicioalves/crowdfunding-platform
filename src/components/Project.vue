<template>
  <div class="flex flex-col border border-black p-4 gap-2">
    <div class="flex items-center gap-2">
      <span
        class="py-1.5 px-3 rounded-md text-white font-bold"
        :class="stateMap[currentState].class"
      >
        {{ stateMap[currentState].text }}
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
      Goal: {{ convertToEth(this.project.goalAmount) }}
      <span class="font-bold"> ETH</span>
    </p>

    <div>
      <p>Amount (in ETH)</p>
      <input
        type="number"
        placeholder="0 ETH"
        class="border-b border-black mr-2"
        v-model="fundAmount"
        :disabled="project.currentState == 1 || project.currentState == 2"
      />
      <button
        v-if="project.currentState == 0"
        class="px-6 py-2.5 mb-10 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
        @click="fundProject()"
      >
        FUND
      </button>
      <button
        v-if="project.currentState == 1"
        class="px-6 py-2.5 mb-10 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
        @click="getRefund()"
      >
        GET REFUND
      </button>
    </div>

    <div class="flex items-center gap-4 px-10">
      <p>{{ convertToEth(currentAmount) }}</p>
      <div class="w-full bg-blue-100 rounded-full h-2.5">
        <div
          class="bg-blue-600 h-2.5 rounded-full"
          :style="calculatePercentage(project)"
        ></div>
      </div>
      <p>{{ convertToEth(project.goalAmount) }}</p>
    </div>
    <div>
      <p v-if="isLoading">Loading...</p>
    </div>
  </div>
</template>

<script>
import web3 from '../../contracts/web3'

export default {
  name: 'Project',

  props: {
    project: {
      type: Object,
      required: true
    },
    account: {
      type: String
    }
  },

  data() {
    return {
      stateMap: [
        { class: 'bg-blue-600', text: 'Ongoing' },
        { class: 'bg-red-600', text: 'Expired' },
        { class: 'bg-green-600', text: 'Completed' }
      ],
      fundAmount: null,
      isLoading: false,
      updatedAmount: null,
      updatedState: null
    }
  },

  computed: {
    currentAmount() {
      if (this.updatedAmount) {
        return this.updatedAmount
      }

      return this.project.currentAmount
    },

    currentState() {
      if (this.updatedState) {
        return this.updatedAmount
      }

      return this.project.currentState
    }
  },

  methods: {
    calculatePercentage() {
      const currentAmount = this.currentAmount
      const goalAmount = this.project.goalAmount
      return `width: ${(currentAmount / goalAmount) * 100}%`
    },

    fundProject() {
      if (!this.fundAmount) return
      const projectContract = this.project.contract
      this.isLoading = true
      projectContract.methods
        .contribute()
        .send({
          from: this.account,
          value: this.convertToWei(this.fundAmount)
        })
        .then((res) => {
          const newTotal = parseInt(
            res.events.FundingReceived.returnsValues.currentTotal,
            10
          )
          const projectGoal = parseInt(this.project.goalAmount, 10)
          this.updatedAmount = newTotal
          this.isLoading = false

          // If the goal is complete, set the project state to success
          if (newTotal >= projectGoal) {
            this.updatedState = 2
          }
        })
    },

    getRefund() {
      this.isLoading = true
      const projectContract = this.project.contract
      projectContract.methods
        .getRefund()
        .send({
          from: this.account
        })
        .then(() => {
          this.isLoading = false
        })
    },

    convertToWei(amount) {
      return web3.utils.toWei(amount, 'ether')
    },

    convertToEth(amount) {
      return web3.utils.fromWei(amount, 'ether')
    }
  }
}
</script>
