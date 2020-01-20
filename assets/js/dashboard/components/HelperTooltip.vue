<template>
  <div id="helper-tooltip-container">
    <div id="tooltip-wrapper">
      <i class="gg-info" @mouseover="visible = true" @mouseleave="visible = false" />
      <transition :name="transition">
        <div id="tooltip" v-if="visible" v-bind:style="hoverPosition">
          <div id="tooltip-content">
            <slot />
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    transition: {
      type: String,
      default: "bounce",
      required: false
    },
    hPosition: {
      type: String,
      default: "right",
      required: false
    },
    vPosition: {
      type: String,
      default: "bottom",
      required: false
    }
  },
  data: function() {
    return {
      visible: false
    };
  },
  computed: {
    hoverPosition: function() {
      var style = {};
      switch (this.hPosition) {
        case "right":
          Object.assign(style, { left: "0%" });
          break;

        case "left":
          Object.assign(style, { right: "0%" });
          break;
      }
      switch (this.vPosition) {
        case "bottom":
          Object.assign(style, { top: "120%" });
          break;

        case "top":
          Object.assign(style, { bottom: "120%" });
          break;
      }
      return style;
    }
  }
};
</script>

<style scoped>
/* TOOLTIP */

#helper-tooltip-container {
  margin: auto;
}

i {
  z-index: 500;
}

#tooltip-wrapper {
  position: relative;
}

#tooltip {
  z-index: 501;
  border: 1px solid lightgray;
  border-radius: 3px;
  background-color: white;
  min-width: 150px;
  max-width: 100vw;
  max-height: 300px;
  position: absolute;
  padding: 10px;
}

#tooltip-content {
  font-size: 12px;
  font-style: italic;
}

/* ICON */
.gg-info {
  box-sizing: border-box;
  position: relative;
  display: block;
  transform: scale(var(--ggs, 1));
  width: 20px;
  height: 20px;
  border: 2px solid;
  border-radius: 40px;
}
.gg-info::after,
.gg-info::before {
  content: "";
  display: block;
  box-sizing: border-box;
  position: absolute;
  border-radius: 3px;
  width: 2px;
  background: currentColor;
  left: 7px;
}
.gg-info::after {
  bottom: 2px;
  height: 8px;
}
.gg-info::before {
  height: 2px;
  top: 2px;
}

/* ANIMATION */
.fade-enter-active {
  transition: opacity 0.3s;
}

.fade-leave-active {
  transition: opacity 0.3s;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}

.bounce-enter-active {
  animation: bounce-in 0.3s;
}
.bounce-leave-active {
  animation: bounce-in 0.3s reverse;
}
@keyframes bounce-in {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}
</style>
