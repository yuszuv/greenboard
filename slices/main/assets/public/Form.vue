<template>
  <div class="d-flex justify-content-center flex-column align-items-center">
    <b-spinner v-if="loading" label="Loading..." variant="primary" :class="{ 'form-loading': loading }"></b-spinner>
    <b-form @submit="onSubmit" class="d-inline-block mx-5" :class="{ 'form-loading': loading }">
      <div class="alert alert-info">
        <p>Das <strong class="londrina">Grüne Brett</strong> soll dazu dienen, Kontakte zu vermitteln. Es soll in etwa so funktionieren wie die Suche-Biete-Bretter im Supermarkt o.ä. Also einfach ein Gesuch oder ein Angebot einstellen, Kontaktdaten angeben und gucken, ob sich wer meldet.</p>
        <p>Das ist hier kein kommerzielles Angebot und es hakt bestimmt noch an der ein oder
          anderen Stelle. In diesem Fall bitte eine <a href="mailto:j.paki@lpv-prignitz-ruppin.de"><i class="fas fa-envelope"></i> Email</a> schreiben</p>
      </div>

      <b-alert
        :show="Object.keys(errors).length > 0"
        variant="danger"
        >
        <ul>
          <li v-for="error in errors">{{ error.join(" ") }}</li>
        </ul>
      </b-alert>
      <div class="input-group align-items-center">
        <div class="input-group-prepend">
          <b-button-group class="my-2 mr-2">
            <b-button @click="setType('SUCHE')" :variant="(form.type) == 'SUCHE' ? 'danger' : ''">SUCHE</b-button>
            <b-button @click="setType('BIETE')":variant="(form.type) == 'BIETE' ? 'success' : ''">BIETE</b-button>
          </b-button-group>
        </div>
        <b-form-input
          id="topic"
          v-model="form.topic"
          :class="errorClass('topic')"
          placeholder="Überschrift"
          @blur="resetError('topic')"
          ></b-form-input>
      </div>


      <b-form-group
        <b-form-textarea
          id="text"
          v-model="form.text"
          placeholder="Text"
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
          placeholder="Kontaktdaten
Name, Telefonnummer, Email-Adresse o.ä."
          :class="errorClass('contact')"
          @blur="resetError('contact')"
          rows="3"></b-form-textarea>
        <small class="form-text">Diese Daten sind später nach Lösen eines sog. <a
               href="https://de.wikipedia.org/wiki/Captcha" target="_blank"><em><i class="fas fa-external-link-alt fa-sm"></i> Captchas</em></a> öffentlich einsehbar</small>
      </b-form-group>
      <b-form-group
        label="Bilder anhängen">
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

      <b-form-group>
        <b-form-input
          type="password"
          name="password"
          :placeholder="form.id ? 'Passwort ändern' : 'Passwort'"
          v-model="form.password"
          :class="errorClass('password')"
          @blur="resetError('password')"
          ></b-form-input>
      </b-form-group>
      <b-form-group>
        <b-form-input
          type="password"
          name="password-confirmation"
          placeholder="Passwort bestätigen"
          v-model="form.password_confirmation"
          :class="errorClass('password_confirmation')"
          @blur="resetError('password_confirmation')"
          ></b-form-input>
        <small class="form-text">Mit diesem Passwort kann der Beitrag später bearbeitet oder gelöscht werden. Merken (lassen)!</small>
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
      form: this.initialForm,
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
  props: {
    wasValidated: {
      type: Boolean,
    },
    initialForm: {
      type: Object,
    },
    errors: {
      type: Object,
    },
    loading: {
      type: Boolean,
      default: true,
    }
  },
  components: {
    TosModal,
    vueDropzone,
  },
  methods: {
    onSubmit(event) {
      event.preventDefault()
      this.$emit('submit', this.form)
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
    setType(type) {
      this.form.type = type
    },
  }
}
</script>

<style>
.form-group > legend, .form-group > label {
  font-weight: bold;
}

form.form-loading {
  opacity: 0.3;
}

.spinner-border.form-loading {
  position: absolute;
}
</style>
