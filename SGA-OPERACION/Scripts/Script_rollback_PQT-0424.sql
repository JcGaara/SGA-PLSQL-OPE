----------ESQUEMA: OPERACION ---------------
--------------- Triggers --------------- 
DROP TRIGGER INTRAWAY.T_INT_COMANDOXMENSAJE_ITW_AIUD;
DROP TRIGGER INTRAWAY.T_INT_COMANDOXMENSAJE_ITW_BI;
DROP TRIGGER INTRAWAY.T_INT_MENSAJE_ITW_CAB_AIUD;
DROP TRIGGER INTRAWAY.T_INT_MENSAJE_ITW_CAB_BI;
DROP TRIGGER OPERACION.T_OPE_COMANDOPARAMETRO_REL_BI;
DROP TRIGGER OPERACION.T_OPE_COMANDOPARAMETRO_REL_BU;
DROP TRIGGER OPERACION.T_OPE_COMANDO_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_COMANDO_REL_BI;
DROP TRIGGER OPERACION.T_OPE_COMANDO_REL_BU;
DROP TRIGGER OPERACION.T_OPE_COMANPARAM_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_CONFFECHA_DET_AIUD;
DROP TRIGGER OPERACION.T_OPE_CONFFECHA_DET_BI;
DROP TRIGGER OPERACION.T_OPE_CONFFECHA_DET_BU;
DROP TRIGGER OPERACION.T_OPE_ESTADOMENSAJE_DET_AIUD;
DROP TRIGGER OPERACION.T_OPE_ESTADOSERVICIO_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_ESTADOSERVICIO_REL_BU;
DROP TRIGGER OPERACION.T_OPE_GRUPOMENSSOL_DET_AIUD;
DROP TRIGGER OPERACION.T_OPE_GRUPOMENSSOL_DET_BU;
DROP TRIGGER OPERACION.T_OPE_GRUPOS_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_GRUPOS_REL_BI;
DROP TRIGGER OPERACION.T_OPE_GRUPOS_REL_BU;
DROP TRIGGER OPERACION.T_OPE_GRUPO_MENSAJES_DET_AIUD;
DROP TRIGGER OPERACION.T_OPE_GRUPO_MENSAJES_DET_BI;
DROP TRIGGER OPERACION.T_OPE_GRUPO_MENSAJES_DET_BU;
DROP TRIGGER OPERACION.T_OPE_INSCLIENTE_CAB_AIUD;
DROP TRIGGER OPERACION.T_OPE_INSCLIENTE_CAB_BI;
DROP TRIGGER OPERACION.T_OPE_INSCLIENTE_CAB_BU;
DROP TRIGGER OPERACION.T_OPE_INSCLIENTE_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_INSCLIENTE_REL_BI;
DROP TRIGGER OPERACION.T_OPE_INSCLIENTE_REL_BU;
DROP TRIGGER OPERACION.T_OPE_MENSAJES_MAE_AIUD;
DROP TRIGGER OPERACION.T_OPE_MENSAJES_MAE_BI;
DROP TRIGGER OPERACION.T_OPE_MENSAJES_MAE_BU;
DROP TRIGGER OPERACION.T_OPE_PARAMETROS_DET_AIUD;
DROP TRIGGER OPERACION.T_OPE_PARAMETROS_DET_BI;
DROP TRIGGER OPERACION.T_OPE_PARAMETROS_DET_BU;
DROP TRIGGER OPERACION.T_OPE_PROCESOS_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_PROCESOS_REL_BI;
DROP TRIGGER OPERACION.T_OPE_PROCESOS_REL_BU;
DROP TRIGGER OPERACION.T_OPE_SEGMENTOMERCADO_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_SEGMENTOMERCADO_REL_BU;
DROP TRIGGER OPERACION.T_OPE_SERVICIOMENSAJE_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_SERVICIOMENSAJE_REL_BI;
DROP TRIGGER OPERACION.T_OPE_SERVICIOMENSAJE_REL_BU;
DROP TRIGGER OPERACION.T_OPE_TIPOMENSAJE_REL_AIUD;
DROP TRIGGER OPERACION.T_OPE_TIPOMENSAJE_REL_BI;
DROP TRIGGER OPERACION.T_OPE_TIPOMENSAJE_REL_BU;
DROP TRIGGER OPERACION.T_OPE_TRANSACCIONES_DET_AIUD;
DROP TRIGGER OPERACION.T_OPE_TRANSACCIONES_DET_BI;
DROP TRIGGER OPERACION.T_OPE_TRANSACCIONES_DET_BU;
DROP TRIGGER HISTORICO.T_ACTMACADDRESSPC_LOG_BI;

