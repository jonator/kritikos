<template>
  <div id="my-profile-container" class="cards">
    <div id="user-info">
      About me
      <table>
        <tr v-if="showName">
          <td>Name</td>
          <td>{{ $store.state.userRecord.name }}</td>
        </tr>
        <tr>
          <td>Email</td>
          <td>{{ $store.state.userRecord.email }}</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    showName: function() {
      const name = this.$store.state.userRecord.name;
      return name != null && name != undefined;
    }
  }
};
</script>
