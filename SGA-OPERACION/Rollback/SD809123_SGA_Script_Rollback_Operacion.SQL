
-- ELIMINAR CAMPOS CREADOS.

ALTER TABLE OPERACION.TAB_REC_CSR_LTE_CAB DROP COLUMN IDLOTE;
ALTER TABLE OPERACION.TAB_REC_CSR_LTE_CAB DROP COLUMN IDSOL;
ALTER TABLE OPERACION.TAB_REC_CSR_LTE_CAB DROP COLUMN FLG_RECARGA;
ALTER TABLE OPERACION.TAB_REC_CSR_LTE_CAB DROP COLUMN TIPOSOLICITUD;
ALTER TABLE OPERACION.TAB_REC_CSR_LTE_CAB DROP COLUMN ESTADO;


ALTER TABLE OPERACION.TAB_REC_CSR_LTE_DET DROP COLUMN IDLOTE;
ALTER TABLE OPERACION.TAB_REC_CSR_LTE_DET DROP COLUMN IDSOL;


-- Eliminacion de Tablas

DROP TABLE OPERACION.OPE_LTE_LOTE_SLTD_AUX;
DROP TABLE OPERACION.OPE_LTE_ARCHIVO_CAB;
DROP TABLE OPERACION.OPE_LTE_ARCHIVO_DET;
DROP TABLE OPERACION.LOGRQT_CSR_LTE;

-- Eliminacion de Sequences

DROP SEQUENCE OPERACION.sq_ope_lte_lote_sltd_idlote;
DROP SEQUENCE OPERACION.SQ_OPE_LTE_SLTD_CAB_IDSOL;
DROP SEQUENCE OPERACION.SQ_OPE_ID_RQT_CSR;


-- Rollbackeando los registros de opedd y tiptrabajo
delete from cusbra.br_sel_wf
where tiptra=(select tiptra from tiptrabajo where descripcion='RECONEXION DE CORTE 3PLAY INALAMBRICO')
  and wfdef=(select wfdef from wfdef where descripcion='ALTA-RECONEXION-LTE');

update operacion.opedd
   set descripcion='RECONEXION 3PLAY INALAMBRICO',
       codigon=749
 where tipopedd=(select tipopedd from tipopedd where abrev='TIP_TRA_CSR')
   and descripcion='RECONEXION DE CORTE 3PLAY INALAMBRICO'
   and codigoc='11'
   and codigon_aux=1;

update operacion.opedd
   set descripcion='RECONEXION 3PLAY INALAMBRICO'
 where tipopedd=(select tipopedd from tipopedd where abrev='TIP_TRA_CSR')
   and descripcion='RECONEXION DE SUSPENSION 3PLAY INALAMBRICO'
   and codigoc='10'
   and codigon_aux=1;

delete from operacion.tiptrabajo where descripcion='RECONEXION DE CORTE 3PLAY INALAMBRICO';

update operacion.tiptrabajo
   set descripcion='RECONEXION 3PLAY INALAMBRICO'
 where descripcion='RECONEXION DE SUSPENSION 3PLAY INALAMBRICO';

delete from cusbra.br_sel_wf
where tiptra=(select tiptra from tiptrabajo where descripcion='WLL/SIAC - RECONEXION DE CORTE A SOLIC. DEL CLIENTE')
  and wfdef=(select wfdef from wfdef where descripcion='ALTA-RECONEXION-LTE');

update operacion.opedd
   set descripcion='WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE',
       codigon=759
 where tipopedd=(select tipopedd from tipopedd where abrev='TIP_TRA_CSR')
   and descripcion='WLL/SIAC - RECONEXION DE CORTE A SOLIC. DEL CLIENTE'
   and codigoc='11'
   and codigon_aux=2;

update operacion.opedd
   set descripcion='WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE'
 where tipopedd=(select tipopedd from tipopedd where abrev='TIP_TRA_CSR')
   and descripcion='WLL/SIAC - RECONEXION DE SUSPENSION A SOLIC. DEL CLIENTE'
   and codigoc='10'
   and codigon_aux=2;

delete from operacion.tiptrabajo where descripcion='WLL/SIAC - RECONEXION DE CORTE A SOLIC. DEL CLIENTE';

update operacion.tiptrabajo
   set descripcion='WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE'
 where descripcion='WLL/SIAC - RECONEXION DE SUSPENSION A SOLIC. DEL CLIENTE';

delete from operacion.tiptrabajo where descripcion='WLL/SIAC - CANCELACION DE SERVICIO';
 
commit;

-- Eliminacion de Tipos y Estados
delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'TAREA_PROG_LTE' );
commit;
delete from tipopedd where abrev = 'TAREA_PROG_LTE';
commit;

delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CONF_LTE_ORI_EST' );
commit;
delete from tipopedd where abrev = 'CONF_LTE_ORI_EST';
commit;

delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CONF_TAR_LTE' );
commit;
delete from tipopedd where abrev = 'CONF_TAR_LTE';
commit;

delete from opedd where tipopedd in ( select tipopedd from tipopedd where abrev = 'CONF_PROD_LTE' );
commit;
delete from tipopedd where abrev = 'CONF_PROD_LTE';
commit;

delete from opedd
 where descripcion = 'WLL/SIAC - CANCELACION DE SERVICIO'
   and tipopedd =
       (select tipopedd from tipopedd where abrev = 'TIP_TRA_CSR');
commit;

/
