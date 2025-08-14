ALTER TABLE `Refill`.`id_users`
  ADD COLUMN `time_in_mili_second` INT(11) NULL DEFAULT '0' AFTER `fields`;

ALTER TABLE `Refill`.`id_users_passwords_history`
  ADD COLUMN `time_in_mili_second` INT(11) NULL DEFAULT '0' AFTER `password_format`;

USE `Refill`;
DROP procedure IF EXISTS `getUserAccessData`;

DELIMITER $$
USE `Refill`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserAccessData`(
  domainPath varchar(40),
  userId varchar(20)
)
  BEGIN
    SELECT
      u.userid,
      u.UserKey AS user_key,
      u.password_format,
      u.password,
      u.creationtime,
      u.last_password_change_time,
      u.password_expiry_period AS user_password_expiry_period,
      u.password_expiry AS user_password_expiry,
      u.IncorrectAttempts AS user_incorrect_login_attempt,
      u.TotalLogins AS user_total_logins,
      p.password_change_at_first_login AS first_login,
      p.password_expiry_period AS policy_password_expiry_period,
      p.incorrectlogin_max_attempt AS policy_max_incorrect_login_attempt,
      r.web_user,
      r.terminal_user,
      r.RoleName AS role_name,
      r.import_id AS role_id,
      u.time_in_mili_second AS salt,
      cp.ip_addresses AS allowed_connection_profile
    FROM id_users u
      JOIN id_domains dom ON dom.domainkey = u.domainkey AND dom.PathName = domainPath
      JOIN id_roles r ON u.role_key=r.RoleKey
      JOIN id_password_policies p ON p.policy_key=r.password_policy_key
      LEFT JOIN id_connection_profiles cp ON u.connection_profile_key=cp.profile_key
    WHERE u.userid = userId;
  END$$

DELIMITER ;