DROP TABLE operacion.sgat_compar_sot_act_noact;

DROP TRIGGER OPERACION.t_sgat_compar_sot_act_noact_bi;

DELETE FROM operacion.tiptraventana
 WHERE idventana IN (SELECT idventana
                       FROM sgacrm.inv_ventana
                      WHERE nombre = 'w_mnt_act_incognito'
                        AND estado = 1);

DELETE FROM opewf.tareadefventana
 WHERE idventana IN (SELECT idventana
                       FROM sgacrm.inv_ventana
                      WHERE nombre = 'w_mnt_act_incognito'
                        AND estado = 1);

DELETE FROM sgacrm.inv_ventana
 WHERE idventana IN (SELECT idventana
                       FROM sgacrm.inv_ventana
                      WHERE nombre = 'w_mnt_act_incognito'
                        AND estado = 1);

declare
v_exist number;
begin

select count(1) into v_exist
from all_triggers
where trigger_name = 'SGATRI_IMPORT_MASIVA_CAB' and owner = 'OPERACION';

if v_exist = 1 then
  execute immediate 'drop trigger OPERACION.SGATRI_IMPORT_MASIVA_CAB';
end if;

select count(1) into v_exist
from all_triggers
where trigger_name = 'SGATRI_IMPORT_MASIVA_DET' and owner = 'OPERACION';

if v_exist = 1 then
  execute immediate 'drop trigger OPERACION.SGATRI_IMPORT_MASIVA_DET';
end if;

select count(1) into v_exist
from all_tables
where table_name = 'SGAT_IMPORTACION_MASIVA_DET' and owner = 'OPERACION';

if v_exist = 1 then
  execute immediate 'drop table OPERACION.SGAT_IMPORTACION_MASIVA_DET';
end if;

select count(1) into v_exist
from all_tables
where table_name = 'SGAT_IMPORTACION_MASIVA_CAB' and owner = 'OPERACION';

if v_exist = 1 then
  execute immediate 'drop table OPERACION.SGAT_IMPORTACION_MASIVA_CAB';
end if;

select count(1) into v_exist
from all_sequences
where sequence_name = 'SGASEQ_IMPORTMASIVACAB' and sequence_owner = 'OPERACION';

if v_exist = 1 then
  execute immediate 'drop sequence OPERACION.SGASEQ_IMPORTMASIVACAB';
end if;

select count(1) into v_exist
from all_sequences
where sequence_name = 'SGASEQ_IMPORTMASIVADET' and sequence_owner = 'OPERACION';

if v_exist = 1 then
  execute immediate 'drop sequence OPERACION.SGASEQ_IMPORTMASIVADET';
end if;

end;
/