<template>
  <div id="export-session-form-container">
    <h3>Get "{{ $store.state.modalState.keyword }}" to your audience</h3>
    <p>Useful methods for getting this session to your audience (more export methods coming soon)</p>
    <table>
      <col width="180" />
      <col width="10" />
      <tr>
        <td>
          <div style="display: flex">
            QR Code
            <HelperTooltip
              :vPosition="'top'"
            >Most modern smartphones have QR code scanning built into camera app</HelperTooltip>
          </div>
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
