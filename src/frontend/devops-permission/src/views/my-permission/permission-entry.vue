<script setup lang="ts">
import PermissionHeader from '@/components/permission-header.vue';
import PermissionAside from '@/components/permission-aside.vue';
import { useI18n } from 'vue-i18n';
import {
  ref,
} from 'vue';
const { t } = useI18n();

const navs = ref([
  { name: t('权限中心'), url: '' },
]);
</script>

<template>
  <permission-header :navs="navs"></permission-header>
  <section class="permission-home">
    <!-- 菜单栏 -->
    <permission-aside></permission-aside>
    <router-view class="permission-main"></router-view>
  </section>
</template>

<style lang="postcss" scoped>
  .permission-home {
    display: flex;
    flex: 1;
    overflow: auto;
  }
  .permission-main {
    flex: 1;
    overflow: hidden;
  }
</style>
