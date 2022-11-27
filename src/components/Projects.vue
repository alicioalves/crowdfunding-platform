<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <div class="flex flex-col gap-4 p-4">
    <p v-if="!projectData.length">No projects to show.</p>
    <Project
      v-for="project in projectData"
      :key="project.name"
      :project="project"
      :account="account"
    />
  </div>
</template>

<script>
import crowdfundInstance from '../../contracts/crowdfundInstance'
import crowdfundProject from '../../contracts/crowdfundProjectInstance'

import Project from '@/components/Project.vue'

export default {
  name: 'Projects',

  components: { Project },

  props: {
    account: {
      type: String
    }
  },

  data() {
    return {
      projectData: []
    }
  },

  created() {
    this.getProjects()
  },

  methods: {
    getProjects() {
      crowdfundInstance.methods
        .returnAllProjects()
        .call()
        .then((projects) => {
          projects.forEach((projectAddress) => {
            const projectInst = crowdfundProject(projectAddress)
            projectInst.methods
              .getDetails()
              .call()
              .then((projectData) => {
                const projectInfo = projectData
                projectInfo.isLoading = false
                projectInfo.contract = projectInst
                this.projectData.push(projectInfo)
              })
          })
        })
    }
  }
}
</script>
