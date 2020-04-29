
drop procedure operacion.p_gen_solot_traslado_f;
drop procedure operacion.p_insert_numslc_ori;
drop procedure operacion.p_val_doblereg_numslc;
drop procedure operacion.p_val_doblereg_pid;
drop procedure operacion.p_val_pidold_updown;
drop index SALES.IDX_VTADETPTOENL_214;

delete from tipopedd where abrev = 'TRANS_BILL';
delete from opedd where tipopedd in (select tipopedd from tipopedd where abrev = 'TRANS_BILL');
commit;
/
