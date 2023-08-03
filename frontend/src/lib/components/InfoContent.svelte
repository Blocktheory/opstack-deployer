<script lang="ts">
    import { popup } from "@skeletonlabs/skeleton";
    import type { PopupSettings } from "@skeletonlabs/skeleton";
    const popupHover: PopupSettings = {
        event: "hover",
        target: "popupHover",
        placement: "top",
    };
</script>

<button
    class="btn variant-filled [&>*]:pointer-events-none"
    use:popup={popupHover}
>
    <span>(icon)</span>
    <span>Hover</span>
</button>

<div class="card p-4 variant-filled-secondary" data-popup="popupHover">
    <p />
    <div class="arrow variant-filled-secondary" />
</div>
