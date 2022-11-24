<template>
  <div>
    <div class="flex flex-col gap-4 mt-10">
      <h1 class="font-bold text-2xl">Crowdfunding</h1>
      <p class="">Utilizing Ethereum for Decentralized Crowdfunding</p>
    </div>

    <button>Start a Project</button>

    <CreateProject />
  </div>
</template>

<script>
import CreateProject from '@/components/CreateProject'

export default {
  name: 'HomeView',
  components: {
    CreateProject
  }
}
</script>