------------------TABLAS -------------------
DROP TABLE OPERACION.OPE_COMANDOPARAMETRO_REL;    
DROP TABLE OPERACION.OPE_CONFFECHA_DET;    
DROP TABLE OPERACION.OPE_ESTADOMENSAJE_DET;    
DROP TABLE OPERACION.OPE_ESTADOSERVICIO_REL;    
DROP TABLE OPERACION.OPE_GRUPO_MENSAJES_DET;    
DROP TABLE OPERACION.OPE_GRUPOMENSSOL_DET;    
DROP TABLE OPERACION.OPE_GRUPOS_REL;    
DROP TABLE OPERACION.OPE_INSCLIENTE_CAB;    
DROP TABLE OPERACION.OPE_INSCLIENTE_REL;    
DROP TABLE OPERACION.OPE_PROCESOS_REL;    
DROP TABLE OPERACION.OPE_SEGMENTOMERCADO_REL;    
DROP TABLE OPERACION.OPE_SERVICIOMENSAJE_REL;    
DROP TABLE OPERACION.OPE_TIPOMENSAJE_REL;    
DROP TABLE OPERACION.OPE_TRANSACCIONES_DET;
DROP TABLE OPERACION.OPE_MENSAJES_MAE;    
DROP TABLE OPERACION.OPE_COMANDO_REL;    
DROP TABLE OPERACION.OPE_PARAMETROS_DET;  

------------- SECUENCIAS -------------------

DROP SEQUENCE OPERACION.SQ_COMANDO_REL;
DROP SEQUENCE OPERACION.SQ_COMANDOPARAMETRO_REL;
DROP SEQUENCE OPERACION.SQ_CONFFECHA_DET;
DROP SEQUENCE OPERACION.SQ_GRUPO_MENSAJES_DET;
DROP SEQUENCE OPERACION.SQ_GRUPOS_REL;
DROP SEQUENCE OPERACION.SQ_INSCLIENTE_CAB;
DROP SEQUENCE OPERACION.SQ_INSCLIENTE_REL;
DROP SEQUENCE OPERACION.SQ_MENSAJES_MAE;
DROP SEQUENCE OPERACION.SQ_PARAMETROS_DET;
DROP SEQUENCE OPERACION.SQ_PROCESOS_REL;
DROP SEQUENCE OPERACION.SQ_SERVICIOMENSAJE_REL;
DROP SEQUENCE OPERACION.SQ_TIPOMENSAJE_REL;
DROP SEQUENCE OPERACION.SQ_TRANSACCIONES_DET;

------------- SINONIMOS-------------------
drop public synonym OPE_COMANDO_REL;
drop public synonym OPE_COMANDOPARAMETRO_REL;
drop public synonym OPE_CONFFECHA_DET;
drop public synonym OPE_ESTADOMENSAJE_DET;
drop public synonym OPE_GRUPO_MENSAJES_DET;
drop public synonym OPE_GRUPOMENSSOL_DET;
drop public synonym OPE_GRUPOS_REL;
drop public synonym OPE_INSCLIENTE_CAB;
drop public synonym OPE_INSCLIENTE_REL;
drop public synonym OPE_MENSAJES_MAE;
drop public synonym OPE_PARAMETROS_DET;
drop public synonym OPE_PROCESOS_REL;
drop public synonym OPE_SEGMENTOMERCADO_REL;
drop public synonym OPE_SERVICIOMENSAJE_REL;
drop public synonym OPE_TIPOMENSAJE_REL;
drop public synonym OPE_ESTADOSERVICIO_REL;
drop public synonym SQ_COMANDO_REL;
drop public synonym SQ_COMANDOPARAMETRO_REL;
drop public synonym SQ_CONFFECHA_DET;
drop public synonym SQ_GRUPO_MENSAJES_DET;
drop public synonym SQ_GRUPOS_REL;
drop public synonym SQ_INSCLIENTE_CAB;
drop public synonym SQ_INSCLIENTE_REL;
drop public synonym SQ_MENSAJES_MAE;
drop public synonym SQ_PARAMETROS_DET;
drop public synonym SQ_PROCESOS_REL;
drop public synonym SQ_SERVICIOMENSAJE_REL;
drop public synonym SQ_TIPOMENSAJE_REL;
drop public synonym SQ_TRANSACCIONES_DET;


----------ESQUEMA: INTRAWAY ---------------
----------------TABLAS --------------------

DROP TABLE INTRAWAY.INT_COMANDOXMENSAJE_ITW;
DROP TABLE INTRAWAY.INT_MENSAJE_ITW_CAB;    

