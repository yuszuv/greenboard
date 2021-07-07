<template>
  <div>
    <div>
      <div>
        <div>
          <div>Example Component</div>
          <div>
            I'm an example component.
            <ul>
              <li v-for="image in images">{{ image.foo }}</li>
            </ul>
            <vue-dropzone ref="myVueDropzone" id="dropzone" :options="dropzoneOptions"></vue-dropzone>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import vue2Dropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'
export default {
  components: {
    vueDropzone: vue2Dropzone
  },

  data: function () {
    return {
      images: [
        { foo: 'bar' }
      ],
      dropzoneOptions: {
        url: '/anhaengen',
        init: function() {
          this.on("sending", (file, xhr, formData) => {
            formData.append("_csrf_token", document.head.querySelector("[name=csrf-token]").content);
          });
          this.on('success', (file, response) => {
            console.log(this);
          })
        }
      }
    }
  },

  mounted() {
    console.log('Component mounted.')
  }
}
</script>
