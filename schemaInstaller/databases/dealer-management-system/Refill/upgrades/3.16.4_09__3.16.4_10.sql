--
-- $Id$
--

UPDATE 
	extdev_devices ed, 
	commission_receivers cr, 
	id_users id
SET 
	ed.default_user_key = id.UserKey 
WHERE 
	ed.default_user_key = 0 
	AND cr.receiver_key = ed.owner_key 
	AND id.DomainKey = cr.domain_key 
	AND id.UserId = '9900';
