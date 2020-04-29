DELETE FROM operacion.opedd o
       WHERE EXISTS ( SELECT 1 
                               FROM operacion.tipopedd 
                               WHERE abrev = 'PRC_HFC_BULKCOLLECT_LIMIT' 
                               AND tipopedd = o.tipopedd);

DELETE FROM operacion.tipopedd c
      WHERE c.abrev = 'PRC_HFC_BULKCOLLECT_LIMIT';        

     
COMMIT;