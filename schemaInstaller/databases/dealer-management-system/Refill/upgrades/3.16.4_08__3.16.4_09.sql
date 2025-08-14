--
-- $Id$
--

UPDATE id_roles roles, id_roles roles2 

SET roles.import_id = REPLACE (roles2.RoleName, ' ','_'  )

WHERE (roles.import_id='' OR roles.import_id=NULL) AND  roles.RoleName =  roles2.RoleName;