CREATE OR REPLACE PACKAGE BODY operacion.pq_sva_claro_video IS
  /************************************************************************************************
  NOMBRE:     OPERACION.PQ_SVA_CLARO_VIDEO
  PROPOSITO:  SVA CLARO VIDEO
  
  REVISIONES:
   Version   Fecha          Autor                 Solicitado por      Descripcion
  --------   ----------    ------------------    -----------------    ------------------------
   1.0       21/04/2014    Luis Polo Benites     Alex Alamo           REQ-164966: Servicios SVA a traves de la Fija-Claro Video.
   2.0       20/08/2015    Luis Polo Benites     Fausto Soriano       SD 425564:  Mejoras en Lista de Proyectos -Servicios SVA a traves de la Fija.   
  /************************************************************************************************/
  /*********************************************************************
    PROCEDIMIENTO: Obtiene lista de proyectos
    PARAMETROS:
      Entrada:
        - av_codcliente:     Código de cliente
  
      Salida:
        - ac_list_proy_hfc:       Lista de proyectos por cliente
        - an_resultado:           0:OK   1:ERROR
        - ac_mensaje:             Descripción de Resultado
  *********************************************************************/
  PROCEDURE p_obt_list_proy_pq_hfc(av_codcliente    IN VARCHAR2,
                                   ac_list_proy_hfc OUT SYS_REFCURSOR,
                                   an_resultado     OUT NUMBER,
                                   ac_mensaje       OUT VARCHAR2) IS
    ln_resultado      NUMBER;
    lc_mensaje        VARCHAR2(900);
    ln_cant_servicios NUMBER;
  
  BEGIN
    ln_resultado := 0;
    lc_mensaje   := 'Exito';
  
    --Validamos obligatoriedad de INPUT
    IF av_codcliente IS NULL THEN
      ln_resultado := 1;
      lc_mensaje   := 'Código de Cliente SGA - Obligatorio';
      RETURN;
    END IF;
    --<ini 2.0>
    ln_cant_servicios := f_cant_servicios(av_codcliente);
    IF ln_cant_servicios > 0 THEN
    
      OPEN ac_list_proy_hfc FOR
      --<ini 2.0>
      
        SELECT DISTINCT s.numslc,
                        s.codcli,
                        s.codinssrv AS sid,
                        s.codsrv,
                        v.tipsrv,
                        t.dscsrv,
                        vt.dirsuc,
                        v.idsolucion,
                        so.solucion,
                        s.estinssrv,
                        s.numero
          FROM inssrv       s,
               vtatabslcfac v,
               soluciones   so,
               tystabsrv    t,
               vtasuccli    vt
         WHERE s.numslc = v.numslc
           AND v.codcli = av_codcliente
           AND v.tipsrv IN (SELECT c.codigoc
                              FROM tipcrmdd b, crmdd c
                             WHERE b.tipcrmdd = c.tipcrmdd
                               AND b.abrev = 'TIPSRV_SVA')
           AND s.tipsrv NOT IN (cv_ser_casilla)
           AND s.codsuc = vt.codsuc
           AND v.codcli = vt.codcli
           AND s.codsrv = t.codsrv
           AND v.idsolucion = so.idsolucion
           AND s.estinssrv IN (1, 2)
           AND s.codinssrv IN (SELECT DISTINCT f_obt_sid(s.numslc)
                                 FROM inssrv       s,
                                      vtatabslcfac v,
                                      soluciones   so,
                                      tystabsrv    t,
                                      vtasuccli    vt
                                WHERE s.numslc = v.numslc
                                  AND v.codcli = av_codcliente
                                  AND v.tipsrv IN
                                      (SELECT c.codigoc
                                         FROM tipcrmdd b, crmdd c
                                        WHERE b.tipcrmdd = c.tipcrmdd
                                          AND b.abrev = 'TIPSRV_SVA')
                                  AND s.tipsrv NOT IN (cv_ser_casilla)
                                  AND s.codsuc = vt.codsuc
                                  AND v.codcli = vt.codcli
                                  AND s.codsrv = t.codsrv
                                  AND v.idsolucion = so.idsolucion
                                  AND s.estinssrv IN (1, 2));
    
      --<fin 2.0>
    ELSE
      OPEN ac_list_proy_hfc FOR
        SELECT NULL numslc,
               NULL codcli,
               NULL sid,
               NULL codsrv,
               NULL tipsrv,
               NULL dscsrv,
               NULL dirsuc,
               NULL idsolucion,
               NULL solucion,
               NULL estinssrv,
               NULL numero
          FROM dual;
      ln_resultado := 0;
      lc_mensaje   := 'No se encontraron registros de búsqueda.';
    END IF;
  
    an_resultado := ln_resultado;
    ac_mensaje   := lc_mensaje;
  EXCEPTION
    WHEN OTHERS THEN
      an_resultado := -1;
      ac_mensaje   := 'Error BD: ' || SQLCODE || ' ' || SQLERRM;
  END;
  /* **********************************************************************************************/
  /*********************************************************************
    PROCEDIMIENTO: Obtiene el CODINSSRV(SID) principal de un proyecto según las siguientes prioridades 
                   (1° Internet, 2° Cable, 3° Teléfono):
    PARAMETROS:
      Entrada:
        - av_numslc:     Número de proyecto
  
      Salida:
        - an_codinssrv:       Código de instancia de servicio
        - an_resultado:       0:OK   1:ERROR   -1:ERROR BD
        - ac_mensaje:         Descripción de Resultado
  *********************************************************************/
  PROCEDURE p_obt_sid_principal_hfc(av_numslc    IN VARCHAR2,
                                    an_codinssrv OUT NUMBER,
                                    an_resultado OUT NUMBER,
                                    ac_mensaje   OUT VARCHAR2) IS
    ln_sid_internet  inssrv.codinssrv%TYPE;
    ln_sid_cable     inssrv.codinssrv%TYPE;
    ln_sid_telefonia inssrv.codinssrv%TYPE;
    ln_codinssrv     inssrv.codinssrv%TYPE;
    ln_resultado     NUMBER;
    lc_mensaje       VARCHAR2(2000);
    e_error EXCEPTION;
  
    CURSOR cur_sid(av_numslc IN VARCHAR2) IS
      SELECT i.codinssrv, ty.tipsrv
        FROM inssrv       i,
             tipinssrv    t,
             tystipsrv    ty,
             tystabsrv    tys,
             producto     p,
             vtatabslcfac v
       WHERE v.tipsrv IN (SELECT c.codigoc
                            FROM tipcrmdd b, crmdd c
                           WHERE b.tipcrmdd = c.tipcrmdd
                             AND b.abrev = 'TIPSRV_SVA'
                             AND c.abreviacion = 'PAQ_MAS')
         AND v.numslc = i.numslc
         AND i.numslc = av_numslc
         AND t.tipinssrv = i.tipinssrv
         AND ty.tipsrv = i.tipsrv
         AND tys.codsrv = i.codsrv
         AND tys.idproducto = p.idproducto
         AND i.estinssrv IN (1, 2);
  
  BEGIN
    ln_resultado := 0;
    lc_mensaje   := 'Exito';
  
    FOR reg IN cur_sid(av_numslc) LOOP
      IF reg.tipsrv = cv_ser_internet THEN
        ln_sid_internet := reg.codinssrv;
      ELSIF reg.tipsrv = cv_ser_cable THEN
        ln_sid_cable := reg.codinssrv;
      ELSIF reg.tipsrv = cv_ser_telefonia THEN
        ln_sid_telefonia := reg.codinssrv;
      END IF;
    END LOOP;
  
    IF ln_sid_internet > 0 THEN
      ln_codinssrv := ln_sid_internet;
      GOTO salto;
    ELSIF ln_sid_cable > 0 THEN
      ln_codinssrv := ln_sid_cable;
      GOTO salto;
    ELSIF ln_sid_telefonia > 0 THEN
      ln_codinssrv := ln_sid_telefonia;
    END IF;
  
    IF ln_codinssrv IS NULL THEN
      ln_resultado := 0;
      lc_mensaje   := 'No se encontraron registros de búsqueda.';
      GOTO salto;
    END IF;
  
    <<salto>>
    an_codinssrv := ln_codinssrv;
    an_resultado := ln_resultado;
    ac_mensaje   := lc_mensaje;
  EXCEPTION
    WHEN OTHERS THEN
      an_resultado := -1;
      ac_mensaje   := 'Error BD: ' || SQLCODE || ' ' || SQLERRM;
  END;
  /* **********************************************************************************************/
  /*********************************************************************
    PROCEDIMIENTO: Obtiene el SID principal según las siguientes prioridades 
                   (1° Teléfono, 2° Internet, 3° Cable) 
    PARAMETROS:
      Entrada:
        - av_numslc:     Número de proyecto
  
      Salida:
        - ln_codinssrv:       Código de instancia de servicio
  *********************************************************************/
  --<ini 2.0>
  FUNCTION f_obt_sid(av_numslc IN VARCHAR2) RETURN NUMBER IS
    ln_sid_internet  inssrv.codinssrv%TYPE;
    ln_sid_cable     inssrv.codinssrv%TYPE;
    ln_sid_telefonia inssrv.codinssrv%TYPE;
    ln_codinssrv     inssrv.codinssrv%TYPE;
    ln_resultado     NUMBER;
    lc_mensaje       VARCHAR2(2000);
  
    CURSOR c_sid_proy(av_numslc IN VARCHAR2) IS
      SELECT i.codinssrv, i.tipsrv
        FROM inssrv i, vtatabslcfac v
       WHERE v.tipsrv IN (SELECT c.codigoc
                            FROM tipcrmdd b, crmdd c
                           WHERE b.tipcrmdd = c.tipcrmdd
                             AND b.abrev = 'TIPSRV_SVA')
         AND v.numslc = i.numslc
         AND i.numslc = av_numslc
         AND i.estinssrv IN (1, 2);
  
  BEGIN
    ln_resultado := 0;
    lc_mensaje   := 'Exito';
  
    FOR reg IN c_sid_proy(av_numslc) LOOP
      IF reg.tipsrv = cv_ser_telefonia THEN
        ln_sid_telefonia := reg.codinssrv;
      ELSIF reg.tipsrv = cv_ser_internet THEN
        ln_sid_internet := reg.codinssrv;
      ELSIF reg.tipsrv = cv_ser_cable THEN
        ln_sid_cable := reg.codinssrv;
      END IF;
    END LOOP;
  
    IF ln_sid_telefonia > 0 THEN
      ln_codinssrv := ln_sid_telefonia;
      GOTO salto;
    ELSIF ln_sid_internet > 0 THEN
      ln_codinssrv := ln_sid_internet;
      GOTO salto;
    ELSIF ln_sid_cable > 0 THEN
      ln_codinssrv := ln_sid_cable;
    END IF;
  
    IF ln_codinssrv IS NULL THEN
      ln_resultado := 0;
      lc_mensaje   := 'No se encontraron registros de búsqueda.';
      GOTO salto;
    END IF;
  
    <<salto>>
  
    RETURN ln_codinssrv;
  EXCEPTION
    WHEN OTHERS THEN
      ln_codinssrv := NULL;
      RETURN ln_codinssrv;
  END;
  /* **********************************************************************************************/

  /*********************************************************************
    PROCEDIMIENTO: Cantidad de servicios de un cliente en estado activo o suspendido.
    PARAMETROS:
      Entrada:
        - av_codcliente:     Código de cliente
  
      Salida:
        - ln_contado:       Cantidad de servicios por cliente        
  *********************************************************************/
  FUNCTION f_cant_servicios(av_codcliente IN VARCHAR2) RETURN VARCHAR2 IS
    ln_contado VARCHAR2(8);
  BEGIN
    SELECT COUNT(i.numslc)
      INTO ln_contado
      FROM inssrv i, vtatabslcfac v
     WHERE i.codcli = av_codcliente
       AND i.numslc = v.numslc
       AND v.tipsrv IN (SELECT c.codigoc
                          FROM tipcrmdd b, crmdd c
                         WHERE b.tipcrmdd = c.tipcrmdd
                           AND b.abrev = 'TIPSRV_SVA')
       AND i.estinssrv IN (1, 2)
       AND i.tipsrv NOT IN (cv_ser_casilla);
  
    RETURN ln_contado;
  END;
  --<fin 2.0>
END;
/