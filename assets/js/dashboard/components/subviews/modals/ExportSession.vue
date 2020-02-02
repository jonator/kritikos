<template>
  <div id="export-session-form-container">
    <h3>Export session "{{ $store.state.modalState.keyword }}"</h3>
    <table>
      <col width="180" />
      <col width="10" />
      <tr>
        <td>
          QR Code
          <HelperTooltip
            :vPosition="'top'"
          >Most modern smartphones have QR code scanning built into camera app</HelperTooltip>
        </td>
        <td>
          <button
            v-on:click="$store.dispatch('EXPORT_SESSION', $store.state.modalState.keyword)"
          >download</button>
        </td>
      </tr>
    </table>
    <button @click="$emit('dismiss')">cancel</button>
  </div>
</template>

<script>
import HelperTooltip from "./../../HelperTooltip.vue";

export default {
  name: "ExportSession",
  components: { HelperTooltip }
};
</script>
