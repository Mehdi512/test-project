USE `contractmanagement`;

CREATE TABLE scheduler_info (
    id BIGINT AUTO_INCREMENT,
    scheduler_name VARCHAR(100) NOT NULL,
    is_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    cron_expression VARCHAR(100) NULL,
    run_at TIMESTAMP NULL,
    next_run_at TIMESTAMP NULL,
    run_start TIMESTAMP NULL,
    run_end TIMESTAMP NULL,
    status VARCHAR(20) NULL,
    message TEXT NULL,
    run_duration_ms BIGINT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    max_lock_till TIMESTAMP NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_scheduler_name (scheduler_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;