--
-- $Id: 3.16.0_04__3.16.0_05.sql 24795 2009-12-08 10:49:08Z radek $
--


ALTER TABLE dwa_items 
  ADD ownerId varchar(40),
  ADD reservationRef varchar(25),
  ADD reservationTime datetime,
  ADD INDEX reservationIndex(reservationRef); 

