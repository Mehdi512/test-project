UPDATE order_states set name = 'Partially Completed' where order_state = 'PARTIALLY_TRANSFERRED';
INSERT INTO `order_type_state_transition` (`order_type`, `from_state_id`, `to_state_id`)
VALUES
	('ISO', 1, 12),
	('ISO', 2, 12),
	('ISO_ST', 1, 12),
	('ISO_ST', 2, 12);