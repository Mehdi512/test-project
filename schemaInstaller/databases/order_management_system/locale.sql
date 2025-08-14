# Dump of table order_reason_type
# ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
use order_management_system;
TRUNCATE TABLE `order_reason_type`;
INSERT INTO `order_reason_type` (`code`, `type`, `description`)
VALUES
  ('BAD_PRODUCT','REJECT','Bad product received'),
  ('INCORRECT_PRODUCT','RETURN','Incorrect product received'),
  ('OTHER','REJECT','Desribe what\'s wrong with the item'),
  ('OTHER','RETURN','Describe what\'s wrong with the item');



TRUNCATE TABLE `user_payment_agreement_mapping`;

INSERT INTO `user_payment_agreement_mapping` (`reseller_type`, `reseller_id`, `order_type`, `payment_agreement`)
VALUES
    ('operator', '', 'ISO_ST', 'NA'),
    ('operator', '', 'IPO', 'CASH'),
    ('operator', '', 'IPO', 'CREDIT'),
    ('DIST', '', 'IPO', 'CASH'),
    ('DIST', '', 'IPO', 'CREDIT'),
    ('DIST', '', 'IPO', 'NO_MR'),
    ('DIST', '', 'ISO_ST', 'NA'),
    ('DIST', '', 'ISO', 'UPFRONT'),
    ('operator', '', 'PSEUDO_ORDER', 'NA'),
    ('POS', '', 'PSEUDO_ORDER', 'NA'),
    ('RET', '', 'PSEUDO_ORDER', 'NA'),
    ('DIST', '', 'PSEUDO_ORDER', 'NA'),
    ('operator', '', 'ISO', 'UPFRONT'),
    ('operator', '', 'DUMMY_PO', 'UPFRONT'),
    ('GPC', '', 'MO', 'NA'),
    ('operator', '', 'IPO', 'NO_MR'),
    ('GPC', '', 'ISO', 'UPFRONT');
;
;


# Dump of table user_payment_mode_mapping
# ------------------------------------------------------------

TRUNCATE TABLE `user_payment_mode_mapping`;

INSERT INTO `user_payment_mode_mapping` (`reseller_type`, `reseller_id`, `order_type`, `payment_mode`)
VALUES
    ('operator', '', 'ISO_ST', 'NO_PAYMENT_REQD'),
    ('Operator', '', 'IPO', 'DEFERRED'),
    ('DIST', '', 'IPO', 'CASH'),
    ('DIST', '', 'IPO', 'AUTO_BANK_DEBIT'),
    ('DIST', '', 'IPO', 'CHEQUE'),
    ('DIST', '', 'IPO', 'DEFERRED'),
    ('DIST', '', 'IPO', 'DEMAND_DRAFT'),
    ('DIST', '', 'IPO', 'MFS'),
    ('DIST', '', 'IPO', 'ONLINE_PAYMENT'),
    ('DIST', '', 'IPO', 'PAYMENT_ORDER_PO'),
    ('DIST', '', 'IPO', 'RTGS'),
    ('DIST', '', 'ISO_ST', 'NO_PAYMENT_REQD'),
    ('DIST', '', 'ISO', 'CASH'),
    ('operator', '', 'PSEUDO_ORDER', 'NO_PAYMENT_REQD'),
    ('POS', '', 'PSEUDO_ORDER', 'NO_PAYMENT_REQD'),
    ('RET', '', 'PSEUDO_ORDER', 'NO_PAYMENT_REQD'),
    ('DIST', '', 'PSEUDO_ORDER', 'NO_PAYMENT_REQD'),
    ('operator', '', 'ISO', 'CASH'),
    ('operator', '', 'DUMMY_PO', 'CASH'),
    ('GPC', '', 'MO', 'NO_PAYMENT_REQD');


TRUNCATE TABLE `order_type_category`;
INSERT INTO `order_type_category` (`order_category_name`, `order_type`, `order_category`, `description`, `label`)
VALUES
  ('IPO', 'IPO', 'PURCHASE_ORDER', 'Instant Purchase Order', 'Purchase Order'),
  ('ISO_ST', 'ISO_ST', 'STOCK_TRANSFER', 'Instant Sales Order Stock Transfer', 'Instant Sales Order Stock Transfer'),
  ('ISO', 'ISO', 'ORDER', 'Instant Sales Order', 'Instant Sales Order'),
  ('PSEUDO_ORDER', 'PSEUDO_ORDER', 'ORDER', 'Pseudo Order', 'Pseudo Order'),
  ('MO', 'MO', 'MOVE_ORDER', 'Move Order', 'Move Order'),
  ('DUMMY_PO', 'DUMMY_PO', 'ORDER', 'Dummy PO Order', 'Dummy PO Order');


