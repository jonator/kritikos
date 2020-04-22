<template>
  <transition name="modal">
    <div id="modal-mask">
      <div id="modal-wrapper" v-on:click="dismiss($event)">
        <div id="modal-container">
          <component v-bind:is="$store.state.currentModalName" @dismiss="dismiss" />
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import ChangePassword from "./modals/ChangePassword.vue";
import CreateSessionForm from "./modals/CreateSessionForm.vue";
import ExportSession from "./modals/ExportSession.vue";

const withinModalBox = event => {
  try {
    // chrome
    return event.path.find(elem => elem.id == "modal-container");
  } catch (error) {
    // safari
    return event.srcElement.id != "modal-wrapper";
  }
};

export default {
  components: { ChangePassword, CreateSessionForm, ExportSession },
  data: function() {
    return { initialModalState: { ...this.$store.state.modalState } };
  },
  methods: {
    dismiss: function(event) {
      let modalChanged =
        JSON.stringify(this.initialModalState) !=
        JSON.stringify(this.$store.state.modalState);

      if (!event || !withinModalBox(event)) {
        this.$store.dispatch("DISMISS_MODAL", modalChanged);
      }
    }
  }
};
</script>

<style scoped>
#modal-mask {
  position: fixed;
  z-index: 9997;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
  display: table;
  transition: opacity 0.3s ease;
}

#modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

#modal-container {
  z-index: 9998;
  width: 60vw;
  min-width: 350px;
  max-width: 1000px;
  margin: 0px auto;
  padding: 20px 30px;
  background-color: #fff;
  border-radius: 2px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
  font-family: Helvetica, Arial, sans-serif;
  max-height: 100vh;
  overflow-y: auto;
}
@media screen and (max-width: 900px) {
  #modal-container {
    width: 100vw;
  }
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter {
  opacity: 0;
}

.modal-leave-active {
  opacity: 0;
}

.modal-enter #modal-container,
.modal-leave-active #modal-container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>