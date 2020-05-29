<template>
  <div id="settings-container" class="cards">
    <div id="user-info">
      About me
      <table>
        <tr v-if="$store.state.userRecord.firstLastName">
          <td>Name</td>
          <td>{{ $store.state.userRecord.firstLastName }}</td>
        </tr>
        <tr>
          <td id="email-label">
            Email
            <HelperTooltip v-if="$store.state.userRecord.isEmailActive">✅Email verified</HelperTooltip>
            <HelperTooltip
              v-else
            >❌Email not verified. Look for welcome email in spam folder, click "verify email" or send a new verification email.</HelperTooltip>
          </td>
          <td>
            {{ $store.state.userRecord.email }}
            <button
              v-if="!$store.state.userRecord.isEmailActive"
              v-on:click="sendVerificationEmail"
            >Send verification email</button>
          </td>
        </tr>
        <tr>
          <td>Password</td>
          <td>
            <button
              v-on:click="$store.dispatch('OPEN_MODAL', { form: 'ChangePassword', 
                                                          initialState: {
                                                            currentPassword: '',
                                                            newPassword: '',
                                                            confirmNewPassword: ''
                                                          }
                                                        })"
            >change password</button>
          </td>
        </tr>
      </table>
    </div>
    <div id="support">
      Support
      <table>
        <col width="40%" />
        <tr>
          <td id="desc">
            New email
            <i class="gg-external"></i>
          </td>
          <td>
            <a href="mailto:support@kritikos.app">support@kritikos.app</a>
          </td>
        </tr>
        <tr>
          <td id="desc">Feedback</td>
          <td>
            <a href="https://kritikos.app/kritikos" target="_blank">kritikos.app/kritikos</a>
          </td>
        </tr>
      </table>
    </div>
    <div v-if="$store.state.userRecord.isAdmin" id="admin">
      Admin
      <table>
        <tr>
          <a href="/admin/dashboard" target="_blank">Phoenix dashboard</a>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import HelperTooltip from "../HelperTooltip.vue";

export default {
  components: { HelperTooltip },
  methods: {
    sendVerificationEmail: function() {
      this.$store.dispatch("SEND_VERIFY_EMAIL").then(() => {
        this.$toasted.success("📧Verification email sent!");
      });
    }
  }
};
</script>

<style scoped>
button {
  margin: 0;
  width: 100%;
}
#desc {
  display: flex;
  justify-content: space-evenly;
}
#email-label {
  display: flex;
}

/* external icon */
.gg-external {
  box-sizing: border-box;
  position: relative;
  display: block;
  transform: scale(var(--ggs, 1));
  width: 12px;
  height: 12px;
  box-shadow: -2px 2px 0 0, -4px -4px 0 -2px, 4px 4px 0 -2px;
  margin-left: -2px;
  margin-top: 1px;
}
.gg-external::after,
.gg-external::before {
  content: "";
  display: block;
  box-sizing: border-box;
  position: absolute;
  right: -4px;
}
.gg-external::before {
  background: currentColor;
  transform: rotate(-45deg);
  width: 12px;
  height: 2px;
  top: 1px;
}
.gg-external::after {
  width: 8px;
  height: 8px;
  border-right: 2px solid;
  border-top: 2px solid;
  top: -4px;
}
</style>
