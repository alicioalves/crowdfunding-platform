<template>
  <div>
    <div class="flex flex-col items-center gap-4 mt-10 border-b-2">
      <h1 class="font-bold text-2xl">Crowdfunding</h1>
      <p class="">Utilizing Ethereum for Decentralized Crowdfunding</p>

      <button
        @click="shouldDisplayCreateProjectModal = true"
        type="button"
        class="px-6 py-2.5 mb-10 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
      >
        Start a Project
      </button>
    </div>

    <template>
      <CreateProject
        :account="account"
        v-if="shouldDisplayCreateProjectModal"
        @close="shouldDisplayCreateProjectModal = false"
      />
    </template>

    <div class="flex flex-col items-center mt-5">
      <h1 class="font-bold text-xl">Projects</h1>
      <Projects :account="account" />
    </div>
  </div>
</template>

<script>
import CreateProject from '@/components/CreateProject'
import Projects from '@/components/Projects.vue'

import web3 from '../../contracts/web3'

export default {
  name: 'HomeView',
  components: {
    CreateProject,
    Projects
  },

  data() {
    return {
      account: null,
      shouldDisplayCreateProjectModal: false
    }
  },

  mounted() {
    web3.eth.getAccounts().then((accounts) => {
      ;[this.account] = accounts
    })
  }
}
</script>
