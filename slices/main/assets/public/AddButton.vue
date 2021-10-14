<template>
  <div>
    <a v-b-modal.add-modal class="btn btn-primary" href="#">
      <i class="fas fa-plus me-md-1"></i> 
      Neuer Eintrag
    </a>
    <b-modal id="add-modal" hide-footer hide-backdrop>
      <template #modal-title>
        Neuer Eintrag
      </template>
      <create-form></create-form>
    </b-modal>
  </div>

</template>

<script>
import CreateForm from "./CreateForm.vue"

export default {
  components: {
    CreateForm,
  },
}
</script>
