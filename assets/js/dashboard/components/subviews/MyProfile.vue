<template>
  <div id="my-profile-container" class="cards">
    <div id="user-info">
      About me
      <table>
        <tr v-if="$store.state.userRecord.firstLastName">
          <td>Name</td>
          <td>{{ $store.state.userRecord.firstLastName }}</td>
        </tr>
        <tr>
          <td>Email</td>
          <td>{{ $store.state.userRecord.email }}</td>
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
              id="change-pass-button"
            >change password</button>
          </td>
        </tr>
      </table>
    </div>
  </div>
</template>
