  /******************************************************************************
  Ver        Date        Author                      Description
  ---------  ----------  ---------------             ------------------------------------
  1.0        26/05/2015  Steve Panduro/Jorge Rivas/  Actualiza Centro Poblado
                         Justiniano Condori   
  ******************************************************************************/
  DECLARE
    an_error NUMBER;
    av_error NUMBER;
    TYPE t_array_varchar2 IS TABLE OF VARCHAR2(10);
    TYPE t_array_number IS TABLE OF NUMBER(10);
    ln_codsolot      t_array_number;
    lv_codcli        t_array_varchar2;
    lv_codsuc        t_array_varchar2;
    lv_poblado       t_array_varchar2;
    lv_centropoblado varchar2(20);
    ii               NUMBER;
  
    ln_limit NUMBER;
    CURSOR cur_sot IS
      SELECT a.codsolot, a.codcli, b.codsuc, NULL
        FROM operacion.solot a, operacion.agendamiento b
       WHERE a.codsolot = b.codsolot
         AND a.tiptra IN (SELECT tiptra
                            FROM tiptrabajo
                           WHERE descripcion LIKE '%DTH%INST%'
                              OR descripcion LIKE '%INST%DTH%')
         AND a.estsol <> 13 -- anulado
         AND b.estage <> 5 -- cancelado
      ;
    e_error EXCEPTION;
  BEGIN
    an_error := 0;
    av_error := '';
    ln_limit := 1000;
    OPEN cur_sot;
    LOOP
      FETCH cur_sot BULK COLLECT
        INTO ln_codsolot, lv_codcli, lv_codsuc, lv_poblado LIMIT ln_limit;
      BEGIN
        FOR i IN 1 .. ln_codsolot.COUNT LOOP
          BEGIN
            SELECT MAX(centropoblado)
              INTO lv_poblado(i)
              FROM pvt.tabservicio@dbl_webuni
             WHERE centropoblado <> 0
               AND centropoblado IS NOT NULL
               AND codsolot = ln_codsolot(i);
          EXCEPTION
            WHEN no_data_found THEN
              NULL;
          END;
        END LOOP;
      
        FORALL i IN 1 .. ln_codsolot.count SAVE EXCEPTIONS
          UPDATE /*+index(vtasuccli PK_VTASUCCLI)*/ marketing.vtasuccli
             SET ubigeo2 = DECODE(lv_poblado(i),NULL,ubigeo2,lv_poblado(i))
           WHERE codsuc = lv_codsuc(i);
      
        ii := ii + 1;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE e_error;
      END;
      COMMIT;
      EXIT WHEN cur_sot%NOTFOUND;
    END LOOP;
    CLOSE cur_sot;
  EXCEPTION
    WHEN e_error THEN
      an_error := -1;
      av_error := 'Error al Actualizar la Tabla MARKETING.vtasuccli ' ||
                  SQLERRM;
    WHEN OTHERS THEN
      an_error := -1;
      av_error := 'Error ' || SQLERRM;
  END;
/