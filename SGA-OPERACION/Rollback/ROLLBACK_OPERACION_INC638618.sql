DROP TRIGGER  OPERACION.T_OPE_CONFIG_ACCION_JANUS;
DROP SEQUENCE OPERACION.SEQ_OPE_CONFIG_ACCION_JANUS;
DROP TABLE OPERACION.OPE_CONFIG_ACCION_JANUS;

DELETE FROM SGACRM.INV_VENTANAXPAR P
 WHERE P.IDVENTANA IN (SELECT I.IDVENTANA
             FROM SGACRM.INV_VENTANA I
            WHERE I.NOMBRE = 'w_md_sga_act_lte');

DELETE FROM OPEWF.TAREADEFVENTANA T
 WHERE T.IDVENTANA IN (SELECT I.IDVENTANA
						 FROM SGACRM.INV_VENTANA I
						WHERE I.NOMBRE = 'w_md_sga_act_lte');
            
DELETE FROM SGACRM.INV_VENTANA I WHERE I.NOMBRE = 'w_md_sga_act_lte';
DELETE FROM OPERACION.CONSTANTE WHERE  CONSTANTE = 'IND_COD_ID_LTE';
commit						
/

