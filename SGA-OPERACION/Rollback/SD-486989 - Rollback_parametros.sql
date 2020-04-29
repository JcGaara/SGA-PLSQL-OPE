DELETE FROM operacion.opedd o
       WHERE EXISTS ( SELECT 1 
                               FROM operacion.tipopedd 
                               WHERE abrev = 'PRC_HFC_OPT_OV' 
                               AND tipopedd = o.tipopedd);

DELETE FROM operacion.tipopedd c
      WHERE c.abrev = 'PRC_HFC_OPT_OV';        

     
COMMIT;