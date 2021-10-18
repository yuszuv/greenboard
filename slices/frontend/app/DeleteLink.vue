<template lang="pug">
a.dropdown-item.text-danger(href='#' @click.prevent="$emit('init-delete', id)") #[i.fas.fa-trash-alt.mr-md-1] löschen
</template>

<script>
export default {
  props: ['id'],
}
</script>
