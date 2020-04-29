delete from operacion.opedd where ABREVIACION = 'SERV_EQUI_MIGRA';
commit;

-- Drop indexes 
drop index OPERACION.ID_IDCODCLICAB;
drop index OPERACION.ID_CODSRV;
drop index OPERACION.ID_IDCODCLI;
drop index OPERACION.ID_IDTIPSRV;

--delete column
alter table  OPERACION.MIGRT_ERROR_MIGRACION  drop column  datac_codcli;