TRUNCATE TABLE `order_type`;
INSERT INTO `order_type` (`order_type`, `description`)
VALUES
  ('IPO', 'Instant Purchase Order'),
  ('ISO_ST', 'Instant Sales Order - Stock Transfer'),
  ('ISO', 'Instant Sales Order'),
  ('PSEUDO_ORDER', 'Pseudo Order'),
  ('DUMMY_PO', 'Dummy  Purchase  Order'),
  ('MO', 'Move Order');

TRUNCATE TABLE `order_states`;
INSERT INTO `order_states` (`id`, `order_state`, `description`, `name`)
VALUES
  (1, 'CREATED', 'initial state on order creation', 'CREATED'),
  (2, 'TRANSFER_WAIT_CONFIRM', 'order waiting confirmation', 'TRANSFER_WAIT_CONFIRM'),
  (3, 'TRANSFERRED', 'order completed - stock transferred', 'Completed'),
  (4, 'TRANSFER_REJECTED', 'order rejected', 'TRANSFER_REJECTED'),
  (5, 'RETURN_TRANSFERRED', 'order return complete', 'RETURN_TRANSFERRED'),
  (6, 'RETURN_TRANSFER_WAIT_CONFIRM', 'order return waiting confirmation', 'RETURN_TRANSFER_WAIT_CONFIRM'),
  (7, 'RETURN_TRANSFER_REJECTED', 'return order rejected', 'RETURN_TRANSFER_REJECTED'),
  (8, 'EXTERNAL_CREATED', 'external order creation state', 'EXTERNAL_CREATED'),
  (9, 'EXTERNAL_RETURN_TRANSFER_WAIT_CONFIRM', 'order return waiting confirmation external', 'EXTERNAL_RETURN_TRANSFER_WAIT_CONFIRM'),
  (10, 'EXTERNAL_RETURN_TRANSFERRED', 'order return complete external', 'EXTERNAL_RETURN_TRANSFERRED'),
  (11, 'EXTERNAL_RETURN_TRANSFER_REJECTED', 'return order rejected external', 'EXTERNAL_RETURN_TRANSFER_REJECTED'),
  (12, 'PARTIALLY_TRANSFERRED', 'order partially completed', 'Partially Completed'),
  (13, 'PAYMENT_WAIT_CONFIRM', 'order payment waiting confirmation', 'PAYMENT_WAIT_CONFIRM'),
  (14, 'PAYMENT_FAILED', 'order payment failed', 'PAYMENT_FAILED'),
  (15, 'EXTERNAL_WAIT_CREATED', 'initial state of external order creation', 'EXTERNAL_WAIT_CREATED'),
  (16, 'EXTERNAL_CREATED_WITH_ERROR', 'some error occurred after external order created', 'EXTERNAL_CREATED_WITH_ERROR'),
  (17, 'PENDING_APPROVAL', 'Indicates that the order is still pending approval by the user', 'PENDING_APPROVAL'),
  (18, 'REJECTED', 'Indicates that the order has been rejected by the user', 'REJECTED'),
  (19, 'SUBMITTED', 'Indicates order has completed the purchase process and has been submitted to the order management system', 'SUBMITTED'),
  (20, 'RESERVED_WAIT_CONFIRM', 'Indicates that the order is reserved for the receiver and is pending confirmation', 'RESERVED_WAIT_CONFIRM'),
  (21, 'RESERVED', 'Indicates the order is reserved', 'RESERVED'),
  (22, 'RESERVE_REJECTED', 'Indicates that the order reservation is rejected', 'RESERVE_REJECTED'),
  (23, 'EXTERNAL_SCHEDULED', 'Indicates that the external order is schedule', 'EXTERNAL_SCHEDULED'),
  (24, 'EXTERNAL_PROCESS_FAILED', 'Indicates that the external order failed to process', 'EXTERNAL_PROCESS_FAILED'),
  (25, 'REVERSED', 'Indicates that the order has been reversed', 'REVERSED'),
  (26, 'PAYMENT_INITIATED', 'Payment initiated for order', 'PAYMENT_INITIATED'),
  (27, 'REVERSE_INITIATED', 'Order reverse initiated', 'REVERSE_INITIATED'),
  (28, 'REVERSE_FAILED', 'Order reverse failed', 'REVERSE_FAILED'),
  (29, 'REVERSE_WAIT_CONFIRM', 'Order waiting confirmation for reverse', 'REVERSE_WAIT_CONFIRM'),
  (30, 'REVERSE_INCONSISTENT', 'Order reverse in inconsistent state', 'REVERSE_INCONSISTENT'),
  (31, 'REVERSE_REJECTED', 'Order reverse in rejected state', 'REVERSE_REJECTED'),
  (32, 'RETURN_SUBMITTED', 'Return order submission status', 'RETURN_SUBMITTED'),
  (33, 'WAITING_RESERVATION', 'Indicates that the order is waiting for reservation again due to stolen/lost inventory', 'WAITING_RESERVATION'),
  (34, 'RETURN_INCOMPLETE', 'Indicates that the order is returned with lost/stolen items', 'RETURN_INCOMPLETE'),
  (35, 'FAILED', 'Failed order status', 'FAILED'),
  (36, 'EXTERNAL_APPROVED', 'External system approved the order', 'EXTERNAL_APPROVED'),
  (37, 'EXTERNAL_REJECTED', 'External system rejected the order', 'EXTERNAL_REJECTED'),
  (38, 'EXTERNAL_CLOSED', 'External system closed the order', 'EXTERNAL_CLOSED'),
  (39, 'EXTERNAL_CANCEL', 'External system canceled the order', 'EXTERNAL_CANCEL'),
  (40, 'Order Canceled', 'Indicates order is cancelled ', 'Order Canceled'),
  (41, 'EXTERNAL_PAYMENT_SUBMITTED', 'External payment submitted', 'EXTERNAL_PAYMENT_SUBMITTED'),
  (42, 'CLOSED', 'Order complete', 'Closed'),
  (43, 'CLOSED_FAILED', 'GRN failed complete', 'CLOSED_FAILED'),
  (44, 'Initiated', 'initial state on order creation', 'Initiated'),
  (45, 'Initiation Complete', 'Payment has been completed by the user for the order raised', 'Initiation Complete'),
  (46, 'AWAITING_SHIPPING', 'Order has been approved and is awaiting shipping', 'AWAITING_SHIPPING'),
  (48, 'Shipment Received', 'Shipment Received', 'Shipment Received'),
  (49, 'Order Rejected', 'Order Rejected', 'Order Rejected');

