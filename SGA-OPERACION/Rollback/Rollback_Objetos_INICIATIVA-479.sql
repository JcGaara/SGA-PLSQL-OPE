--FOREIGN KEYS
alter table operacion.SGAT_DF_TRANSACCION_DET drop constraint FK_TRSD_TRSC;
alter table operacion.SGAT_DF_TRANSACCION_DET drop constraint FK_TRSD_FLUC;
alter table operacion.SGAT_DF_TRANSACCION_CAB drop constraint FK_TRSC_PROC;
alter table operacion.SGAT_DF_TRANSACCION_CAB drop constraint FK_TRSC_FLUC;
alter table operacion.SGAT_DF_PROCESO_DET drop constraint FK_PROD_PROCV2;
alter table operacion.SGAT_DF_PROCESO_DET drop constraint FK_PROD_PROC;
alter table operacion.SGAT_DF_PROCESO_DET drop constraint FK_PROD_FLUC;
alter table operacion.SGAT_DF_PROCESO_CAB drop constraint FK_PROC_PROT;
alter table operacion.SGAT_DF_PROCESO_CAB drop constraint FK_PROC_PROS;
alter table operacion.SGAT_DF_FLUJO_DET drop constraint FK_FLUD_PROC;
alter table operacion.SGAT_DF_FLUJO_DET drop constraint FK_FLUD_FLUC;
alter table operacion.SGAT_DF_FLUJO_DET drop constraint FK_FLUD_CONC;
alter table operacion.SGAT_DF_CONDICION_DET drop constraint FK_COND_EXLOV2;
alter table operacion.SGAT_DF_CONDICION_DET drop constraint FK_COND_EXLO;
alter table operacion.SGAT_DF_CONDICION_DET drop constraint FK_COND_CONC;
alter table operacion.SGAT_DF_CONDICION_CAB drop constraint FK_CONC_CONT;

--TABLAS
drop table operacion.SGAT_DF_FLUJO_CAB;
drop table operacion.SGAT_DF_FLUJO_DET;
drop table operacion.SGAT_DF_PROCESO_CAB;
drop table operacion.SGAT_DF_PROCESO_DET;
drop table operacion.SGAT_DF_CONDICION_CAB;
drop table operacion.SGAT_DF_CONDICION_DET;
drop table operacion.SGAT_DF_EXPRESION_LOGICA;
drop table operacion.SGAT_DF_CONDICION_TIPO;
drop table operacion.SGAT_DF_PROCESO_TIPO;
drop table operacion.SGAT_DF_PROCESO_SERVIDOR;
drop table operacion.SGAT_DF_TRANSACCION_CAB;
drop table operacion.SGAT_DF_TRANSACCION_DET;

--SEQUENCES
drop sequence operacion.SGASEQ_DF_FLUJO_CAB;
drop sequence operacion.SGASEQ_DF_FLUJO_DET;
drop sequence operacion.SGASEQ_DF_PROCESO_CAB;
drop sequence operacion.SGASEQ_DF_PROCESO_DET;
drop sequence operacion.SGASEQ_DF_CONDICION_CAB;
drop sequence operacion.SGASEQ_DF_CONDICION_DET;
drop sequence operacion.SGASEQ_DF_EXPRESION_LOGICA;
drop sequence operacion.SGASEQ_DF_CONDICION_TIPO;
drop sequence operacion.SGASEQ_DF_PROCESO_TIPO;
drop sequence operacion.SGASEQ_DF_PROCESO_SERVIDOR;
drop sequence operacion.SGASEQ_DF_TRANSACCION_CAB;
drop sequence operacion.SGASEQ_DF_TRANSACCION_DET;