<template>
  <div>
    <div v-if="showForm"><card-form form=form></card-form></div>
    <a v-else class="btn btn-primary" href="#" @click="setShowForm($event)">
      <i class="fas fa-plus-md-md-1"></i>
      Eintrag bearbeiten
    </a>
  </div>
</template>

<script>
import CardForm from './Form.vue'

export default {
  data() {
    return {
      showForm: false,
      form: {
        topic: 'foo'
      }
    }
  },
  components: {
    CardForm,
  },
  methods: {
    setShowForm(event) {
      event.preventDefault()
      this.showForm = true
    }
  },
}
</script>
