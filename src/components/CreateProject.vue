<template>
  <div
    class="overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none justify-center items-center flex bg-black bg-opacity-40"
  >
    <div class="relative w-auto my-6 mx-auto max-w-sm">
      <div
        class="border-0 rounded-lg shadow-lg relative flex flex-col w-full bg-white outline-none focus:outline-none"
      >
        <div
          class="flex items-center justify-center p-5 border-b border-solid border-slate-200 rounded-t"
        >
          <h1 class="font-bold text-xl">Bring your project to life</h1>
          <button
            class="ml-auto border-0 text-black float-right text-3xl leading-none"
            @click="closeModal()"
          >
            <span class="text-black text-2xl block"> x </span>
          </button>
        </div>
        <div class="flex flex-col justify-center p-5">
          <div class="flex flex-col">
            <label for="title">Title</label>
            <input
              class="border border-black"
              type="text"
              name="title"
              v-model="newProject.title"
            />
          </div>

          <div class="flex flex-col">
            <label for="description">Description</label>
            <textarea
              class="border border-black"
              name="description"
              cols="30"
              rows="10"
              v-model="newProject.description"
            ></textarea>
          </div>

          <div class="flex flex-col justify-center gap-2">
            <div class="flex flex-col">
              <label for="amount">Amount Needed (ETH)</label>
              <input
                class="border border-black"
                type="number"
                name="amount"
                v-model="newProject.amountGoal"
              />
            </div>

            <div class="flex flex-col">
              <label for="duration">Duration (in days)</label>
              <input
                class="border border-black"
                type="number"
                name="duration"
                v-model="newProject.duration"
              />
            </div>
          </div>
        </div>
        <div
          class="flex items-center justify-end p-6 border-t border-solid border-slate-200 rounded-b"
        >
          <button
            class="text-black bg-transparent border border-solid border-black hover:bg-black hover:text-white active:bg-red-600 font-bold uppercase text-sm px-6 py-3 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
            type="button"
            @click="closeModal()"
          >
            Close
          </button>
          <button
            class="text-black bg-transparent border border-solid border-black hover:bg-black hover:text-white active:bg-red-600 font-bold uppercase text-sm px-6 py-3 rounded outline-none focus:outline-none mr-1 mb-1 ease-linear transition-all duration-150"
            type="button"
            @click="startProject()"
          >
            Create Project
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import crowdfundInstance from '../../contracts/crowdfundInstance'
import crowdfundProject from '../../contracts/crowdfundProjectInstance'
import web3 from '../../contracts/web3'

export default {
  name: 'CreateProject',
  data() {
    return {
      startProjectDialog: false,
      account: null,
      projectData: [],
      newProject: { isLoading: false }
    }
  },

  methods: {
    startProject() {
      this.closeModal()
      this.newProject.isLoading = true
      crowdfundInstance.methods
        .startProject(
          this.newProject.title,
          this.newProject.description,
          this.newProject.duration,
          web3.utils.toWei(this.newProject.amountGoal, 'ether')
        )
        .send({
          from: this.account
        })
        .then((res) => {
          const projectInfo = res.events.ProjectStarted.returnValues
          projectInfo.isLoading = false
          projectInfo.currentAmount = 0
          projectInfo.currentState = 0
          projectInfo.contract = crowdfundProject(projectInfo.contractAddress)
          this.newProject = { isLoading: false }
        })
    },

    closeModal() {
      this.$emit('close')
    }
  },
  mounted() {
    web3.eth.getAccounts().then((accounts) => {
      ;[this.account] = accounts
    })
  }
}
</script>
