<template>
  <div id="my-profile-container" class="cards">
    <div id="user-info">
      About me
      <table>
        <tr v-if="name">
          <td>Name</td>
          <td>{{ name }}</td>
        </tr>
        <tr>
          <td>Email</td>
          <td>{{ email }}</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      name: this.$store.state.user_record.name,
      email: this.$store.state.user_record.email
    };
  }
};
</script>
