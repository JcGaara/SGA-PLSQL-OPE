----------ESQUEMA: OPERACION ---------------
------------------TABLAS -------------------

DROP TABLE OPERACION.OPE_MENSAJES_MAE;    
DROP TABLE OPERACION.OPE_COMANDO_REL;    
DROP TABLE OPERACION.OPE_PARAMETROS_DET;    
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

------------- SECUENCIAS -------------------

DROP SEQUENCE OPERACION.SQ_COMANDO_REL;
DROP SEQUENCE OPERACION.SQ_COMANDOPARAMETRO_REL;
DROP SEQUENCE OPERACION.SQ_CONFFECHADET;
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
drop public synonym OPE_CONFFECHA_DET;
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
DROP MATERIALIZED VIEW OPERACION.VM_OPE_FACTURAS;
DROP MATERIALIZED VIEW COLLECTIONS.VM_OPE_INSTANCIA_SERVICIO;