TRUNCATE TABLE `order_type_state_transition`;
INSERT INTO `order_type_state_transition` (`order_type`, `from_state_id`, `to_state_id`)
VALUES
	('IPO', 1, 2),
	('IPO', 1, 3),
	('IPO', 1, 13),
	('IPO', 1, 15),
	('IPO', 1, 35),
	('IPO', 1, 39),
	('IPO', 1, 44),
	('IPO', 2, 2),
	('IPO', 2, 3),
	('IPO', 2, 4),
	('IPO', 2, 13),
	('IPO', 2, 35),
	('IPO', 2, 39),
	('IPO', 3, 3),
	('IPO', 3, 41),
	('IPO', 3, 42),
	('IPO', 4, 39),
	('IPO', 4, 40),
	('IPO', 8, 3),
	('IPO', 8, 24),
	('IPO', 8, 36),
	('IPO', 8, 37),
	('IPO', 13, 3),
	('IPO', 13, 8),
	('IPO', 13, 14),
	('IPO', 13, 17),
	('IPO', 13, 39),
	('IPO', 13, 40),
	('IPO', 13, 41),
	('IPO', 14, 14),
	('IPO', 14, 39),
	('IPO', 15, 3),
	('IPO', 15, 8),
	('IPO', 15, 16),
	('IPO', 15, 17),
	('IPO', 15, 24),
	('IPO', 15, 39),
	('IPO', 15, 44),
	('IPO', 17, 4),
	('IPO', 17, 13),
	('IPO', 17, 40),
	('IPO', 35, 39),
	('IPO', 36, 38),
	('IPO', 36, 39),
	('IPO', 39, 44),
	('IPO', 41, 41),
	('IPO', 42, 42),
	('IPO', 42, 43),
	('IPO', 42, 48),
	('IPO', 43, 42),
	('IPO', 43, 43),
	('IPO', 44, 4),
	('IPO', 44, 17),
	('IPO', 44, 40),
	('IPO', 44, 44),
	('IPO', 44, 45),
	('IPO', 44, 46),
	('IPO', 44, 48),
	('IPO', 44, 49),
	('IPO', 45, 46),
	('IPO', 45, 49),
	('IPO', 46, 42),
	('IPO', 46, 46),
	('IPO', 46, 48),
	('IPO', 48, 42),
	('IPO', 48, 48),
	('IPO', 46, 43),
    ('IPO', 48, 43),
    ('IPO', 49, 40),
    ('ISO_ST', 1, 2),
    ('ISO_ST', 1, 3),
    ('ISO_ST', 2, 3),
    ('ISO_ST', 2, 4),
    ('ISO_ST', 1, 35),
    ('ISO_ST', 1, 12),
    ('ISO_ST', 2, 12),
    ('ISO', 1, 2),
    ('ISO', 1, 3),
    ('ISO', 2, 3),
    ('ISO', 2, 4),
    ('ISO', 1, 35),
    ('ISO', 1, 12),
    ('ISO', 2, 12),
    ('PSEUDO_ORDER', 1, 3),
    ('PSEUDO_ORDER', 1, 35),
    ('DUMMY_PO', '1', '3'),
    ('DUMMY_PO', '1', '42'),
    ('DUMMY_PO', '1', '44'),
	('MO', '1', '45'),
	('MO', '1', '49'),
	('MO', '45', '46'),
	('MO', '45', '49'),
	('MO', '46', '48'),
	('MO', '48', '42');


