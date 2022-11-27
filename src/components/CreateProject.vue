<template>
  <div class="flex flex-col">
    <h1>Bring your project to life</h1>
    <div class="flex flex-col">
      <label for="title">Title</label>
      <input type="text" name="title" v-model="newProject.title" />
    </div>

    <div class="flex flex-col">
      <label for="description">Description</label>
      <textarea
        name="description"
        cols="30"
        rows="10"
        v-model="newProject.description"
      ></textarea>
    </div>

    <div class="flex justify-center gap-2">
      <div class="flex flex-col">
        <label for="amount">Amount Needed (ETH)</label>
        <input type="number" name="amount" v-model="newProject.amountGoal" />
      </div>

      <div class="flex flex-col">
        <label for="duration">Duration (in days)</label>
        <input type="number" name="duration" v-model="newProject.duration" />
      </div>
    </div>

    <div class="flex justify-around">
      <button>CLOSE</button>
      <button @click="startProject()">SAVE</button>
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
          this.startProjectDialog = false
          this.newProject = { isLoading: false }
        })
    }
  },
  mounted() {
    web3.eth.getAccounts().then((accounts) => {
      [this.account] = accounts
    })
  }
}
</script>
