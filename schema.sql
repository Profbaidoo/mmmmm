-- ==============================================================================
-- NEBWorld GROUP - MySQL 8.0 Database Schema & DDL
-- System: Mobile Money, Airtime, Data Bundles, Bill Payments & Agent Float
-- Jurisdiction: Ghana | Currency: GHS (Ghana Cedi)
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `nebworld_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `nebworld_db`;

-- 1. ROLES TABLE
CREATE TABLE IF NOT EXISTS `roles` (
    `id` VARCHAR(36) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NULL,
    `permissions` TEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_roles_name` (`name`),
    KEY `idx_roles_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. USERS TABLE
CREATE TABLE IF NOT EXISTS `users` (
    `id` VARCHAR(36) NOT NULL,
    `identity_uuid` VARCHAR(36) NOT NULL,
    `email` VARCHAR(120) NOT NULL,
    `phone` VARCHAR(20) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `password_salt` VARCHAR(64) NULL,
    `first_name` VARCHAR(60) NOT NULL,
    `last_name` VARCHAR(60) NOT NULL,
    `role_id` VARCHAR(36) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `is_verified` TINYINT(1) NOT NULL DEFAULT 0,
    `mfa_enabled` TINYINT(1) NOT NULL DEFAULT 0,
    `mfa_secret` VARCHAR(64) NULL,
    `last_login_at` DATETIME NULL,
    `failed_login_attempts` INT NOT NULL DEFAULT 0,
    `locked_until` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_users_identity_uuid` (`identity_uuid`),
    UNIQUE KEY `uq_users_email` (`email`),
    UNIQUE KEY `uq_users_phone` (`phone`),
    KEY `idx_users_role_id` (`role_id`),
    KEY `idx_users_created_at` (`created_at`),
    CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2B. AUTH BACKUP CODES TABLE
