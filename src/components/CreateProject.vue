<template>
  <div class="flex flex-col">
    <h1>Bring your project to life</h1>
    <form action="submit">
      <div class="flex flex-col">
        <label for="title">Title</label>
        <input type="text" name="title" />
      </div>

      <div class="flex flex-col">
        <label for="description">Description</label>
        <textarea name="description" cols="30" rows="10"></textarea>
      </div>

      <div class="flex justify-center gap-2">
        <div class="flex flex-col">
          <label for="amount">Amount Needed (ETH)</label>
          <input type="number" name="amount" />
        </div>

        <div class="flex flex-col">
          <label for="duration">Duration (in days)</label>
          <input type="number" name="duration" />
        </div>
      </div>

      <div class="flex justify-around">
        <button type="button">CLOSE</button>
        <button type="submit">SAVE</button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'CreateProject'
}
</script>
