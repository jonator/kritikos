<template>
  <div id="change-password-form-container">
    <h3>Change password</h3>
    <form id="change-password-form" @submit.prevent="handleSubmit">
      <input
        id="current-password"
        type="password"
        placeholder="current password"
        v-model="currentPassword"
      />
      <input id="new-password" type="password" placeholder="new password" v-model="newPassword" />
      <input
        id="confirm-new-password"
        type="password"
        placeholder="confirm-new-password"
        v-model="confirmNewPassword"
      />
      <button type="submit">submit</button>
      <button type="cancel" @click.prevent="handleCancel">cancel</button>
    </form>
  </div>
</template>

<script>
export default {
  name: "ChangePassword",
  data: function() {
    return this.$store.state.modalState;
  },
  methods: {
    handleSubmit: function() {
      const attrs = this.$store.state.modalState;
      this.$store.dispatch("UPDATE_USER_PASSWORD", attrs).then(() => {
        this.$store.dispatch("DISMISS_MODAL", false);
        this.$toasted.success("🎉 Password changed successfully!", {
          duration: 5000
        });
      });
    },
    handleCancel: function() {
      this.$store.dispatch("DISMISS_MODAL", false);
    }
  }
};
</script>

<style scoped>
#change-password-form {
  width: 40%;
}
</style>
