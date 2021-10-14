<template>
  <div>
    <a v-b-modal.edit-modal class="dropdown-item text-primary" href="#">
      <i class="fas fa-pencil-alt mr-md-1"></i>
      bearbeiten
    </a>

    <b-modal id="edit-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Eintrag bearbeiten
      </template>
      <update-form :id="id" @update="onUpdate"></update-form>
    </b-modal>

    <b-modal id="edit-success-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Eintrag erfolgreich bearbeitet
      </template>
      <b-alert variant="success" show>Eintrag erfolgreich bearbeitet</b-alert>
      <b-button type="submit" variant="success" @click="onUpdateSuccess">Schließen</b-button>
    </b-modal>
  </div>
</template>

<script>
import UpdateForm from './UpdateForm.vue'

export default {
  data() {
    return {
      showForm: false,
    }
  },
  props: ['id'],
  components: {
    UpdateForm,
  },
  methods: {
    onUpdate(_password) {
      this.$bvModal.hide('edit-modal')
      this.$bvModal.show('edit-success-modal')
    },
    onUpdateSuccess() {
      this.$bvModal.hide('edit-success-modal')
      window.location.href = '/'
    },
  },
}
</script>
