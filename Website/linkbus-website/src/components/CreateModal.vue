<template>
    <b-modal id="bv-modal-create" title="Create New Alert">
        <p class="my-4">Create...</p>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="$bvModal.hide('bv-modal-create')">Cancel</b-button>
            <b-button class="mx-1" variant="primary" @click="$bvModal.hide('bv-modal-create')">Create</b-button>
        </div>
    </b-modal>
</template>

<script>
    export default {
        name: "CreateModal"
    }
</script>

<style scoped>

</style>