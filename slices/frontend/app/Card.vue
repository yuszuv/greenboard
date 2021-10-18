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
    .card-text {{ text }}

  .card-body
    .card-gallery-list.d-flex.justify-content-center
      figure(v-for="image in images")
        a(:href="image.url" :data-size="`${image.width}x${image.height}`")
          img.img-thumbnail.m-2(:src="image.thumbnail_url" :data-src="image.url" itemprop="thumbnail")

  .card-body
    p.card-text
      contact-toggler(:cardId="id")
</template>

<script>
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
    onInitEdit(_id) {
      this.$emit('init-edit', this.id)
    },
    onInitDelete(_id) {
      this.$emit('init-delete', this.id)
    },
  },
}
</script>
