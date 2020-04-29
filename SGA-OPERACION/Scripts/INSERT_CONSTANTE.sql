insert into OPERACION.CONSTANTE (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values ('CONDICION_BSCS', 'Condición de para consulta BSCS', 'C', 'OPERACION', to_date('16-10-2015 11:31:41', 'dd-mm-yyyy hh24:mi:ss'), '', ' and (a.ch_status=''d'' and a.ch_pending IS NULL AND e.tipestsol=5)');

insert into OPERACION.CONSTANTE (CONSTANTE, DESCRIPCION, TIPO, CODUSU, FECUSU, VALOR, OBS)
values ('MSJ_ANULA', 'MSJ DE ANULACIÓN DE SOT', 'C', 'OPERACION', to_date('16-10-2015 11:31:41', 'dd-mm-yyyy hh24:mi:ss'), 'Se anula debido a contrato desactivo. CO_ID : ', '');

COMMIT;
