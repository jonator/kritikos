<template>
  <div id="session-card-container">
    <table>
      <tr>
        <td>{{ session.keyword }}</td>
      </tr>
    </table>
    <a href="session.link">{{ session.link }}</a>
    <span>Vote count: {{ session.voteCount }}</span>
    <div>
      <button v-on:click="$store.dispatch('SELECT_SESSION', session.id)">Info</button>
      <button class="warning" v-if="!session.isPermanent">End</button>
    </div>
  </div>
</template>

<script>
export default {
  props: ["session"]
};
</script>

<style scoped>
#session-card-container {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
</style>
