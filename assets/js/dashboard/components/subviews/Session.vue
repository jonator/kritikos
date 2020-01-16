<template>
  <div id="session-container">
    <table>
      <tr>
        <td>{{ session.keyword }}</td>
      </tr>
      <tr>
        <td>Session identifier</td>
        <td>{{ session.link }}</td>
      </tr>
      <tr>
        <td>Vote count</td>
        <td>{{ session.voteCount }}</td>
      </tr>
      <tr v-if="session.promptQuestion != null">
        <td>Custom prompt question</td>
        <td>{{ session.promptQuestion }}</td>
      </tr>
      <tr>
        <td>Start time</td>
        <td>{{ session.startDatetime }}</td>
      </tr>
      <tr>
        <td>Tags</td>
        <td>
          <div v-for="tag in session.tags" :key="tag.id">{{ tag.text }}</div>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  props: ["session"]
};
</script>
