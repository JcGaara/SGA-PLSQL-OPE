-------------------  INSERTAR URL
insert into operacion.constante
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('TARGET_URL_WS  ',
   'Target URL de WS',
   'C',
   user,
   sysdate,
   'http://172.19.74.138:8903/SAP_Services/Transaction/InterfaceSga/TransaccionInterfaceSga?wsdl',
   '');
------------------ INSERTAR ACTION
insert into constante
  (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values
  ('ACTION_SGASAP  ',
   'ACTION__INTERF_SGA_SAP',
   'C',
   user,
   sysdate,
   'http://claro.com.pe/esb/InterfaceSga',
   '');

COMMIT;