   -- Eliminacion de Constantes

   DELETE FROM CONSTANTE WHERE CONSTANTE = 'CONF_AGENDA_LTE';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'CONF_PAIS_LTE';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'CONF_LV_LTE';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'CONF_TC_LTE';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'CONF_CODBAN_LTE';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'CONF_TIPDOC_LTE';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'PROV_TIP_EQU';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'PROV_MOD_EQU';
   DELETE FROM CONSTANTE WHERE CONSTANTE = 'TIPO_EQUIPO_LTE';
   COMMIT;

   DELETE FROM OPEDD
   WHERE TIPOPEDD = (SELECT TIPOPEDD
                       FROM OPERACION.TIPOPEDD
                      WHERE ABREV = 'TIP_TRA_CSR')
     AND DESCRIPCION IN ('WLL/SIAC - ACTIVACION SERVICIOS ADICIONALES','WLL/SIAC - DESACTIVACION SERVICIOS ADICIONALES');
   COMMIT;

   DELETE FROM TIPTRABAJO WHERE DESCRIPCION = 'WLL/SIAC - ACTIVACION SERVICIOS ADICIONALES';
   COMMIT;
         
   DELETE FROM TIPTRABAJO WHERE DESCRIPCION = 'WLL/SIAC - DESACTIVACION SERVICIOS ADICIONALES';
   COMMIT;