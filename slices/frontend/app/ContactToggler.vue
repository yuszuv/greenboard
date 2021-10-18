<template lang="pug">
div
  p.card-text(v-if='!robot')
    strong Kontakt:
    br
    span(v-html='contact')

  a.btn.btn-info.shadow(href='#' v-if='!clicked' @click.prevent='clicked = true') #[i.fas.fa-address-card.mr-2] Kontaktdaten anzeigen
  vue-recaptcha(
    v-if='clicked && robot'
    ref='recaptcha'
    sitekey='6LdVv6scAAAAAMHE9Qv0PJBWYNqUApXymde2q3q-'
    :loadRecaptchaScript='true'
    @verify='onVerify'
  )
</template>

<script>
import VueRecaptcha from 'vue-recaptcha'
import marked from 'marked'
import axios from 'axios'

export default {
  data() {
    return {
      robot: true,
      clicked: false,
      contact: undefined,
    }
  },
  props: {
    cardId: {
      type: String,
      required: true,
    }
  },
  components: {
    VueRecaptcha,
  },
  methods: {
    onVerify(response) {
      if (response) this.robot = false;

      axios.get(`/api/cards/${this.cardId}/contact_data`)
        .then(res => {
          this.contact = marked(res.data, { breaks: true })
          this.robot = false
        })

      this.$refs.recaptcha.reset()
    },
  }
}
</script>
