--OPERACION.ID_SITIO
alter table OPERACION.ID_SITIO DROP COLUMN cid;

--OPERACION.PEP
alter table OPERACION.PEP DROP COLUMN genera_reserva;

alter table OPERACION.TIPROY_SINERGIA DROP COLUMN asigna_pep;
alter table OPERACION.TIPROY_SINERGIA_PEP DROP COLUMN pep_etapa;

-- OPERACION.PROYECTO_SAP
alter table OPERACION.PROYECTO_SAP DROP COLUMN manparno;

--OPERACION.PEP
alter table OPERACION.PEP DROP COLUMN manparno;

--OPERACION.RESERVA_DET
alter table OPERACION.RESERVA_DET DROP COLUMN FLG_PROCESADO;
alter table OPERACION.RESERVA_DET DROP COLUMN ESTADO_SAP;

--operacion.agendamiento
ALTER TABLE operacion.agendamiento DROP COLUMN idbucket;
ALTER TABLE operacion.agendamiento DROP COLUMN contacto_adc;
ALTER TABLE operacion.agendamiento DROP COLUMN telefono_adc;
ALTER TABLE operacion.agendamiento DROP COLUMN flg_adc;
ALTER TABLE operacion.agendamiento DROP COLUMN flg_orden_adc;
ALTER TABLE operacion.agendamiento DROP COLUMN rpt_adc;
ALTER TABLE operacion.agendamiento DROP COLUMN id_subtipo_orden;

--operacion.agendamientochgest
ALTER TABLE operacion.agendamientochgest DROP COLUMN idestado_adc;

--OPERACION.OPE_SP_MAT_EQU_DET
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_cod_sap;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_solicitante;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_fondo;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_pep;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_ceco;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_pospre;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_valoracion;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_planificador;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_nro_activo;
alter table OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN sin_orden_interna;
ALTER TABLE OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN IND_GESTOR;
ALTER TABLE OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN CENTRO_GESTOR_ADM;
ALTER TABLE OPERACION.OPE_SP_MAT_EQU_DET DROP COLUMN FLG_SINERGIA;