delete  OPERACION.opedd
where tipopedd = 
(SELECT tipopedd FROM operacion.tipopedd
where abrev = 'TIPO_TRANS_SIAC_LTE');
commit;
delete operacion.tipopedd
where abrev = 'TIPO_TRANS_SIAC_LTE';
commit;
delete  OPERACION.opedd
where tipopedd in 
(SELECT tipopedd FROM operacion.tipopedd
where abrev = 'CONF_LTE_ACCION');
commit;
delete operacion.tipopedd
where abrev = 'CONF_LTE_ACCION';
commit;
delete  OPERACION.opedd
where tipopedd = 
(SELECT tipopedd FROM operacion.tipopedd
where abrev = 'TIP_TRA_CSR');
commit;
delete operacion.tipopedd
where abrev = 'TIP_TRA_CSR';
commit;
delete OPERACION.tiptrabajo where descripcion in
(
'WLL/SIAC - MANTENIMIENTO',
'WLL/SIAC - RETENCION',
'WLL/SIAC - RECLAMOS',
'WLL/SIAC - CAMBIO DE PLAN',
'WLL/SIAC - TRASLADO EXTERNO',
'WLL/SIAC - TRASLADO INTERNO',
'WLL/SIAC - DECO ADICIONAL',
'WLL/SIAC - BAJA TOTAL DE SERVICIO',
'WLL/SIAC - SUSPENSION A SOLIC. DEL CLIENTE',
'WLL/SIAC - RECONEXION A SOLIC. DEL CLIENTE',
'WLL/SIAC - MANTENIMIENTO BABY SITTING',
'WLL/SIAC - FIDELIZACION',
'WLL/SIAC - PUNTO ADICIONAL'
);
commit;
 DELETE 
  FROM operacion.tiptraxarea tt
 WHERE tt.tiptra IN
       (SELECT t.tiptra
          FROM tiptrabajo t
         WHERE t.tiptra = tt.tiptra
           AND t.descripcion = 'WLL/SIAC - MANTENIMIENTO')
   AND area = 1;
commit;
DELETE 
  FROM operacion.mototxtiptra tt
 WHERE tt.tiptra =
       (SELECT t.tiptra
          FROM tiptrabajo t
         WHERE t.tiptra = tt.tiptra
           AND t.descripcion = 'WLL/SIAC - MANTENIMIENTO');
commit;
delete from  operacion.ope_det_xml where idcab in(select idcab from OPERACION.OPE_CAB_XML where programa = 'actualizarDIRFAC');
delete from  OPERACION.OPE_CAB_XML where programa = 'actualizarDIRFAC'; 
delete from  operacion.ope_det_xml where idcab in(select idcab from OPERACION.OPE_CAB_XML where programa = 'insertarOCC');
delete from  OPERACION.OPE_CAB_XML where programa = 'insertarOCC'; 
commit;
DROP SEQUENCE operacion.SQ_TAB_CSR_LTE_CAB;
DROP SEQUENCE operacion.SQ_TAB_CSR_LTE_DET;
DROP TABLE  operacion.TAB_REC_CSR_LTE_CAB;
DROP TABLE  operacion.TAB_REC_CSR_LTE_DET;
DROP PACKAGE BODY operacion.PQ_SIAC_TRASLADO_EXTERNO_LTE;
DROP PACKAGE operacion.PQ_SIAC_TRASLADO_EXTERNO_LTE;
DROP PACKAGE BODY operacion.Q_SIAC_CAMBIO_PLAN_LTE;
DROP PACKAGE operacion.Q_SIAC_CAMBIO_PLAN_LTE;
DROP PACKAGE BODY operacion.pq_csr_lte;
DROP PACKAGE operacion.pq_csr_lte;
commit;
