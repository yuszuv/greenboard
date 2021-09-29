<template>
  <div>
    <vue-dropzone ref="dropzone" id="dropzone"
      @vdropzone-success="vsuccess"
      @vdropzone-error="verror"
      @vdropzone-sending="vsending"
      @vdropzone-total-upload-progress="vprogress"
      :options="dropzoneOptions"
      :duplicateCheck="true">
    </vue-dropzone>
    <ul>
      <li v-for="image in images">
        <input type="hidden" name="images[]" :value=JSON.stringify(image)>
        <img :src="'uploads/' + image.derivatives.thumbnail.id" >
      </li>
    </ul>
  </div>
</template>

<script>
import vueDropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'

export default {
  data() {
    return {
      images: window.images.map(x => JSON.parse(x)),
      dropzoneOptions: {
        url: '/anhaengen',
        createImageThumbnails: true,
        addRemoveLinks: true,
        thumbnailWidth: 150,
        thumbnailHeight: 150,
        dictDefaultMessage: "Bilder anhängen (drag'n'drop oder Klick)",
        maxFilesize: 2.0,
        //addRemoveLinks: true
      },
      progress: false,
      myProgress: 0,
    }
  },
  components: {
    vueDropzone
  },
  methods: {
    vsending(file, xhr, formData) {
      formData.append("_csrf_token", document.head.querySelector("[name=csrf-token]").content);
    },

    vsuccess(file, response) {
      this.images = [ ...this.images, response ]
      this.$refs.dropzone.removeFile(file)
    },
    vprogress(totalProgress, totalBytes, totalBytesSent) {
      this.progress = true
      this.myProgress = Math.floor(totalProgress)
    },
  },
}
</script>
