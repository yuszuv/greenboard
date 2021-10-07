<template>
  <b-form @submit="onSubmit">
    <b-form-checkbox
      v-model="form.type"
      name="type"
      value="BIETE"
      unchecked-value="SUCHE"
      switch>
      <b-badge class="badge-type" :variant="(form.type == 'SUCHE') ? 'danger' : 'success'">{{ form.type }}</b-badge>
    </b-form-checkbox>

    <b-form-group
      label="Überschrift"
      label-for="topic">
      <b-form-input
        id="topic"
        v-model="form.topic"
        :class="errorClass('topic')"
        @blur="resetError('topic')"
        ></b-form-input>
    </b-form-group>

    <b-form-group
      label="Text"
      label-for="text">
      <b-form-textarea
        id="text"
        v-model="form.text"
        placeholder="..."
        :class="errorClass('text')"
        @blur="resetError('text')"
        rows="3"></b-form-textarea>
      <small class="form-text">Textformatierungen mit <a href='https://www.markdownguide.org/'
             target='_blank'><i class="fas fa-external-link-alt fa-sm"></i> Markdown</a></small>
    </b-form-group>

    <b-form-group
      label="Kontaktdaten"
      label-for="contact">
      <b-form-textarea
        id="contact"
        v-model="form.contact"
        placeholder="Name, Telefonnummer, Email-Adresse o.ä."
        :class="errorClass('contact')"
        @blur="resetError('contact')"
        rows="3"></b-form-textarea>
      <small class="form-text">Diese Daten sind später nach Lösen eines sog. <a
             href="https://de.wikipedia.org/wiki/Captcha" target="_blank"><em><i class="fas fa-external-link-alt fa-sm"></i> Captchas</em></a> öffentlich einsehbar</small>
    </b-form-group>

    <b-form-group
      label="Passwort"
      label-for="password">
      <b-form-input
        type="password"
        name="password"
        :class="errorClass('password')"
        @blur="resetError('password')"
        ></b-form-input>
    </b-form-group>
    <b-form-group
      label="Passwort bestätigen"
      label-for="password-confirmation">
      <b-form-input
        type="password"
        name="password-confirmation"
        :class="errorClass('password_confirmation')"
        @blur="resetError('password_confirmation')"
        ></b-form-input>
      <small class="form-text">Damit kann der Beitrag später bearbeitet oder gelöscht werden. Merken (lassen)!</small>
    </b-form-group>

    <b-form-group
      label="Nutzungsbedingungen"
      label-for="tos">
      <b-form-checkbox
        id="tos"
        v-model="form.tos"
        name="tos"
        :state="checkBoxState('tos')"
        @blur="resetError('tos')"
        >

        Ich habe die <a href="#" v-b-modal.tos-modal>Nutzungsbedingungen</a> gelesen und akzeptiert
      </b-form-checkbox>
    </b-form-group>

    <b-button type="submit" variant="primary">Abschicken</b-button>

    <tos-modal></tos-modal>

  </b-form>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'

import TosModal from './TosModal.vue'

export default {
  data() {
    return {
      form: {
        type: 'SUCHE',
        topic: '',
        text: '',
        contact: '',
        password: '',
        passwordConfirmation: '',
        tos: false,
      },
      errors: {},
      wasValidated: false,
    }
  },
  components: {
    TosModal,
  },
  methods: {
    onSubmit(event) {
      event.preventDefault()
      axios.post('/api/cards', this.form)
        .then(response => {
          this.wasValidated = true
          // JSON responses are automatically parsed.
          //this.posts = response.data
          console.log(response.data)
        })
        .catch(e => {
          console.log(e.response.data)
          this.errors = e.response.data
          this.wasValidated = true
        })
    },
    errorClass(key) {
      if (key in this.errors) {
        return 'is-invalid';
      } else if (this.wasValidated) {
        return 'in-valid';
      } else {
        return null;
      }
    },
    checkBoxState(key) {
      if (this.errorClass(key) == 'is-invalid') {
        return false
      } else if (this.wasValidated) {
        return true
      } else {
        return null
      }
    },
    resetError(key) {
      Vue.delete(this.errors, key)
    },
  }
}
</script>
