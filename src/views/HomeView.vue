<template>
  <div>
    <div class="flex flex-col gap-4 mt-10">
      <h1 class="font-bold text-2xl">Crowdfunding</h1>
      <p class="">Utilizing Ethereum for Decentralized Crowdfunding</p>
    </div>

    <button
      @click="shouldDisplayCreateProjectModal = true"
      type="button"
      class="px-6 py-2.5 bg-blue-600 text-white font-medium text-xs leading-tight uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
    >
      Start a Project
    </button>

    <CreateProject
      v-if="shouldDisplayCreateProjectModal"
      @close="shouldDisplayCreateProjectModal = false"
    />
  </div>
</template>

<script>
import CreateProject from '@/components/CreateProject'

export default {
  name: 'HomeView',
  components: {
    CreateProject
  },

  data() {
    return {
      shouldDisplayCreateProjectModal: false
    }
  }
}
</script>
