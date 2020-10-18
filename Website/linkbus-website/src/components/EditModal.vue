<template>
    <b-modal id="bv-modal-edit" title="Edit Alert">
        <p class="my-4">Edit...</p>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="$bvModal.hide('bv-modal-edit')">Cancel</b-button>
            <b-button class="mx-1" variant="primary" @click="$bvModal.hide('bv-modal-edit')">Save</b-button>
        </div>
    </b-modal>
</template>

<script>
    export default {
        name: "CustomModal"
    }
</script>

<style scoped>

</style>