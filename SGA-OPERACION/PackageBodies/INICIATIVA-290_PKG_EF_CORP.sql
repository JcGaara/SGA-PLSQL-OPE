CREATE OR REPLACE PACKAGE BODY OPERACION.pkg_ef_corp IS
/****************************************************************
'* Nombre Package : <PKG_EF_CORP>
'* Propósito : Repositorio de la lógica de Estudios de factibilidad corporativa
'* Creado por : <Célula Factibilidad Corporativa>
'* Fec Creación : <2020/02/20>
'* Fec Actualización : <2020/02/20>
'****************************************************************/

  /****************************************************************
  '* Nombre SP : SGASS_DIAS_PLAZO
  '* Propósito : Obtener los días de plazo para las áreas de Estudio de factibilidad según reglas configuradas
  '* Input : <pi_codef> - Código de EF
  '* Output : <po_qty_dias_plazo> - Cantidad de días
  '* Creado por : <Célula Factibilidad Corporativa>
  '* Fec Creación : <2020/02/20>
  '* Fec Actualización : <2020/02/20>
  '****************************************************************/
  PROCEDURE sgass_dias_plazo(pi_codef NUMBER, po_qty_dias_plazo OUT NUMBER) IS
    ln_codef         NUMBER;
    ln_qty_diasplazo NUMBER;
    ln_i             NUMBER;
    ln_diapla        NUMBER;
    ln_exists        NUMBER;

  BEGIN
    ln_codef         := pi_codef;
    ln_i             := 1;
    ln_qty_diasplazo := 1;
    ln_diapla        := 1;
    ln_exists        := 0;

    --Busca reglas de sumatoria
    SELECT COUNT(o.idopedd)
      INTO ln_exists
      FROM operacion.opedd o
     INNER JOIN operacion.tipopedd t
        ON (o.tipopedd = t.tipopedd)
     WHERE t.abrev = 'REG_SUM_DIAPLA_EF';

    IF nvl(ln_exists, 0) > 0 THEN
      --Evalua la sumatoria de todas las reglas
      WHILE ln_exists > 0 LOOP
        SELECT nvl(SUM(sa.numdiapla), 0) + 1
          INTO ln_diapla
          FROM operacion.solefxarea sa
         INNER JOIN operacion.areaope ao
            ON (sa.area = ao.area)
         WHERE sa.codef = ln_codef
           AND ao.open_flgsum = 1
           AND sa.area IN (SELECT o.codigon
                             FROM operacion.opedd o
                            INNER JOIN operacion.tipopedd t
                               ON (o.tipopedd = t.tipopedd)
                            WHERE t.abrev = 'REG_SUM_DIAPLA_EF'
                              AND o.codigon_aux = ln_i);

        --Si la sumatoria actual es mayor que la anterior, se actualiza la variable
        IF ln_diapla > ln_qty_diasplazo THEN
          ln_qty_diasplazo := ln_diapla;
        END IF;

        ln_i := ln_i + 1;

        --Se verifica que existan reglas adicionales
        SELECT COUNT(o.idopedd)
          INTO ln_exists
          FROM operacion.opedd o
         INNER JOIN operacion.tipopedd t
            ON (o.tipopedd = t.tipopedd)
         WHERE t.abrev = 'REG_SUM_DIAPLA_EF'
           AND o.codigon_aux = ln_i;
      END LOOP;
      /*ELSE
      --No existen reglas, mostrar error*/
    END IF;
    --Devolución del dato de la sumatoria
    po_qty_dias_plazo := ln_qty_diasplazo;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20000,
                              $$PLSQL_UNIT || '.sgass_dias_plazo: ' ||
                              SQLERRM);
      ROLLBACK;
  END sgass_dias_plazo;

END pkg_ef_corp;
/