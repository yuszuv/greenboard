<template lang="pug">
div
  .row.mb-3
    #buttons.col-md-12.d-flex.justify-content-center
      add-button(@init-build="onInitBuild")
      subscribe-button(@init-subscribe="onInitSubscribe")

  .row.mb-3
    .col-md-6.d-flex.flex-column
      transition-group(v-if="cards.length > 0" name="cards")
        card(
          v-for="card in requests"
          v-bind="card"
          :key="cardKey(card)"
          @init-edit="onInitEdit"
          @init-delete="onInitDelete"
        )
    .col-md-6.d-flex.flex-column
      transition-group(v-if="cards.length > 0" name="cards")
        card(
          v-for="card in offers"
          v-bind="card"
          :key="cardKey(card)"
          @init-edit="onInitEdit"
          @init-delete="onInitDelete"
        )
  build-form(@create="onCreate")
  edit-form(:id="currentCardId" @update="onUpdate")
  delete-form(:id="currentCardId" @delete="onDelete")
  subscribe-form

</template>

<script>
import axios from 'axios'
import marked from 'marked'

import AddButton from './AddButton.vue'
import SubscribeButton from './SubscribeButton.vue'

import Card from './Card.vue'
import BuildForm from './BuildForm.vue'
import EditForm from './EditForm.vue'
import DeleteForm from './DeleteForm.vue'
import SubscribeForm from './SubscribeForm.vue'
import TosModal from './TosModal.vue'

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
    SubscribeForm,
    TosModal,
  },
  methods: {
    cardKey(card) {
      return card.id.toString() + card.timestamp.toString()
    },
    onInitBuild() {
      this.$bvModal.show("build-modal")
    },
    onInitEdit(id) {
      this.currentCardId = id
      this.$bvModal.show('edit-modal')
    },
    onInitDelete(id) {
      this.currentCardId = id
      this.$bvModal.show('delete-modal')
    },
    onInitSubscribe() {
      this.$bvModal.show('subscribe-modal')
    },
    onUpdate(id) {
      this.$bvModal.hide('edit-modal')
      this.updateCard(id)
    },
    onCreate(id) {
      this.$bvModal.hide('build-modal')
      this.updateCard(id)
    },
    onDelete(id) {
      this.$bvModal.hide('delete-modal')
      this.updateCard(id)
    },
    onSubscribe() {
      this.$bvModal.hide('subscribe-modal')
    },
    updateCard(id) {
      this.loading = true
      this.success = false

      let res = axios.get('/api/cards')
        .then(res => {
          const cards = res.data
          const card = cards.find(card => card.id === id)

          if (card) {
            const idx = this.cards.findIndex(c => c.id === card.id)

            if (idx >= 0) {
              this.cards.splice(idx, 1, card)
            } else {
              this.cards = [card, ...this.cards]
            }
          } else {
            const idx = this.cards.findIndex(c => c.id === id)

            this.cards.splice(idx, 1)
          }

          this.success = true
        })
        .catch(e => {
          this.error = true
        })
        .finally(res => {
          this.loading = false
        })

      return res
    },
    initCards() {
      this.loading = true
      this.success = false

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
  },
  created() {
    this.initCards()
  },
}
</script>

<style>
@keyframes highlight {
  0% {
    transform: scale(1.0, 1.0);
  }
  50% {
    transform: scale(1.1, 1.1);
  }
  100% {
    transform: scale(1.0, 1.0);
  }
}

.cards-enter-to {
  animation: highlight .5s;
}

.cards-leave-to {
  visibility: hidden;
  opacity: 0;
  transition: visibility 0s .5s, opacity .5s linear;
}
</style>

