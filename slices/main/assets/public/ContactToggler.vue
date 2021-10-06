<template>
  <div>
    <p class="card-text" v-if="!clicked">
      <a href="#" v-on:click="toggleClicked" class="btn btn-outline-primary">
        <i class="fas fa-address-card"></i>
        Kontaktdaten anzeigen
      </a>
    </p>
    <template v-else>
      <div>
        <p v-if="robot" class="card-text">
          <strong>Kontakt:</strong>
          <br>
          <span v-html="contact"></span>
        </p>
        <vue-recaptcha v-else
                      ref="recaptcha"
                      @verify="onVerify"
                      sitekey="6LdVv6scAAAAAMHE9Qv0PJBWYNqUApXymde2q3q-"
                      :loadRecaptchaScript="true">
        </vue-recaptcha>
      </div>
    </template>
  </div>
</template>

<script>
import VueRecaptcha from 'vue-recaptcha'
import marked from 'marked'

export default {
  data() {
    return {
      robot: false,
      clicked: false,
      contact: undefined,
    }
  },
  props: {
    cardId: {
      type: Number,
      required: true,
    }
  },
  components: {
    VueRecaptcha,
  },
  methods: {
    onVerify(response) {
      if (response) this.robot = true;

      fetch(`karte/${this.cardId}/kontaktdaten`, { headers: {
        'Content-Type': 'application/json'
      }})
        .then(response => response.json())
        .then(data => this.contact = marked(data, { breaks: true }))

      this.$refs.recaptcha.reset()
    },
    toggleClicked(event) {
      event.preventDefault()
      this.clicked = !this.clicked
    },
  }
}
</script>
