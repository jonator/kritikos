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
      </table>
    </div>
  </div>
</template>
