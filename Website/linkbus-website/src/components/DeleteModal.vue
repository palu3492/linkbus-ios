<template>
    <b-modal id="bv-modal-delete" title="Delete Alert">
        <p class="my-4">Are you sure you want to delete this alert?</p>
        <div slot="modal-footer">
            <b-button class="mx-1" variant="dark" @click="$bvModal.hide('bv-modal-delete')">Cancel</b-button>
            <b-button class="mx-1" variant="danger" @click="$bvModal.hide('bv-modal-delete')">Yes, delete</b-button>
        </div>
    </b-modal>
</template>

<script>
    export default {
        name: "DeleteModal"
    }
</script>

<style scoped>

</style>