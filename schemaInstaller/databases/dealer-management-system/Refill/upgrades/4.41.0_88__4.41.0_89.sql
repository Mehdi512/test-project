CREATE TABLE `demarcation_region` (
`id` bigint(20) NOT NULL AUTO_INCREMENT,
`job_id` varchar(100) NOT NULL,
`batch_id` bigint(20) DEFAULT NULL,
`circle` varchar(255) NOT NULL,
`region` varchar(255) NOT NULL,
`cluster` varchar(255) NOT NULL,
`territory` varchar(255) NOT NULL,
`thana` varchar(255) NOT NULL,
`status` enum('PENDING','PROCESSING','PROCESSED','FAILED') NOT NULL,
`created_on` timestamp NOT NULL DEFAULT current_timestamp(),
`last_process_runs_on` timestamp NULL DEFAULT NULL,
`processed_date` timestamp NULL DEFAULT NULL,
`file_name` varchar(255) DEFAULT NULL,
`attempts` int(11) DEFAULT 0,
`extra_params` longtext DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `demarcation_reseller` (
`id` bigint(20) NOT NULL AUTO_INCREMENT,
`job_id` varchar(100) NOT NULL,
`batch_id` bigint(20) DEFAULT NULL,
`msisdn` varchar(20) NOT NULL,
`reseller_type` varchar(50) DEFAULT NULL,
`to_be_parent` varchar(100) DEFAULT NULL,
`to_be_owner` varchar(100) DEFAULT NULL,
`to_be_region` varchar(50) DEFAULT NULL,
`to_be_cluster` varchar(50) DEFAULT NULL,
`to_be_territory` varchar(50) DEFAULT NULL,
`to_be_thana` varchar(50) DEFAULT NULL,
`status` enum('PENDING','PROCESSING','PROCESSED','FAILED') DEFAULT 'PENDING',
`created_on` timestamp NOT NULL DEFAULT current_timestamp(),
`last_process_runs_on` timestamp NOT NULL DEFAULT current_timestamp(),
`processed_date` timestamp NOT NULL DEFAULT current_timestamp(),
`file_name` varchar(255) DEFAULT NULL,
`attempts` int(11) DEFAULT 0,
`extra_params` longtext DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
