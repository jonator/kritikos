<template>
  <div id="export-session-form-container">
    <h3>Get "{{ $store.state.modalState.keyword }}" to your audience</h3>
    <p>Useful methods for getting this session to your audience:</p>
    <table>
      <col width="180" />
      <col width="10" />
      <tr>
        <td>
          <div class="has-tooltip">
            QR Code
            <HelperTooltip
              :vPosition="'top'"
              style="padding-left: 20px"
            >Most modern smartphones have QR code scanning built into camera app</HelperTooltip>
          </div>
        </td>
        <td id="download-button-container">
          <button
            v-on:click="$store.dispatch('EXPORT_SESSION_QR_CODE', $store.state.modalState.keyword)"
          >Download</button>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <div class="has-tooltip">
            Embed as an HTML iFrame
            <HelperTooltip style="padding-left: 20px">Useful for collecting feedback on web pages</HelperTooltip>
          </div>
          <div id="embed-iframe-container">
            <div id="code-wrapper">
              <code
                id="iframe-code"
                class="language-html"
              >&lt;iframe src=&quot;{{iframeURL}}&quot; height=&quot;300&quot; width=&quot;550&quot; /&gt;</code>
            </div>
            <button v-on:click="copyIFrameHtmlToClipboard(iframeURL)" id="copy-iframe-button">
              <i class="gg-copy" />
            </button>
          </div>
        </td>
      </tr>
      <tr>
        <td>
          <div class="has-tooltip">
            3x4 QR Codes (PDF)
            <HelperTooltip
              :vPosition="'top'"
              style="padding-left: 20px"
            >Generate a 3x4 grid of QRCodes with the prompt question above each code. Useful for cutting out and placing in strategic areas.</HelperTooltip>
          </div>
          <br />
          <a
            v-on:click="showQRGridExamplePhoto = !showQRGridExamplePhoto"
          >{{ showQRGridExamplePhoto ? 'Hide' : 'Show' }} example</a>
          <br />
          <img v-if="showQRGridExamplePhoto" src="images/qrpdf_grid_example.jpeg" width="300" />
        </td>
        <td id="download-button-container">
          <button
            v-on:click="$store.dispatch('EXPORT_SESSION_PDF', $store.state.modalState.keyword)"
          >Download</button>
        </td>
      </tr>
    </table>
    <button @click="$emit('dismiss')">cancel</button>
  </div>
</template>

<script>
import HelperTooltip from "./../../HelperTooltip.vue";
import utils from "../../../../utils";

export default {
  name: "ExportSession",
  components: { HelperTooltip },
  data: function() {
    return {
      showQRGridExamplePhoto: false
    };
  },
  computed: {
    iframeURL: function() {
      return (
        window.location.origin + "/" + this.$store.state.modalState.keyword
      );
    }
  },
  methods: {
    copyIFrameHtmlToClipboard: function(url) {
      const htmlIFrame =
        '<iframe src="' + url + '" height="300" width="550" />';
      utils.copyToClipboard(htmlIFrame);
      this.$toasted.success("📝 Copied!", { duration: 5000 });
    }
  }
};
</script>

<style scoped>
#download-button-container {
  display: grid;
  justify-content: right;
}
#embed-iframe-container {
  display: flex;
  justify-content: space-between;
}
#code-wrapper {
  margin-top: auto;
  margin-bottom: auto;
}
#iframe-code {
  user-select: text;
  padding: 5px;
}

.has-tooltip {
  display: inline-flex;
}

/* copy iframe button icon */
.gg-copy {
  box-sizing: border-box;
  position: relative;
  display: block;
  transform: scale(var(--ggs, 1));
  width: 14px;
  height: 18px;
  border: 2px solid;
  margin-left: -5px;
  margin-top: -4px;
}
.gg-copy::after,
.gg-copy::before {
  content: "";
  display: block;
  box-sizing: border-box;
  position: absolute;
}
.gg-copy::before {
  background: linear-gradient(to left, currentColor 5px, transparent 0)
      no-repeat right top/5px 2px,
    linear-gradient(to left, currentColor 5px, transparent 0) no-repeat left
      bottom/ 2px 5px;
  box-shadow: inset -4px -4px 0 -2px;
  bottom: -6px;
  right: -6px;
  width: 14px;
  height: 18px;
}
.gg-copy::after {
  width: 6px;
  height: 2px;
  background: currentColor;
  left: 2px;
  top: 2px;
  box-shadow: 0 4px 0, 0 8px 0;
}
</style>