---------- SECUENCIAS ---------------------

DROP SEQUENCE INTRAWAY.SQ_IDTRANMSJ;
DROP SEQUENCE INTRAWAY.SQ_IDDETTRANMSJ;

------------- SINONIMOS-------------------
drop public synonym INT_MENSAJE_ITW_CAB;
drop public synonym SQ_IDTRANMSJ;
drop public synonym int_comandoxmensaje_itw;
drop public synonym SQ_IDDETTRANMSJ;

----------ESQUEMA:HISTORICO ----------------
----------------TABLAS ---------------------

DROP TABLE HISTORICO.INT_COMANDOXMENSAJE_ITW_LOG;
DROP TABLE HISTORICO.INT_MENSAJE_ITW_CAB_LOG;       
DROP TABLE HISTORICO.OPE_COMANDO_REL_LOG;    
DROP TABLE HISTORICO.OPE_TRANSACCIONES_DET_LOG;    
DROP TABLE HISTORICO.OPE_SERVICIOMENSAJE_REL_LOG;    
DROP TABLE HISTORICO.OPE_TIPOMENSAJE_REL_LOG;    
DROP TABLE HISTORICO.OPE_SEGMENTOMERCADO_REL_LOG;    
DROP TABLE HISTORICO.OPE_PROCESOS_REL_LOG;    
DROP TABLE HISTORICO.OPE_PARAMETROS_DET_LOG;    
DROP TABLE HISTORICO.OPE_MENSAJES_MAE_LOG;   
DROP TABLE HISTORICO.OPE_INSCLIENTE_REL_LOG;    
DROP TABLE HISTORICO.OPE_INSCLIENTE_CAB_LOG;    
DROP TABLE HISTORICO.OPE_GRUPOS_REL_LOG;
DROP TABLE HISTORICO.OPE_GRUPOMENSSOL_DET_LOG;    
DROP TABLE HISTORICO.OPE_GRUPO_MENSAJES_DET_LOG;    
DROP TABLE HISTORICO.OPE_ESTADOSERVICIO_REL_LOG;
DROP TABLE HISTORICO.OPE_COMANDOPARAMETRO_REL_LOG;    
DROP TABLE HISTORICO.OPE_CONFFECHA_DET_LOG;    
DROP TABLE HISTORICO.OPE_ESTADOMENSAJE_DET_LOG;

------------- SINONIMOS-------------------
drop public synonym OPE_COMANDO_REL_LOG;
drop public synonym OPE_COMANDOPARAMETRO_REL_LOG;
drop public synonym OPE_CONFFECHA_DET_LOG;
drop public synonym OPE_GRUPO_MENSAJES_DET_LOG;
drop public synonym OPE_GRUPOMENSSOL_DET_LOG;
drop public synonym OPE_GRUPOS_REL_LOG;
drop public synonym OPE_INSCLIENTE_REL_LOG;
drop public synonym OPE_MENSAJES_MAE_LOG;
drop public synonym OPE_PARAMETROS_DET_LOG;
drop public synonym OPE_PROCESOS_REL_LOG;
drop public synonym OPE_SEGMENTOMERCADO_REL_LOG;
drop public synonym OPE_SERVICIOMENSAJE_REL_LOG;
drop public synonym OPE_TIPOMENSAJE_REL_LOG;
drop public synonym OPE_TRANSACCIONES_DET_LOG;
drop public synonym INT_COMANDOXMENSAJE_ITW_LOG;
drop public synonym INT_MENSAJE_ITW_CAB_LOG;

-----------VISTAS -----------------
DROP VIEW OPERACION.VM_OPE_FACTURAS;
DROP VIEW COLLECTIONS.V_OPE_INSTANCIA_SERVICIO;

--------------- Package --------------- 
DROP PACKAGE OPERACION.PQ_OPE_AVISO;

-- 15/12/2011

delete operacion.tipopedd where tipopedd=1069;
delete operacion.opedd where tipopedd=1069;
delete operacion.tipopedd where tipopedd=1071;
delete operacion.opedd where tipopedd=1071;

--PORTAL CAUTIVO FASE 2
drop table historico.actmacaddresspc_log;
drop table historico.tipequpc_log;
drop sequence historico.sq_actmacaddresspc_log;
drop sequence historico.sq_tipequpc_log;
drop trigger operacion.T_TIPEQU_AIUD;
drop package intraway.pq_homologar_int_sga;

-- Drop columns 
alter table OPERACION.TIPEQU drop column FLG_PORTAL_CAUTIVO;