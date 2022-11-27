<template>
  <div class="border border-black">
    <h1 class="font-bold text-lg bg-neutral-700 text-white p-2">
      {{ project.projectTitle }}
    </h1>
    <p class="text-sm bg-neutral-200 p-2">{{ project.projectDesc }}</p>
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
  }
}
</script>