TRUNCATE TABLE `payment_mode`;
INSERT INTO `payment_mode` (`name`, `description`)
VALUES
  ('NO_PAYMENT_REQD', 'No Payment Required'),
  ('CASH', 'Cash on Delivery'),
  ('CREDIT', 'Credit'),
  ('M_PESA', 'M_Pesa wallet money'),
  ('ERP', 'Externally booked'),
  ('CARD', 'Card payment'),
  ('CREDIT_NOTE', 'Credit Note Money'),
  ('AUTO_BANK_DEBIT', 'AUTO_BANK_DEBIT'),
  ('CHEQUE', 'CHEQUE'),
  ('DEFERRED', 'Deferred Payment Mode selection'),
  ('DEMAND_DRAFT', 'DEMAND_DRAFT'),
  ('MFS', 'MFS'),
  ('ONLINE_PAYMENT', 'ONLINE_PAYMENT'),
  ('PAYMENT_ORDER_PO', 'PAYMENT_ORDER_PO'),
  ('RTGS', 'RTGS');


TRUNCATE TABLE `payment_agreement`;
INSERT INTO `payment_agreement` (`name`, `description`)
VALUES
  ('NA', 'Not applicable'),
  ('UPFRONT', 'Payment at the time of order placement'),
  ('CONSIGNMENT', 'Payment at time of delivery'),
  ('POD', 'Pay on Delivery'),
  ('PAY_LATER', 'Pay Later'),
  ('CASH', 'Cash'),
  ('CREDIT', 'Credit'),
	('NO_MR', 'No Money Required');


TRUNCATE TABLE `order_transaction_category_type`;
INSERT INTO `order_transaction_category_type` (`type`, `description`)
VALUES
	('COLLECT_PAYMENT', 'collection of payment from pos'),
	('COLLECT_STOCK', 'collection of stock from warehouse'),
	('DELIVER_STOCK', 'delivery of stock to pos'),
	('DEPOSIT_PAYMENT', 'deposition of payment to warehouse'),
	('DEPOSIT_STOCK', 'deposit of stock to warehouse'),
	('SOLD_STOCK', 'selling of stock in ISO raised in trip'),
    ('MISSING_PAYMENT', 'missing payment in trip');

 SET FOREIGN_KEY_CHECKS = 1;
