


delete from opedd where abrev = 'SRV_IP';
delete from opedd where abrev = 'PER_IP';
delete from opedd where abrev = 'NUM_IP';
delete from opedd where abrev = 'EQU_EMTA';

commit;

delete from tipopedd where abrev = 'SRV_IP';
delete from tipopedd where abrev = 'PER_IP';
delete from tipopedd where abrev = 'NUM_IP';
delete from tipopedd where abrev = 'EQU_EMTA';

commit;

delete from OPERACION.CONTROLIP;

drop view operacion.v_control_ip;

drop trigger OPERACION.T_CONTROLIP_AIUD;

drop sequence OPERACION.SQ_CONTROLIP_ID;

DROP INDEX OPERACION.PK_IDCONTROL;

DROP INDEX OPERACION.IDX_CONTROLIP_01;

DROP INDEX OPERACION.IDX_CONTROLIP_02;

DROP INDEX OPERACION.IDX_CONTROLIP_03;


drop table OPERACION.CONTROLIP;

commit;
/