<template>
  <div>
    <b-form @submit="onSubmit">
      <b-form-group
        label="Angebot/Gesuch:"
        label-for="type"
      >
        <b-form-checkbox
          v-model="form.type"
          name="type"
          value="BIETE"
          unchecked-value="SUCHE"
          switch>
          <b-badge class="badge-type" :variant="(form.type == 'SUCHE') ? 'danger' : 'success'">{{ form.type }}</b-badge>
        </b-form-checkbox>
      </b-form-group>

      <b-form-group
        label="Überschrift"
        label-for="topic">
        <b-form-input
          id="topic"
          v-model="form.topic"
          ></b-form-input>
      </b-form-group>

      <b-form-group
        label="Text"
        label-for="text">
        <b-form-textarea
          id="text"
          v-model="form.text"
          placeholder="..."
          rows="3"></b-form-textarea>
        <small class="form-text">Textformatierungen mit <a href='https://www.markdownguide.org/'
               target='_blank'><i class="fas fa-external-link-alt fa-sm"></i> Markdown</a></small>
      </b-form-group>

      <b-form-group
        label="Kontaktdaten"
        label-for="contact">
        <b-form-textarea
          id="contact"
          v-model="form.text"
          placeholder="Name, Telefonnummer, Email-Adresse o.ä."
          rows="3"></b-form-textarea>
        <small class="form-text">Diese Daten sind später nach Lösen eines sog. <a
               href="https://de.wikipedia.org/wiki/Captcha" target="_blank"><em><i class="fas fa-external-link-alt fa-sm"></i> Captchas</em></a> öffentlich einsehbar</small>
      </b-form-group>

      <b-form-group
        label="Passwort"
        label-for="password">
        <b-form-input
          type="password"
          name="password"></b-form-input>
      </b-form-group>
      <b-form-group
        label="Passwort bestätigen"
        label-for="password-confirmation">
        <b-form-input
          type="password"
          name="password-confirmation"></b-form-input>
        <small class="form-text">Damit kann der Beitrag später bearbeitet oder gelöscht werden. Merken (lassen)!</small>
      </b-form-group>

      <b-form-group
        label="Nutzungsbedingungen"
        label-for="tos">
        <b-form-checkbox
          id="tos"
          v-model="form.tos"
          name="tos"
          >
          Ich habe die <a href="#" data-bs-toggle="modal" data-bs-target="#modal">Nutzungsbedingungen</a> gelesen und akzeptiert
        </b-form-checkbox>
      </b-form-group>

      <b-button type="submit" variant="primary">Submit</b-button>
      <b-button type="reset" variant="danger">Reset</b-button>
    </b-form>
    <b-card class="mt-3" header="Form Data Result">
      <pre class="m-0">{{ form }}</pre>
    </b-card>
  </div>
</template>

<script>
import axios from 'axios'

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
    }
  },
  methods: {
    onSubmit(event) {
      event.preventDefault()
      axios.post('/api/cards')
        .then(response => {
          // JSON responses are automatically parsed.
          //this.posts = response.data
          console.log(response.data)
        })
        .catch(e => {
          this.errors.push(e)
        })
    },
  }
}
</script>
