DELETE FROM OPERACION.OPEDD
WHERE TIPOPEDD = (select T.TIPOPEDD
                  from OPERACION.TIPOPEDD T
                  WHERE T.ABREV = 'TIPO_TRANS_SIAC_LTE')
AND CODIGOC = '1'
AND CODIGON = (select TIPTRA
              from TIPTRABAJO
              WHERE DESCRIPCION = 'WLL/SIAC - TRASLADO EXTERNO')
and codigon_aux = 1;

DELETE FROM OPERACION.OPEDD
WHERE TIPOPEDD = (select T.TIPOPEDD
                  from OPERACION.TIPOPEDD T
                  WHERE T.ABREV = 'TIPO_TRANS_SIAC_LTE')
AND CODIGOC = '1'
AND CODIGON = (select TIPTRA
              from TIPTRABAJO
              WHERE DESCRIPCION = 'WLL/SIAC - TRASLADO INTERNO')
and codigon_aux = 1;
commit;
/