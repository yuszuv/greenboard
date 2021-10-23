<template lang="pug">
.card.shadow.mb-4
  .card-header
    .d-flex.justify-content-between.align-items-center
      div
        h5.me-auto
          span.badge.mr-2(:class="typeClass") {{ type }}
          span.align-middle {{ topic }}
      div
        .dropdown.dropleft
          button.btn.btn-link.text-dark(aria-expanded="false" aria-haspopup="true"
          data-toggle="dropdown" type="button")
            i.fas.fa-ellipsis-v
          .dropdown-menu
            edit-link(:id="id" @init-edit="onInitEdit")
            delete-link(:id="id" @init-delete="onInitDelete")

  .card-body
    .card-text(v-html="markdown(text)")

    photoswipe.py-2(v-if="images.length > 0")
      .card-gallery.d-flex.flex-wrap
        figure.mr-3(v-for="image in images")
          img.img-thumbnail(:src="image.thumbnail_url" v-pswp="{ src: image.url, size: `${image.width}x${image.height}` }" )
          //a(@click.stop :href="image.url" :data-size="`${image.width}x${image.height}`")

    .card-text
      contact-toggler(:cardId="id")
</template>

<script>
import marked from 'marked'

import DeleteLink from './DeleteLink.vue'
import EditLink from './EditLink.vue'
import ContactToggler from './ContactToggler.vue'

export default {
  data() {
    return {
      contact: '',
    }
  },
  props: {
    id: {
      type: String,
    },
    type: {
      type: String,
    },
    topic: {
      type: String,
    },
    text: {
      type: String,
    },
    images: {
      type: Array,
    },

  },
  computed: {
    typeClass() {
      return this.type == 'BIETE' ? 'badge-success' : 'badge-danger'
    },
  },
  components: {
    ContactToggler,
    DeleteLink,
    EditLink,
  },
  methods: {
    markdown(str) {
      return marked(str, { breaks: true })
    },
    onInitEdit(_id) {
      this.$emit('init-edit', this.id)
    },
    onInitDelete(_id) {
      this.$emit('init-delete', this.id)
    },
  },
}
</script>
