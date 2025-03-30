USE `isuports`;

-- tenantテーブルにdisplay_nameカラムのインデックスを追加
ALTER TABLE `tenant` ADD INDEX `idx_tenant_display_name` (`display_name`);

-- 既存のインデックスの確認
-- SHOW INDEX FROM tenant;