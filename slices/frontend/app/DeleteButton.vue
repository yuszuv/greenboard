<template>
  <div>
    <a v-b-modal.delete-modal class="dropdown-item text-danger" href="#">
      <i class="fas fa-trash-alt mr-md-1"></i>
      löschen
    </a>
    <b-modal id="delete-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Eintrag löschen
      </template>
      <delete-form :id="id" @delete="onDelete"></delete-form>
    </b-modal>

    <b-modal id="delete-success-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Eintrag erfolgreich gelöscht
      </template>
      <b-alert variant="success" show>Eintrag erfolgreich gelöscht</b-alert>
      <b-button type="submit" variant="success" @click="onDeleteSuccess">Schließen</b-button>
    </b-modal>
  </div>

</template>

<script>
import DeleteForm from "./DeleteForm.vue"

export default {
  props: ['id'],
  components: {
    DeleteForm,
  },
  methods: {
    onDelete(_password) {
      this.$bvModal.hide('delete-modal')
      this.$bvModal.show('delete-success-modal')
    },
    onDeleteSuccess() {
      this.$bvModal.hide('delete-success-modal')
      window.location.href = '/'
    },
  },
}
</script>
