alter table OPERACION.SGAT_LOGERR modify LOGERRC_NUMREGISTRO CHAR(15);
alter table OPERACION.SGAT_LOGERR modify LOGERRC_CODSOLOT CHAR(15);
drop index OPERACION.IX_SGAT_LOGERR;
drop index OPERACION.IX_SGAT_TRXCONTEGO
/