DECLARE
    V_AREA_SOLOT        OPERACION.TIPOPEDD.TIPOPEDD%TYPE;
    V_FLAG_ACTUALIZA    OPERACION.TIPOPEDD.TIPOPEDD%TYPE;
BEGIN


    Insert into OPERACION.TIPOPEDD
       (DESCRIPCION, ABREV)
     Values
       ('Area Solot', 'AREA-SOLOT')
    RETURNING TIPOPEDD INTO V_AREA_SOLOT;


    Insert into OPERACION.TIPOPEDD
       (DESCRIPCION, ABREV)
     Values
       ('Flag Actualizacion Area', 'FLAG-ACTUALIZACION-AREA')
    RETURNING TIPOPEDD INTO V_FLAG_ACTUALIZA;

    COMMIT;




    Insert into OPERACION.OPEDD
       (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
     Values
       ('CLOUD', 324, 'AREA CLOUD', 
        'CLOUD', V_AREA_SOLOT);
        
    Insert into OPERACION.OPEDD
       (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
     Values
       ('WLL', 325, 'AREA WLL', 
        'WLL', V_AREA_SOLOT);
    Insert into OPERACION.OPEDD
       (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
     Values
       ('HFC', 200, 'AREA HFC', 
        'HFC', V_AREA_SOLOT);
    Insert into OPERACION.OPEDD
       (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
     Values
       ('DTH', 325, 'AREA DTH', 
        'DTH', V_AREA_SOLOT);
        
        
        
    Insert into OPERACION.OPEDD
       (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD)
     Values
       ('FLAG', 1, 'Flag Actualizacion Area', 
        'Flag Actualizacion Area', V_FLAG_ACTUALIZA);

    COMMIT;
    

END;
/