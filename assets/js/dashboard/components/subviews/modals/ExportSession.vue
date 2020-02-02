<template>
  <div id="export-session-form-container">
    <h3>Export session link</h3>
    <table>
      <col width="180" />
      <col width="10" />
      <tr>
        <td>QR Code</td>
        <td>
          <button v-on:click="$store.dispatch('EXPORT_SESSION', sessionKeyword)">download</button>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
import HelperTooltip from "./../../HelperTooltip.vue";

export default {
  name: "ExportSession",
  props: ["sessionKeyword"],
  components: { HelperTooltip }
};
</script>
