<template lang="pug">
div
  .row.mb-3.d-flex.justify-content-center
    add-button(@init-build="onInitBuild")
    subscribe-button

  .row.mb-3
    .col-md-6.d-flex.flex-column
      card(
        v-for="card in requests"
        :key="card.id"
        v-bind="card"
        @init-edit="onInitEdit"
        @init-delete="onInitDelete"
      )
    .col-md-6.d-flex.flex-column
      card(
        v-for="card in offers"
        :key="card.id"
        v-bind="card"
        @init-edit="onInitEdit"
        @init-delete="onInitDelete"
      )
  build-form(@create="onCreate")
  edit-form(:id="currentCardId" @update="onUpdate")
  delete-form(:id="currentCardId" @delete="onDelete")
</template>

<script>
import axios from 'axios'

import AddButton from './AddButton.vue'
import SubscribeButton from './SubscribeButton.vue'

import Card from './Card.vue'
import BuildForm from './BuildForm.vue'
import EditForm from './EditForm.vue'
import DeleteForm from './DeleteForm.vue'

export default {
  data() {
    return {
      loading: false,
      success: false,
      error: false,
      cards: [],
      currentCardId: null,
    }
  },
  computed: {
    requests() {
      return this.cards.filter(c => c.type == 'SUCHE')
    },
    offers() {
      return this.cards.filter(c => c.type == 'BIETE')
    },
  },
  components: {
    Card,
    AddButton,
    SubscribeButton,
    BuildForm,
    EditForm,
    DeleteForm,
  },
  methods: {
    onInitBuild() {
      this.$bvModal.show("build-modal")
    },
    onInitEdit(id) {
      this.currentCardId = id
      this.$bvModal.show('edit-modal')
    },
    onInitDelete(id) {
      console.log('init delete')
      this.currentCardId = id
      this.$bvModal.show('delete-modal')
    },
    onUpdate() {
      this.$bvModal.hide('edit-modal')
    },
    onCreate() {
      this.$bvModal.hide('build-modal')
    },
    onDelete() {
      this.$bvModal.hide('delete-modal')
    },
  },
  mounted() {
    this.loading = true
    axios.get('/api/cards')
      .then(res => {
        this.cards = res.data
        this.success = true
      })
      .catch(e => {
        this.error = true
      })
      .finally(res => {
        this.loading = false
      })
  },
}
</script>
