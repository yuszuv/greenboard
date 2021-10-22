<template lang="pug">
b-form.d-inline-block(@submit='onSubmit' :class="{ 'form-loading': loading }")
  .spinner-wrapper.d-flex.justify-content-center.mb-3(v-if='loading')
    b-spinner(label='Loading...')
  .alert.alert-info
    p Das #[strong.londrina Gr&uuml;ne Brett] soll dazu dienen, Kontakte zu vermitteln. Es soll in etwa so funktionieren wie die Suche-Biete-Bretter im Supermarkt o.&auml;. Also einfach ein Gesuch oder ein Angebot einstellen, Kontaktdaten angeben und gucken, ob sich wer meldet.
    p Das ist hier kein kommerzielles Angebot und es hakt bestimmt noch an der ein oder anderen Stelle. In diesem Fall bitte eine #[a(href='mailto:j.paki@lpv-prignitz-ruppin.de') #[i.fas.fa-envelope] Email] schreiben

  b-alert(:show='Object.keys(errors).length > 0' variant='danger')
    ul
      li(v-for='error in errors') {{ error.join(&quot; &quot;) }}

  .input-group.align-items-center
    .input-group-prepend
      b-button-group.my-2.mr-2
        b-button(@click="setType('SUCHE')" :variant="(form.type) == 'SUCHE' ? 'danger' : ''") SUCHE
        b-button(@click="setType('BIETE')" :variant="(form.type) == 'BIETE' ? 'success' : ''") BIETE
    b-form-input#topic(v-model='form.topic' :class="errorClass('topic')" placeholder='Überschrift' @blur="resetError('topic')")

  b-form-group
    b-form-textarea(v-model='form.text' placeholder='Text' :class="errorClass('text')" @blur="resetError('text')" rows='3')
    small.form-text Textformatierungen mit #[a(href='https://www.markdownguide.org/' target='_blank') #[i.fas.fa-external-link-alt.fa-sm] Markdown]

  b-form-group(label='Kontaktdaten' label-for='contact')
    b-form-textarea#contact(v-model='form.contact' placeholder='Kontaktdaten\
Name, Telefonnummer, Email-Adresse o.ä.' :class="errorClass('contact')" @blur="resetError('contact')" rows='3')
    small.form-text Diese Daten sind sp&auml;ter nach L&ouml;sen eines sog.  #[a(href='https://de.wikipedia.org/wiki/Captcha' target='_blank') #[em #[i.fas.fa-external-link-alt.fa-sm] Captchas]] &ouml;ffentlich einsehbar


  b-form-group(label='Bilder anhängen')
    vue-dropzone#dropzone(ref='dropzone' @vdropzone-success='addImage' @vdropzone-total-upload-progress='vprogress' :options='dropzoneOptions' :duplicatecheck='true')
    .alert.alert-info.my-2 Maximale Dateigr&ouml;&szlig;e: 5MB
    .d-flex.flex-wrap.image-list
      .m-3(v-for='image in form.images')
        a.btn-remove-image(v-on:click='removeImage(image)'): i.fas.fa-times-circle.rounded-circle
        input(v-if='image.id' type='hidden' name='images[][id]' :value='image.id')
        input(type='hidden' name='images[][image_data]' :value='JSON.stringify(image.image_data)')
        img(:src="'/uploads/' + image.image_data.derivatives.thumbnail.id")

  b-form-group
    b-form-input(type='password' name='password' :placeholder="form.id ? 'Passwort ändern' : 'Passwort'" v-model='form.password' :class="errorClass('password')" @blur="resetError('password')")
  b-form-group
    b-form-input(type='password' name='password-confirmation' placeholder='Passwort bestätigen' v-model='form.password_confirmation' :class="errorClass('password_confirmation')" @blur="resetError('password_confirmation')")
    small.form-text
      | Mit diesem Passwort kann der Beitrag sp&auml;ter bearbeitet oder gel&ouml;scht werden. Merken (lassen)!
  b-form-group(label='Nutzungsbedingungen' label-for='tos')
    b-form-checkbox#tos(v-model='form.tos' name='tos' :state="checkBoxState('tos')" @change="resetError('tos')")
      | Ich habe die 
      a(href='#' v-on:click='$event.preventDefault()' v-b-modal.tos-modal='') Nutzungsbedingungen
      |  gelesen und akzeptiert
  b-button(type='submit' variant='primary') Abschicken
  tos-modal
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
        createImageThumbnails: false,
        addRemoveLinks: true,
        disablePreviews: true,
        thumbnailWidth: 50,
        thumbnailHeight: 50,
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
        return 'is-valid';
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
</style>
