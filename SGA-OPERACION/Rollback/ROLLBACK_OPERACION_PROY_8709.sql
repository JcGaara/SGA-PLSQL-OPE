DELETE FROM OPERACION.CONSTANTE a WHERE a.constante in('TARGET_URL_DESP','RESP_WS_DESP','ACTION_URL_DESP','OPERACIONES_SGA','MOVDESP');
COMMIT;

ALTER TABLE OPERACION.SOLOTPTOEQU drop column SPTOC_EST_DESPACHO;

ALTER TABLE OPERACION.SOLOTPTOEQU drop column SPTON_DCTOSAP;
DROP PROCEDURE OPERACION.OPESI_CARGA_LOG_DESPACHO;
--PERMISOS
  revoke select on operacion.SOLOTPTO from webservice;
  revoke select on operacion.AGENDAMIENTOCHGEST from webservice;
  revoke select on operacion.AGENDAMIENTO from webservice;
  revoke select on operacion.tipequ from webservice;
  revoke select on operacion.solotptoequ from webservice;
  revoke select on operacion.solot from webservice;
  revoke select on operacion.sucursalxcontrata from webservice;
  revoke select on operacion.deptxcontrata from webservice;

   revoke update on operacion.solotptoequ from webservice;
 
  

