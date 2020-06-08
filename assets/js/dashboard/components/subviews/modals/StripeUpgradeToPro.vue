<template>
  <div id="stripe-upgrade-to-pro-container">
    <section id="pricing">
      <div id="tier-branding">
        <img src="images/k_logo_pro.jpg" />

        <h5>Businesses</h5>
      </div>

      <div id="tier-price">
        <div class="price">
          $
          <span>10</span>/mo
        </div>
      </div>

      <div class="features">
        <ol>
          <li>
            View up to
            <b>400</b> feedback responses.
          </li>
          <li>Full-featured dashboard</li>
          <li>External app integrations (coming soon)</li>
          <li>Base support</li>
        </ol>
      </div>
      <PoweredByStripeSvg id="powered-by-stripe" />
    </section>
    <section id="actions">
      <button v-on:click="$emit('dismiss')">Cancel</button>
      <button v-on:click="openCheckoutSession">Open checkout portal</button>
    </section>
  </div>
</template>

<script>
import PoweredByStripeSvg from "../../../../../static/svg/dashboard/powered_by_stripe.svg";

export default {
  name: "StripeUpgradeToPro",
  components: { PoweredByStripeSvg },
  methods: {
    openCheckoutSession: function() {
      this.$store.dispatch("OPEN_CHECKOUT_SESSION").then(checkout_session => {
        this.$store.state.stripe.client
          .redirectToCheckout({
            sessionId: checkout_session.id
          })
          .then(console.log);
      });
    }
  }
};
</script>

<style scoped>
#stripe-upgrade-to-pro-container {
  text-align: center;
}
#powered-by-stripe {
  grid-column-start: 1;
  grid-column-end: 4;
  margin: auto;
}
#actions {
  margin-top: 20px;
}

#pricing {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  padding: 0 100px;
}
#pricing div {
  margin: auto;
}
#pricing img {
  margin: auto;
  width: 60px;
}
#pricing .price {
  font-weight: bold;
}
#pricing .price span {
  font-size: 3em;
  margin: 3px;
}
#pricing a {
  margin: auto;
}
#pricing .features {
  margin-top: 20px;
}
#pricing .features ol {
  padding-left: 18px;
  text-align: left;
}
#pricing .features li {
  list-style: "✅";
  list-style-position: inside;
}
</style>