CREATE TABLE IF NOT EXISTS `auth_backup_codes` (
    `id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `code_hash` VARCHAR(128) NOT NULL,
    `code_salt` VARCHAR(64) NOT NULL,
    `is_used` TINYINT(1) NOT NULL DEFAULT 0,
    `used_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_auth_backup_user_id` (`user_id`),
    KEY `idx_auth_backup_is_used` (`is_used`),
    CONSTRAINT `fk_auth_backup_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS `customers` (
    `id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `customer_code` VARCHAR(30) NOT NULL,
    `address` VARCHAR(255) NULL,
    `city` VARCHAR(100) NOT NULL DEFAULT 'Accra',
    `region` VARCHAR(100) NOT NULL DEFAULT 'Greater Accra',
    `id_type` VARCHAR(50) DEFAULT 'GHANA_CARD',
    `id_number` VARCHAR(50) NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_customers_user_id` (`user_id`),
    UNIQUE KEY `uq_customers_code` (`customer_code`),
    KEY `idx_customers_status` (`status`),
    CONSTRAINT `fk_customers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. AGENTS TABLE
CREATE TABLE IF NOT EXISTS `agents` (
    `id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `agent_code` VARCHAR(30) NOT NULL,
    `business_name` VARCHAR(150) NULL,
    `location` VARCHAR(255) NOT NULL,
    `region` VARCHAR(100) NOT NULL DEFAULT 'Greater Accra',
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `commission_rate_custom` DECIMAL(5,2) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_agents_user_id` (`user_id`),
    UNIQUE KEY `uq_agents_code` (`agent_code`),
    KEY `idx_agents_status` (`status`),
    CONSTRAINT `fk_agents_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. WALLETS TABLE
CREATE TABLE IF NOT EXISTS `wallets` (
    `id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `wallet_type` VARCHAR(20) NOT NULL DEFAULT 'AGENT',
    `currency` VARCHAR(3) NOT NULL DEFAULT 'GHS',
    `available_balance` DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    `reserved_balance` DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    `total_deposits` DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    `total_withdrawals` DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_wallets_user_id` (`user_id`),
    KEY `idx_wallets_type` (`wallet_type`),
    KEY `idx_wallets_status` (`status`),
    CONSTRAINT `fk_wallets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. PAYMENT PROVIDERS TABLE
CREATE TABLE IF NOT EXISTS `payment_providers` (
    `id` VARCHAR(36) NOT NULL,
    `code` VARCHAR(30) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `is_sandbox` TINYINT(1) NOT NULL DEFAULT 1,
    `supported_services` VARCHAR(255) NOT NULL DEFAULT 'MOMO,AIRTIME,DATA',
    `config_json` TEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_payment_providers_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. TRANSACTIONS TABLE
CREATE TABLE IF NOT EXISTS `transactions` (
    `id` VARCHAR(36) NOT NULL,
    `reference` VARCHAR(64) NOT NULL,
    `idempotency_key` VARCHAR(64) NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `customer_id` VARCHAR(36) NULL,
    `agent_id` VARCHAR(36) NULL,
    `service_type` VARCHAR(30) NOT NULL,
    `network` VARCHAR(20) NOT NULL,
    `recipient_phone` VARCHAR(20) NOT NULL,
    `amount` DECIMAL(12,2) NOT NULL,
    `fee` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    `commission` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    `total_amount` DECIMAL(12,2) NOT NULL,
    `currency` VARCHAR(3) NOT NULL DEFAULT 'GHS',
    `payment_provider_id` VARCHAR(36) NULL,
    `provider_reference` VARCHAR(100) NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    `failure_reason` VARCHAR(255) NULL,
    `metadata_json` TEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_transactions_reference` (`reference`),
    UNIQUE KEY `uq_transactions_idempotency` (`idempotency_key`),
    KEY `idx_tx_user_id` (`user_id`),
    KEY `idx_tx_customer_id` (`customer_id`),
    KEY `idx_tx_agent_id` (`agent_id`),
    KEY `idx_tx_service_type` (`service_type`),
    KEY `idx_tx_network` (`network`),
    KEY `idx_tx_phone` (`recipient_phone`),
    KEY `idx_tx_status` (`status`),
    KEY `idx_tx_provider_ref` (`provider_reference`),
    KEY `idx_tx_created_at` (`created_at`),
    CONSTRAINT `fk_tx_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_tx_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `fk_tx_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `fk_tx_provider` FOREIGN KEY (`payment_provider_id`) REFERENCES `payment_providers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. TRANSACTION EVENTS TABLE
CREATE TABLE IF NOT EXISTS `transaction_events` (
    `id` VARCHAR(36) NOT NULL,
    `transaction_id` VARCHAR(36) NOT NULL,
    `event_type` VARCHAR(50) NOT NULL,
    `previous_status` VARCHAR(20) NULL,
    `new_status` VARCHAR(20) NOT NULL,
    `raw_payload` TEXT NULL,
    `notes` VARCHAR(255) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_tx_events_tx_id` (`transaction_id`),
    CONSTRAINT `fk_tx_events_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. WALLET LEDGER TABLE
CREATE TABLE IF NOT EXISTS `wallet_ledger` (
    `id` VARCHAR(36) NOT NULL,
    `wallet_id` VARCHAR(36) NOT NULL,
    `transaction_id` VARCHAR(36) NULL,
    `entry_type` VARCHAR(20) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `amount` DECIMAL(14,2) NOT NULL,
    `balance_before` DECIMAL(14,2) NOT NULL,
    `balance_after` DECIMAL(14,2) NOT NULL,
    `reference` VARCHAR(64) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `created_by` VARCHAR(36) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_ledger_wallet_id` (`wallet_id`),
    KEY `idx_ledger_tx_id` (`transaction_id`),
    KEY `idx_ledger_ref` (`reference`),
    KEY `idx_ledger_created_at` (`created_at`),
    CONSTRAINT `fk_ledger_wallet` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_ledger_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. AIRTIME PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS `airtime_products` (
    `id` VARCHAR(36) NOT NULL,
    `network` VARCHAR(20) NOT NULL,
    `min_amount` DECIMAL(10,2) NOT NULL DEFAULT 1.00,
    `max_amount` DECIMAL(10,2) NOT NULL DEFAULT 1000.00,
    `discount_percent` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `fee_percent` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `fee_flat` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_airtime_network` (`network`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. DATA PACKAGES TABLE
CREATE TABLE IF NOT EXISTS `data_packages` (
    `id` VARCHAR(36) NOT NULL,
    `network` VARCHAR(20) NOT NULL,
    `package_name` VARCHAR(100) NOT NULL,
    `volume` VARCHAR(50) NOT NULL,
    `price` DECIMAL(10,2) NOT NULL,
    `validity` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_data_pkg_network` (`network`),
    KEY `idx_data_pkg_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. BILLERS TABLE
CREATE TABLE IF NOT EXISTS `billers` (
    `id` VARCHAR(36) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `biller_code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `account_label` VARCHAR(100) NOT NULL DEFAULT 'Account / Meter Number',
    `fee_flat` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `fee_percent` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_billers_code` (`biller_code`),
    KEY `idx_billers_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. COMMISSIONS TABLE
CREATE TABLE IF NOT EXISTS `commissions` (
    `id` VARCHAR(36) NOT NULL,
    `agent_id` VARCHAR(36) NULL,
    `service_type` VARCHAR(30) NOT NULL,
    `network` VARCHAR(20) NOT NULL DEFAULT 'ALL',
    `commission_type` VARCHAR(20) NOT NULL DEFAULT 'PERCENTAGE',
    `commission_value` DECIMAL(8,2) NOT NULL,
    `min_transaction_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `max_transaction_amount` DECIMAL(10,2) NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_comm_agent_id` (`agent_id`),
    KEY `idx_comm_service` (`service_type`),
    CONSTRAINT `fk_comm_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 14. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS `notifications` (
    `id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NOT NULL,
    `channel` VARCHAR(20) NOT NULL DEFAULT 'IN_APP',
    `recipient` VARCHAR(120) NOT NULL,
    `title` VARCHAR(150) NOT NULL,
    `content` TEXT NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    `sent_at` DATETIME NULL,
    `error_message` VARCHAR(255) NULL,
    `is_read` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_notif_user_id` (`user_id`),
    KEY `idx_notif_status` (`status`),
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 15. RECEIPTS TABLE
CREATE TABLE IF NOT EXISTS `receipts` (
    `id` VARCHAR(36) NOT NULL,
    `transaction_id` VARCHAR(36) NOT NULL,
    `receipt_number` VARCHAR(50) NOT NULL,
    `pdf_path` VARCHAR(255) NULL,
    `issued_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `content_json` TEXT NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_receipts_tx_id` (`transaction_id`),
    UNIQUE KEY `uq_receipts_number` (`receipt_number`),
    CONSTRAINT `fk_receipts_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 16. REFUNDS TABLE
CREATE TABLE IF NOT EXISTS `refunds` (
    `id` VARCHAR(36) NOT NULL,
    `transaction_id` VARCHAR(36) NOT NULL,
    `refund_reference` VARCHAR(64) NOT NULL,
    `amount` DECIMAL(12,2) NOT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    `processed_by` VARCHAR(36) NULL,
    `processed_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_refunds_tx_id` (`transaction_id`),
    UNIQUE KEY `uq_refunds_reference` (`refund_reference`),
    CONSTRAINT `fk_refunds_tx` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_refunds_processor` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 17. AUDIT LOGS TABLE
CREATE TABLE IF NOT EXISTS `audit_logs` (
    `id` VARCHAR(36) NOT NULL,
    `user_id` VARCHAR(36) NULL,
    `action` VARCHAR(100) NOT NULL,
    `target_model` VARCHAR(50) NOT NULL,
    `target_id` VARCHAR(36) NOT NULL,
    `ip_address` VARCHAR(45) NULL,
    `user_agent` VARCHAR(255) NULL,
    `previous_values` TEXT NULL,
    `new_values` TEXT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_audit_user_id` (`user_id`),
    KEY `idx_audit_action` (`action`),
    KEY `idx_audit_created_at` (`created_at`),
    CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 18. SYSTEM SETTINGS TABLE
CREATE TABLE IF NOT EXISTS `system_settings` (
    `id` VARCHAR(36) NOT NULL,
    `setting_key` VARCHAR(80) NOT NULL,
    `setting_value` TEXT NOT NULL,
    `description` VARCHAR(255) NULL,
    `category` VARCHAR(50) NOT NULL DEFAULT 'GENERAL',
    `is_secret` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_settings_key` (`setting_key`),
    KEY `idx_settings_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
