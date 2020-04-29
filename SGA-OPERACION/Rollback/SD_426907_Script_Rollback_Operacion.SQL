-- Desintalacion de configuraciones:
delete from operacion.opedd where tipopedd in ( select tipopedd from operacion.tipopedd where abrev = 'CONFIG-SGA-IW' );
delete from operacion.tipopedd where abrev = 'CONFIG-SGA-IW';

delete from operacion.opedd where tipopedd in ( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_A_SGA_JANUS' );
delete from operacion.tipopedd where abrev = 'CONFIG_A_SGA_JANUS';

delete from operacion.opedd where tipopedd in ( select tipopedd from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS' );
delete from operacion.tipopedd where abrev = 'CONFIG_B_SGA_JANUS';

drop table OPERACION.INSSRV_JANUS;

drop function operacion.f_get_proy;

drop package body intraway.pq_upd_iw_sga;
drop package intraway.pq_upd_iw_sga;

commit;
/
