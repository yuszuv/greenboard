<template lang="pug">
a.dropdown-item.text-primary(href="#" @click.prevent="$emit('init-edit', id)") #[i.fas.fa-pencil-alt.mr-md-1] bearbeiten
</template>

<script>
export default {
  props: ['id'],
}
</script>
