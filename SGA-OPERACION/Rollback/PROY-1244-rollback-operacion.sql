-- DELETE
DELETE FROM OPEDD WHERE CODIGON = 0 AND UPPER(Descripcion) LIKE '%GENERADO%';
DELETE FROM OPEDD WHERE CODIGON = 1 AND UPPER(Descripcion) LIKE '%PENDIENTE%';
DELETE FROM OPEDD WHERE CODIGON = 2 AND UPPER(Descripcion) LIKE '%CERRADO%';
DELETE FROM OPEDD WHERE CODIGON = 3 AND UPPER(Descripcion) LIKE '%ANULADO%';
DELETE FROM TIPOPEDD WHERE UPPER(ABREV) LIKE '%EST_SOL_PED%';

DELETE FROM OPEDD WHERE CODIGOC = '' AND UPPER(Descripcion) LIKE '%ALMACEN%';
DELETE FROM OPEDD WHERE CODIGOC = 'P' AND UPPER(Descripcion) LIKE '%PROYECTO%';
DELETE FROM OPEDD WHERE CODIGOC = 'K' AND UPPER(Descripcion) LIKE '%CENTRO DE COSTO%';
DELETE FROM OPEDD WHERE CODIGOC = 'A' AND UPPER(Descripcion) LIKE '%ACTIVO%';
DELETE FROM TIPOPEDD WHERE UPPER(ABREV) LIKE '%SOP_IMPUTACION%';

DELETE FROM OPEDD WHERE CODIGOC = '102' AND UPPER(Descripcion) LIKE '%NORMAL%';
DELETE FROM OPEDD WHERE CODIGOC = '101' AND UPPER(Descripcion) LIKE '%SERVICIO%';
DELETE FROM TIPOPEDD WHERE UPPER(ABREV) LIKE '%SOP_TIPO_POSICION%';

DELETE FROM OPEDD WHERE CODIGON = 189 AND UPPER(Descripcion) LIKE '%RS%';
DELETE FROM OPEDD WHERE CODIGON = 190 AND UPPER(Descripcion) LIKE '%IS%';
DELETE FROM OPEDD WHERE CODIGON = 191 AND UPPER(Descripcion) LIKE '%DT%';
DELETE FROM OPEDD WHERE CODIGON = 192 AND UPPER(Descripcion) LIKE '%SOPORTE OPERATIVO 1%';
DELETE FROM OPEDD WHERE CODIGON = 193 AND UPPER(Descripcion) LIKE '%SOPORTE OPERATIVO 2%';
DELETE FROM OPEDD WHERE CODIGON = 194 AND UPPER(Descripcion) LIKE '%SOPORTE OPERATIVO 3%';
DELETE FROM TIPOPEDD WHERE UPPER(ABREV) LIKE '%SOP_GRUPO_COMPRA%';

DELETE FROM OPEDD WHERE CODIGON = 0 AND UPPER(Descripcion) LIKE '%GENERADO%';
DELETE FROM OPEDD WHERE CODIGON = 1 AND UPPER(Descripcion) LIKE '%EN PROCESO%';
DELETE FROM OPEDD WHERE CODIGON = 2 AND UPPER(Descripcion) LIKE '%APROBADO%';
DELETE FROM OPEDD WHERE CODIGON = 3 AND UPPER(Descripcion) LIKE '%ANULADO%';
DELETE FROM TIPOPEDD WHERE UPPER(ABREV) LIKE '%SOL_PED_EST_APRO%';

COMMIT;

--rollback
alter table OPERACION.SOLOTPTOETAMAT
drop column idspcab;

alter table OPERACION.solotptoequ
drop column idspcab;

alter table OPERACION.efptoetamat
drop column idspcab;

alter table OPERACION.efptoequ
drop column idspcab;

--PAQUETE
DROP PACKAGE OPERACION.PQ_SOLICITUD_PEDIDO;

--BORRA LAS SECUENCIAS
DROP sequence OPERACION.SQ_OPE_SP_MAT_EQU_CAB;
DROP sequence OPERACION.SQ_OPE_SP_MAT_EQU_DET;

--BORRA LOS TRIGGERS
DROP trigger OPERACION.T_OPE_SP_MAT_EQU_TMP_BI;
DROP trigger OPERACION.T_OPE_SP_MAT_EQU_DET_IMP_AIUD;
DROP trigger OPERACION.t_ope_sp_mat_equ_det_bu;
DROP trigger OPERACION.T_OPE_SP_MAT_EQU_DET_BI;
DROP trigger OPERACION.T_OPE_SP_MAT_EQU_DET_AIUD;
DROP trigger OPERACION.t_ope_sp_mat_equ_det_AIU;
DROP trigger OPERACION.t_ope_sp_mat_equ_cab_bu;
DROP trigger OPERACION.T_OPE_SP_MAT_EQU_CAB_BI;
DROP trigger OPERACION.T_OPE_SP_MAT_EQU_CAB_AIUD;

--BORRA TABLAS
DROP TABLE OPERACION.OPE_SP_MAT_EQU_CAB;
DROP TABLE OPERACION.OPE_SP_MAT_EQU_DET;
DROP TABLE OPERACION.OPE_SP_MAT_EQU_DET_IMP;
DROP TABLE OPERACION.OPE_SP_MAT_EQU_TMP;