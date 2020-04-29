-------------------------Tipos y estados----------------------------------------
delete opedd
where tipopedd = (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE')
   and ABREVIACION = 'CONEXION_JANUS_PROCESO';

delete opedd
where tipopedd = (select tipopedd from tipopedd where abrev = 'PLAT_JANUS_CE')
   and ABREVIACION = 'TIPO_PROYECTO_ORIGEN';
   
delete opedd
where tipopedd = (select tipopedd from tipopedd where abrev = 'TAR_CAM_JANUS')
   and ABREVIACION = 'TAR_CAM_PLAN_JANUS';   
   
delete opedd
where tipopedd = (select tipopedd from tipopedd where abrev = 'HAB_WIMAX_JANUS')
   and ABREVIACION = 'habilitado';      

delete opedd
where tipopedd = (select tipopedd from tipopedd where abrev = 'TIPSRV_JANUS_CE')
   and ABREVIACION = 'FAMILIA'
   and CODIGOC = '0058';
-------------------------------------------------------------------------------
delete from tipopedd where abrev = 'TAR_CAM_JANUS';
delete from tipopedd where abrev = 'HAB_WIMAX_JANUS';
-------------------------------------------------------------------------------
update tareadef t
set t.pos_proc = null
where TAREADEF = 1185;

update tareadef t
set  t.pos_proc = null
where TAREADEF = 1186;

delete tareadef 
where TAREADEF = 10077;
--------------------------------------------------------------------------------
drop package BODY operacion.pq_janus_ce_cambio_plan;
drop package operacion.pq_janus_ce_cambio_plan;
--------------------------------------------------------------------------------
commit;
--------------------------------------------------------------------------------
alter table OPERACION.TELEFONIA_CE drop column TIPSRV;
alter table OPERACION.TELEFONIA_CE_DET drop column WS_XML_RPTA;
