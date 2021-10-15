<template>
  <div>
    <a v-b-modal.subscribe-modal class="btn btn-warning" href="#">
      <i class="fas fa-bullhorn"></i>
      Updates abonnieren
    </a>
    <b-modal id="subscribe-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Bei neuen Einträgen benachrichtigen lassen
      </template>

      <div v-if="!success" class="d-flex justify-content-center flex-column align-items-center">
        <b-spinner v-if="loading" label="Loading..." variant="primary" :class="{ 'form-loading': loading }"></b-spinner>
        <b-form @submit.prevent="onSubmit" class="d-inline-block mx-5" :class="{ 'form-loading': loading }">
          <b-form-group
            label="E-Mail-Addresse:"
            label-for="subscribe-email"
            >
            <b-form-input
              id="subscribe-email"
              v-model="form.email"
              type="email"
              autofocus
              required
              ></b-form-input>
            <small class="form-text text-muted">
              Wir geben die Adresse <em>niemals</em> weiter
            </small>
          </b-form-group>

          <b-form-group
            label="Nutzungsbedingungen"
            label-for="subscribe-tos">
            <b-form-checkbox
              id="subscribe-tos"
              v-model="form.tos"
              name="subscribe-tos"
              :state="validationState('tos')"
              @change="resetErrors()"
              >
              Ich habe die <a href="#" @click.prevent="$bvModal.show('tos-modal')" v-b-modal.tos-modal>Nutzungsbedingungen</a> gelesen und akzeptiert
            </b-form-checkbox>
          </b-form-group>

          <b-button type="submit" variant="primary">Abonnieren</b-button>
          <b-button variant="danger" @click.prevent="$bvModal.hide('subscribe-modal')">Schließen</b-button>

          <tos-modal></tos-modal>
        </b-form>
      </div>

      <div v-else>
        <h4><i class="fas fa-envelope"></i> Bestätigungs-Mail versendet</h4>
        <p>Vielen Dank für deine Eintragung. Wir haben gerade eine Email geschickt, mit der sie noch
        bestätigen musst.</p>
        <b-button variant="primary" @click.prevent="$bvModal.hide('subscribe-modal')">Schließen</b-button>
      </div>
    </b-modal>
  </div>

</template>

<script>
//import CreateForm from "./CreateForm.vue"
import axios from 'axios'

import TosModal from './TosModal.vue'

export default {
  data() {
    return {
      loading: false,
      errors: {},
      success: false,
      form: {
        email: '',
        tos: false,
      },
    }
  },
  computed: {
    error() {
      return Object.keys(this.errors).length !== 0
    },
  },
  components: {
    TosModal,
  },
  methods: {
    onSubmit() {
      this.loading = true
      this.resetErrors()
      axios.post('/api/subscribe_updates', this.form)
        .then(res => {
          this.success = true
        })
        .catch(res => {
          this.errors = res.response.data
        })
        .finally(() => {
          this.loading = false
        })
    },
    resetErrors() {
      this.errors = {}
    },
    validationState(key) {
      if (this.loading == false && (key in this.errors)) {
        return false
      } else if (this.success) {
        return true
      } else {
        return null
      }
    },
  }
}
</script>
