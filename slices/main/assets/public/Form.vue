<template>
  <div>
    <b-alert
      :show="Object.keys(errors).length > 0"
      variant="danger"
    >
    <ul>
      <li v-for="error in errors">{{ error.join(" ") }}</li>
    </ul>
    </b-alert>
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

      <b-form-group>
        <vue-dropzone ref="dropzone" id="dropzone"
                                     @vdropzone-success="addImage"
                                     @vdropzone-total-upload-progress="vprogress"
                                     :options="dropzoneOptions"
                                     :duplicateCheck="true">
        </vue-dropzone>
        <div class="alert alert-info my-2">Maximale Dateigröße: 5MB</div>

        <div class="d-flex">
          <div v-for="image in form.images" class="image-list m-3">
            <a class="btn-remove-image" v-on:click="removeImage(image)">
              <i class="fas fa-times-circle rounded-circle"></i>
            </a>
            <input v-if=image.id type="hidden" name="images[][id]" :value=image.id>
            <input type="hidden" name="images[][image_data]" :value=JSON.stringify(image.image_data)>
            <img :src="'/uploads/' + image.image_data.derivatives.thumbnail.id" >
          </div>
        </div>
      </b-form-group>

      <b-form-group
        label="Passwort"
        label-for="password">
        <b-form-input
          type="password"
          name="password"
          v-model="form.password"
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
          v-model="form.password_confirmation"
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
          @change="resetError('tos')"
          >

          Ich habe die <a href="#" v-on:click="$event.preventDefault()" v-b-modal.tos-modal>Nutzungsbedingungen</a> gelesen und akzeptiert
        </b-form-checkbox>
      </b-form-group>

      <b-button type="submit" variant="primary">Abschicken</b-button>

      <tos-modal></tos-modal>

    </b-form>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import vueDropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'

import TosModal from './TosModal.vue'

export default {
  data() {
    return {
      authorized: false,
      form: {
        type: 'SUCHE',
        topic: '',
        text: '',
        contact: '',
        images: [],
        password: '',
        password_confirmation: '',
        tos: false,
      },
      errors: {},
      wasValidated: false,
      dropzoneOptions: {
        url: '/api/images',
        createImageThumbnails: true,
        addRemoveLinks: true,
        thumbnailWidth: 150,
        thumbnailHeight: 150,
        dictDefaultMessage: "Bilder anhängen (drag'n'drop oder Klick)",
        maxFilesize: 5.0,
      },
      progress: false,
      myProgress: 0,
    }
  },
  components: {
    TosModal,
    vueDropzone,
  },
  methods: {
    onSubmit(event) {
      event.preventDefault()
      axios.post('/api/cards', this.form)
        .then(response => {
          this.wasValidated = true
          location.assign("/")
        })
        .catch(e => {
          console.log(e.response.data)
          this.errors = e.response.data
          this.wasValidated = true
          window.scrollTo(0,0)
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
    addImage(file, response) {
      this.form.images = [ ...this.form.images, { "image_data": response } ]
      this.$refs.dropzone.removeFile(file)
    },
    vprogress(totalProgress, totalBytes, totalBytesSent) {
      this.progress = true
      this.myProgress = Math.floor(totalProgress)
    },
    removeImage(image) {
      var index = this.form.images.indexOf(image);
      this.form.images.splice(index, 1);
    },
  }
}
</script>
