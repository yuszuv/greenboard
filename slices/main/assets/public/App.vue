<template>
  <div>
    <vue-dropzone ref="dropzone" id="dropzone"
      @vdropzone-success="vsuccess"
      @vdropzone-sending="vsending"
      @vdropzone-total-upload-progress="vprogress"
      :options="dropzoneOptions"
      :duplicateCheck="true">
    </vue-dropzone>
    <div class="alert alert-info my-2">Maximale Dateigröße: 5MB</div>

    <div class="d-flex">
      <div v-for="image in images" class="image-list m-3">
        <a class="btn-remove-image" v-on:click="removeImage(image)">
          <i class="fas fa-times-circle rounded-circle"></i>
        </a>
        <input v-if=image.id type="hidden" name="images[][id]" :value=image.id>
        <input type="hidden" name="images[][image_data]" :value=JSON.stringify(image.image_data)>
        <img :src="'/uploads/' + image.image_data.derivatives.thumbnail.id" >
      </div>
    </div>
  </div>
</template>

<script>
import vueDropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'

export default {
  data() {
    return {
      images: window.images,
      dropzoneOptions: {
        url: '/anhaengen',
        createImageThumbnails: true,
        addRemoveLinks: true,
        thumbnailWidth: 150,
        thumbnailHeight: 150,
        dictDefaultMessage: "Bilder anhängen (drag'n'drop oder Klick)",
        maxFilesize: 5.0,
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
      console.log(response)
      this.images = [ ...this.images, { "image_data": response } ]
      this.$refs.dropzone.removeFile(file)
    },
    vprogress(totalProgress, totalBytes, totalBytesSent) {
      this.progress = true
      this.myProgress = Math.floor(totalProgress)
    },
    removeImage(image) {
      var index = this.images.indexOf(image);
      this.images.splice(index, 1);
    },
  },
}
</script>
