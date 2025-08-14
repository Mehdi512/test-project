ALTER TABLE invoice
    ADD COLUMN payment_agreement VARCHAR(50) NULL COMMENT 'CREDIT/UPFRONT/CONSIGNMENT etc.',
    ADD COLUMN due_date DATETIME DEFAULT NULL COMMENT 'Due date for credit payments',
    ADD COLUMN defaulter_report_status VARCHAR(20) DEFAULT NULL COMMENT 'Status of defaulter reporting (PENDING, SUCCESS, FAILED)',
    ADD COLUMN defaulter_report_attempt_date TIMESTAMP DEFAULT NULL COMMENT 'Last attempt date of defaulter reporting',
    ADD COLUMN defaulter_report_error VARCHAR(255) DEFAULT NULL COMMENT 'Error message if defaulter reporting failed',
    ADD INDEX idx_defaulter_report_status (defaulter_report_status),
    ADD INDEX idx_defaulter_report_attempt_date (defaulter_report_attempt_date);