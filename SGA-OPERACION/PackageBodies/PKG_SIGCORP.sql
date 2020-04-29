CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_SIGCORP AS
  /***********************************************************************************************************
    Version     Fecha       Autor            Solicitado por   Descripción.
    ---------  ----------  ---------------   --------------   ------------------------------------------------
      1.0      15/02/2018  Danny Sánchez     Mario Hidalgo    Cambios control de Tareas
      2.0      18/05/2018  Jeannette Monroy  Mario Hidalgo    Buscar nombre usuario y Log de auditoria
      3.0      16/10/2018  Wilfredo Argote   Manuel Mendosa   Validación de SOT
      4.0      24/06/2019  Jesús Holguín     Vanessa Aparicio Validación de código de clientes y CID Upgrade/Downgrade.
      5.0      21/06/2019  Jesús Holguín     Vanessa Aparicio Validación de existencia de Proyectos en Curso.
      6.0      25/06/2019  Jesús Holguín     Vanessa Aparicio Aprobaciones del Proyecto Generado.
      7.0      05/08/2019  Jesús Holguín     Vanessa Aparicio Generación de SOT.
      8.0      05/08/2019  Jesús Holguín     Vanessa Aparicio Generación de Proyectos Automáticamente.
      9.0      26/09/2019  Johana Roque      Vanessa Aparicio Obtención de los clientes moviles corporativos.
     10.0      10/10/2019  Jesús Holguín     Vanessa Aparicio Actualiza tabla Créditos desde modulo Rentabilidad y Créditos.
     11.0      18/10/2019  Johana Roque      Vanessa Aparicio Obtención de sots de adecuación de capacidad y puertos
     12.0      12/11/2019  Jesús Holguín     Vanessa Aparicio Validación de datos del contacto.
  ***********************************************************************************************************/
  --Ini 1.0
  PROCEDURE SP_DWFILTRO(as_area in number, an_rep in number) IS

    lb_dw        clob;
    ls_cabecera  VARCHAR2(4000);
    ls_opc       VARCHAR2(4000);
    ls_variable  VARCHAR2(100);
    ls_tipo      VARCHAR2(100);
    ll_venheigth NUMBER;
    ll_width     NUMBER;
    ll_pos       NUMBER;
    ll_posy      NUMBER;
    ll_cant      NUMBER;
    ll_var       NUMBER;
    ll_campo     NUMBER;
    ll_tab       NUMBER;

    TYPE T_ARRAY_REG IS RECORD(
      L_CAMPO   VARCHAR2(100),
      L_COLUMNA VARCHAR2(4000));
    TYPE T_ARRAY_TAB IS TABLE OF T_ARRAY_REG INDEX BY PLS_INTEGER;
    V_ARRAY T_ARRAY_TAB;

    cursor CUR_FILTRO is
      SELECT CAMPO,
             ALIAS,
             TIPO,
             CONDICION,
             BOTON,
             DDDFIL,
             DISDDDFIL,
             DATADDDFIL
        FROM OPERACION.AREAOPE_CAMPO
       WHERE area = as_area
         AND codquery = an_rep
         AND opcfil = 1
       ORDER BY ITEM ASC;

  BEGIN
    SELECT count(item)
      into ll_cant
      FROM OPERACION.AREAOPE_CAMPO
     WHERE area = as_area
       AND codquery = an_rep
       AND opcfil = 1;

    IF ll_cant > 0 THEN
      BEGIN
        ll_venheigth := 200 + (ll_cant * 88);
        ls_cabecera  := 'release 8;
         datawindow(units=0 timer_interval=0 color=80269524 processing=0 HTMLDW=no print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 96 print.margin.bottom = 96 print.paper.source = 0 print.paper.size = 0 print.prompt=no print.buttons=no print.preview.buttons=no )
         summary(height=0 color="536870912" )
         footer(height=0 color="536870912" )
         detail(height=' || TO_CHAR(ll_venheigth) ||
                        ' color="536870912" )
         table(';

        lb_dw    := ls_cabecera;
        ll_var   := 0;
        ll_campo := 0;

        FOR C in CUR_FILTRO LOOP
          ll_campo := ll_campo + 1;
          ll_posy  := 60 + ((ll_campo - 1) * 88);
          IF c.boton = 1 THEN
            ll_width := 800;
          ELSE
            ll_width := 1000;
          END IF;

          -------------------- Checkbox --------------------------
          ls_variable := 'f_' || c.campo;
          ls_opc := 'column=(type=NUMBER updatewhereclause=no name=' ||
                    ls_variable || ' dbname="' || ls_variable ||
                    '" values="' || C.ALIAS || '	0/' || C.ALIAS || '	1" )' ||
                    CHR(13);
          ll_var := ll_var + 1;
          ll_tab := ll_var * 10;
          V_ARRAY(ll_var).l_campo := ls_variable;
          V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                       TO_CHAR(ll_var) ||
                                       ' alignment="0" tabsequence=' ||
                                       TO_CHAR(ll_tab) ||
                                       ' border="0" color="33554432" x="18" y="' ||
                                       TO_CHAR(ll_posy) ||
                                       '" height="64" width="649" format="[general]" html.valueishtml="0"  name=' ||
                                       ls_variable ||
                                       ' visible="1" checkbox.text="' ||
                                       C.ALIAS ||
                                       '" checkbox.on="0" checkbox.off="1" checkbox.scale=no checkbox.threed=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="80269524" ) ' ||
                                       CHR(13);
          lb_dw := lb_dw || ls_opc;
          --------------------------------------------------------------

          -------------------- CAMPO DE TEXTO --------------------------
          IF c.condicion = 1 OR c.condicion = 2 THEN
            ls_variable := c.campo;
            ll_pos      := INSTR(c.tipo, '(');
            IF ll_pos > 0 THEN
              ls_tipo := SUBSTR(c.tipo, 1, ll_pos - 1);
            ELSE
              ls_tipo := c.tipo;
            END IF;

            ls_opc := 'column=(type=' || c.tipo ||
                      ' updatewhereclause=no name=' || ls_variable ||
                      ' dbname="' || ls_variable || '" )';
            lb_dw := lb_dw || ls_opc;
            ll_var := ll_var + 1;
            ll_tab := ll_var * 10;
            V_ARRAY(ll_var).l_campo := ls_variable;
            --ll_limit := (c.tipo);
            ------------------------------------------------------------------------

            IF c.DDDFIL IS NULL OR LENGTH(TRIM(c.DDDFIL)) = 0 THEN
              IF ls_tipo = 'char' OR ls_tipo = 'varchar2' THEN
                V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                             TO_CHAR(ll_var) ||
                                             ' alignment="0" tabsequence=' ||
                                             TO_CHAR(ll_tab) ||
                                             ' border="5" color="33554432" x="700" y="' ||
                                             TO_CHAR(ll_posy) ||
                                             '" height="64" width="' ||
                                             TO_CHAR(ll_width) ||
                                             '" format="[general]" html.valueishtml="0"  name=' ||
                                             ls_variable ||
                                             ' visible="1" edit.limit=0 edit.case=upper edit.focusrectangle=no edit.autoselect=yes edit.imemode=0  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )' ||
                                             CHR(13);
              ELSIF ls_tipo = 'decimal' OR ls_tipo = 'number' THEN
                V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                             TO_CHAR(ll_var) ||
                                             ' alignment="0" tabsequence=' ||
                                             TO_CHAR(ll_tab) ||
                                             ' border="5" color="33554432" x="700" y="' ||
                                             TO_CHAR(ll_posy) ||
                                             '" height="64" width="' ||
                                             TO_CHAR(ll_width) ||
                                             '" format="[general]" html.valueishtml="0"  name=' ||
                                             ls_variable ||
                                             ' visible="1" editmask.mask="#########" editmask.imemode=0 editmask.focusrectangle=no font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )' ||
                                             CHR(13);
              ELSE
                V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                             TO_CHAR(ll_var) ||
                                             ' alignment="2" tabsequence=' ||
                                             TO_CHAR(ll_tab) ||
                                             ' border="5" color="33554432" x="700" y="' ||
                                             TO_CHAR(ll_posy) ||
                                             '" height="64" width="425" format="[general]" html.valueishtml="0"  name=' ||
                                             ls_variable ||
                                             ' visible="1" editmask.mask="[date]" editmask.imemode=0 editmask.focusrectangle=no font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )' ||
                                             CHR(13);
              END IF;
            ELSE
              V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                           TO_CHAR(ll_var) ||
                                           ' alignment="0" tabsequence=' ||
                                           TO_CHAR(ll_tab) ||
                                           ' border="5" color="33554432" x="700" y="' ||
                                           TO_CHAR(ll_posy) ||
                                           '" height="64" width="' ||
                                           TO_CHAR(ll_width) ||
                                           '" format="[general]" html.valueishtml="0"  name=' ||
                                           ls_variable ||
                                           ' visible="1" dddw.name=' ||
                                           C.DDDFIL ||
                                           ' dddw.displaycolumn=' ||
                                           C.DISDDDFIL ||
                                           ' dddw.datacolumn=' ||
                                           C.DATADDDFIL ||
                                           ' dddw.percentwidth=100 dddw.lines=6 dddw.limit=0 dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.imemode=0 dddw.vscrollbar=yes  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )' ||
                                           CHR(13);
            END IF;
          ELSE
            ls_variable := c.campo || '_ini';
            ls_opc := 'column=(type=date updatewhereclause=no name=' ||
                      ls_variable || ' dbname="' || ls_variable ||
                      '" initial="today"  )';
            lb_dw := lb_dw || ls_opc;
            ll_var := ll_var + 1;
            ll_tab := ll_var * 10;
            V_ARRAY(ll_var).l_campo := ls_variable;
            V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                         TO_CHAR(ll_var) ||
                                         ' alignment="2" tabsequence=' ||
                                         TO_CHAR(ll_tab) ||
                                         ' border="5" color="33554432" x="700" y="' ||
                                         TO_CHAR(ll_posy) ||
                                         '" height="64" width="425" format="[general]" html.valueishtml="0"  name=' ||
                                         ls_variable ||
                                         ' visible="1" editmask.mask="[date]" editmask.imemode=0 editmask.focusrectangle=no  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )' ||
                                         CHR(13);
            ls_variable := c.campo || '_fin';
            ls_opc := 'column=(type=date updatewhereclause=no name=' ||
                      ls_variable || ' dbname="' || ls_variable ||
                      '" initial="today"  )';
            lb_dw := lb_dw || ls_opc;
            ll_var := ll_var + 1;
            ll_tab := ll_var * 10;
            V_ARRAY(ll_var).l_campo := ls_variable;
            V_ARRAY(ll_var).l_columna := 'column(band=detail id=' ||
                                         TO_CHAR(ll_var) ||
                                         ' alignment="2" tabsequence=' ||
                                         TO_CHAR(ll_tab) ||
                                         ' border="5" color="33554432" x="1253" y="' ||
                                         TO_CHAR(ll_posy) ||
                                         '" height="64" width="425" format="[general]" html.valueishtml="0"  name=' ||
                                         ls_variable ||
                                         ' visible="1" editmask.mask="[date]" editmask.imemode=0 editmask.focusrectangle=no  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )' ||
                                         CHR(13);
          END IF;
        END LOOP;

        lb_dw := lb_dw || ')' || CHR(13);

        FOR CX IN V_ARRAY.FIRST .. V_ARRAY.LAST LOOP
          lb_dw := lb_dw || V_ARRAY(CX).l_columna || CHR(13);
        END LOOP;

        ll_campo := 0;
        FOR C in CUR_FILTRO LOOP
          ll_campo := ll_campo + 1;
          IF c.boton = 1 THEN
            ll_posy     := 60 + ((ll_campo - 1) * 88);
            ls_variable := 'b_' || c.campo;
            ls_opc      := 'button(band=detail text="..."filename=""action="0" border="0" color="0" x="1540" y="' ||
                           TO_CHAR(ll_posy) ||
                           '" height="64" width="151" vtextalign="0" htextalign="0"  name=' ||
                           ls_variable ||
                           ' visible="1"  font.face="Arial" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="67108864" )' ||
                           CHR(13);
            lb_dw       := lb_dw || ls_opc;
          END IF;
        END LOOP;

        lb_dw := lb_dw ||
                 'htmltable(border="1" )
              htmlgen(clientevents="1" clientvalidation="1" clientcomputedfields="1" clientformatting="0" clientscriptable="0" generatejavascript="1" netscapelayers="0" )';

        UPDATE OPERACION.AREAOPE_QUERY
           SET filtrodw = lb_dw
         WHERE AREA = as_area
           AND CODQUERY = an_rep;

      EXCEPTION
        WHEN OTHERS THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('Error al generar el filtro - Codigo Error:' ||
                               TO_CHAR(SQLCODE) || CHR(13) ||
                               ' - Mensaje Error:' || TO_CHAR(SQLERRM) ||
                               CHR(13) || ' - Linea Error:' ||
                               DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      END;
    END IF;

  END;
  --Fin 1.0

  FUNCTION F_CALC_DIAS_UTILES(dFechaIni DATE, dFechaFin DATE) RETURN NUMBER IS
    /************************************************************
    NOMBRE:     OPERACION.PQ_SIGCORP.F_CALC_DIAS_UTILES
    PROPOSITO:  Calcula la cantidad de días útiles entre dos fechas. Exluye sábados, domingos y feriados calendario.
    Ver        Fecha        Autor             Descripción
    ---------  ----------  ---------------    ------------------------
    1.0        20/11/2017  Anderson Julca V.  Versión inicial
    ***********************************************************/

    Dias NUMBER;

  BEGIN
    SELECT (((dFechaFin - dFechaIni) -
           (SELECT COUNT(DISTINCT fecini)
                FROM tlftabfer
               WHERE TRUNC(fecini) BETWEEN TRUNC(dFechaIni) AND
                     TRUNC(dFechaFin)
                 AND (TO_CHAR(fecini, 'DY', 'nls_date_language=english') NOT IN
                      ('SAT', 'SUN'))) -
           (((next_day(TRUNC(dFechaFin), 'SÁBADO') - 7 -
           next_day(TRUNC(dFechaIni) - 1, 'SÁBADO')) / 7 + 1 +
           (next_day(TRUNC(dFechaFin), 'DOMINGO') - 7 -
           next_day(TRUNC(dFechaIni) - 1, 'DOMINGO')) / 7 + 1) -
           DECODE(((CASE
                       WHEN (TO_CHAR(dFechaIni, 'DY', 'nls_date_language=english') IN
                            ('SUN', 'SAT')) THEN
                        1
                       ELSE
                        0
                     END) + (CASE
                       WHEN (TO_CHAR(dFechaFin, 'DY', 'nls_date_language=english') IN
                            ('SUN', 'SAT')) THEN
                        1
                       ELSE
                        0
                     END)),
                     0,
                     0,
                     1))) * (DECODE(((CASE
                                       WHEN (TO_CHAR(dFechaIni, 'DY', 'nls_date_language=english') IN
                                            ('SUN', 'SAT')) THEN
                                        0
                                       ELSE
                                        1
                                     END) + (CASE
                                       WHEN (TO_CHAR(dFechaFin, 'DY', 'nls_date_language=english') IN
                                            ('SUN', 'SAT')) THEN
                                        0
                                       ELSE
                                        1
                                     END)),
                                     0,
                                     0,
                                     1)))
      INTO Dias
      FROM DUAL;
    RETURN(Dias);
  END F_CALC_DIAS_UTILES;
  --Inicio 2.0
  /******************************************************************
     NOMBRE:     OPERACION.PKG_SIGCORP.F_GET_NOMBRE_USUARIO
     PROPOSITO:  Captura nombre completo del user
     Ver        Fecha        Autor             Descripción
  ---------  ----------  ---------------    ------------------------
     1.0        18/05/2018  Jeannette Monroy   Buscar nombre usuario
  ******************************************************************/
  FUNCTION SGAFUN_USUARIOOPE(p_user USUARIOOPE.USUARIO%type) RETURN VARCHAR IS

    ls_nombre USUARIOOPE.NOMBRE%type;
    ln_cant   NUMBER;
  BEGIN

    select count(1) into ln_cant from USUARIOOPE WHERE USUARIO = p_user;

    ls_nombre := p_user;
    if ln_cant > 0 then
      select NOMBRE INTO ls_nombre from USUARIOOPE WHERE USUARIO = p_user;
    end if;

    RETURN ls_nombre;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20500,
                              'Error al generar el log - Codigo Error:' ||
                              TO_CHAR(SQLCODE) || CHR(13) ||
                              ' - Mensaje Error:' || TO_CHAR(SQLERRM));
  END;
  /******************************************************************
     NOMBRE:     OPERACION.PKG_SIGCORP.F_GET_NOMBRE_USUARIO
     PROPOSITO:  Envio de datos para Log de Auditoria
     Ver        Fecha        Autor             Descripción
  ---------  ----------  ---------------    ------------------------
     1.0        18/05/2018  Jeannette Monroy  Envia datos para Log de Auditoria
  ******************************************************************/
  PROCEDURE SGASI_LOG_DWDIN(an_accion    in number,
                            an_tipo      in number,
                            av_filtro    in varchar2,
                            an_area      operacion.areaope_query.area%type,
                            an_codquery  operacion.areaope_query.codquery%type,
                            av_modulo    auditoria.SGAT_LOG_DWDIN.logv_modulo%type,
                            ac_flgestado auditoria.SGAT_LOG_DWDIN.logc_flgestado%type,
                            av_msgerror  auditoria.SGAT_LOG_DWDIN.logv_msgerror%type) IS
    C_ES_UPDATE       constant pls_integer := 1;
    C_ES_SELECT       constant pls_integer := 0;
    C_ES_INSERT       constant pls_integer := 2;
    C_ES_REPORTE      constant pls_integer := 1;
    C_ES_CONTROLTAREA constant pls_integer := 0;
    lc_query     clob;
    lc_trasac    auditoria.SGAT_LOG_DWDIN.logc_trasac%type;
    lc_variable  auditoria.SGAT_LOG_DWDIN.logc_variable%type;
    lv_evento    auditoria.SGAT_LOG_DWDIN.logv_evento%type;
    lv_nomevento auditoria.SGAT_LOG_DWDIN.logv_nomevento%type;
    lv_nomusu    auditoria.SGAT_LOG_DWDIN.logv_nomusu%type;
  BEGIN
    lv_nomusu := SGAFUN_USUARIOOPE(USER);
    lv_evento := 'DW Dinamico';

    SELECT querys
      INTO lc_query
      FROM operacion.areaope_query
     WHERE area = an_area
       AND codquery = an_codquery;

    IF an_accion = C_ES_UPDATE THEN
      lc_trasac   := 'UPDATE OPERACION.AREAOPE_QUERY SET QUERYS = :lblob WHERE AREA = ' ||
                     an_area || ' AND CODQUERY = ' || an_codquery;
      lc_variable := lc_query;
      IF an_tipo = C_ES_CONTROLTAREA THEN
        lv_nomevento := 'Modificar Script Control Tareas';
      ELSIF an_tipo = C_ES_REPORTE THEN
        lv_nomevento := 'Modificar Script Reporte';
      END IF;
    ELSIF an_accion = C_ES_SELECT THEN
      lc_trasac   := lc_query;
      lc_variable := av_filtro;
      IF an_tipo = C_ES_CONTROLTAREA THEN
        lv_nomevento := 'Consulta Control Tareas';
      ELSIF an_tipo = C_ES_REPORTE THEN
        lv_nomevento := 'Consulta Reporte';
      END IF;
    ELSIF an_accion = C_ES_INSERT THEN
      lc_trasac   := 'INSERT INTO OPERACION.AREAOPE_QUERY (CODQUERY, AREA, QUERYS) VALUES (' ||
                     an_codquery || ' ,' || an_area || ' , :lblob )';
      lc_variable := lc_query;
      IF an_tipo = C_ES_CONTROLTAREA THEN
        lv_nomevento := 'Nuevo Script Control Tareas';
      ELSIF an_tipo = C_ES_REPORTE THEN
        lv_nomevento := 'Nuevo Script Reporte';
      END IF;
    END IF;
    AUDITORIA.PKG_LOG_AUDITORIA.SGASI_LOG_DWDIN(lv_evento,
                                                lv_nomevento,
                                                lv_nomusu,
                                                av_modulo,
                                                lc_trasac,
                                                lc_variable,
                                                ac_flgestado,
                                                av_msgerror);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      raise_application_error(-20500,
                              'Error al generar el log - Codigo Error:' ||
                              TO_CHAR(SQLCODE) || CHR(13) ||
                              ' - Mensaje Error:' || TO_CHAR(SQLERRM));
  END;
  --Fin 2.0
  --Ini 3.0
  FUNCTION SGAFUN_VAL_SOT(p_cliente operacion.solot.codcli%type,
                          p_servcio operacion.solot.tipsrv%type)
    return number is
    l_estado NUMBER;

    l_conta number;
  begin
    /*
    1 = Falta Pid
    2 = Telefonia Bolsa Minutos
    3 = Internet Servicio Gestionado
    0 = todo esta ok
    */

    SELECT count(*)
      into l_conta
      FROM TYSTABSRV, VTAEQUCOM, INSPRD, ESTINSPRD, INSSRV
     WHERE (vtaequcom.codequcom(+) = insprd.codequcom)
       and (insprd.codsrv = tystabsrv.codsrv(+))
       and (INSPRD.ESTINSPRD = ESTINSPRD.ESTINSPRD)
       and INSPRD.CODINSSRV = INSSRV.CODINSSRV
       and INSSRV.CODCLI = p_cliente
       and INSPRD.ESTINSPRD in (1)
       and INSPRD.PID not in (select sp.PID
                                from solot st
                               inner join solotpto sp
                                  on (st.codsolot = sp.codsolot)
                               where --sp.codsolot = p_codsolot  and
                               st.codcli = p_cliente
                           and st.estsol = 10)
       and TYSTABSRV.TIPSRV not in ('0055');

    if l_conta > 0 then
      l_estado := 1;
    else
      l_estado := 0;
    end if;

    /*
    Telefonia - Bolsa Minutos*/
    if p_servcio = '0004' then
      --l_estado:=0;
      SELECT count(a.codinssrv)
        into l_conta
        FROM inssrv a, tystabsrv b
       where a.codsrv = b.codsrv
         and b.idproducto in
             (SELECT codigon
                FROM tipopedd t, opedd o
               WHERE t.tipopedd = o.tipopedd
                 AND t.abrev = 'DAO_BOLSA_MIN')
         and a.estinssrv in (1, 2, 4)
         and b.idproducto in (703, 759, 1027, 1026, 1028)
         and a.codcli = p_cliente;

      if l_conta > 0 then
        l_estado := 2;
      end if;

    end if;
    /*Internet Banca Ancha  servicios Gestionados*/
    if p_servcio = '0006' then

      SELECT count(*)
        into l_conta
        FROM TYSTABSRV, VTAEQUCOM, INSPRD, ESTINSPRD, INSSRV
       WHERE (vtaequcom.codequcom(+) = insprd.codequcom)
         and (insprd.codsrv = tystabsrv.codsrv(+))
         and (INSPRD.ESTINSPRD = ESTINSPRD.ESTINSPRD)
         and INSPRD.CODINSSRV = INSSRV.CODINSSRV
         and INSSRV.CODCLI = p_cliente
         and INSPRD.ESTINSPRD in (1)
         and TYSTABSRV.TIPSRV = '0055';

      if l_conta > 0 then
        l_estado := 3;
      end if;
    end if;

    RETURN l_estado;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  end;
  --Fin 3.0

  PROCEDURE SGASS_TIPOPEDD(pv_abrev in varchar2, p_cursor out sys_refcursor) IS

  BEGIN

    Open p_cursor for
    select
    o.codigoc, o.codigon, o.codigon_aux,o.descripcion, o.abreviacion
    from opedd o
    inner join tipopedd t
    on t.tipopedd = o.tipopedd
    where
    t.abrev = pv_abrev;
  END;

-- Ini 4.0
  FUNCTION SGAFU_VALIDACION(PI_CODCLI VARCHAR2,
                           PI_CID NUMBER) RETURN NUMBER IS
  LI_CANT   NUMBER;
  LI_VALOR  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO LI_CANT FROM OPERACION.INSSRV
    WHERE ESTINSSRV = 1
    AND BW > 0
    AND CODCLI = PI_CODCLI
    AND CID    = PI_CID;
      IF LI_CANT > 0 THEN
        LI_VALOR := 1;
      END IF;
      IF LI_CANT = 0 OR LI_CANT IS NULL THEN
        LI_VALOR := 0;
      END IF;
      RETURN LI_VALOR;
      EXCEPTION
      WHEN OTHERS THEN RETURN 0;
  END;

  FUNCTION SGAFU_OBT_BW_MAYOR(PI_CODCLI VARCHAR2,
                             PI_CID NUMBER,
                             PI_BW_NEW NUMBER) RETURN NUMBER IS
  li_valor_bw NUMBER;
  LL_BW       NUMBER(10,2);
  PO_VALOR    NUMBER;
  BEGIN
    SELECT OPERACION.PKG_SIGCORP.SGAFU_VALIDACION(PI_CODCLI,PI_CID) INTO PO_VALOR FROM DUAL;
      IF PO_VALOR = 1 THEN
        SELECT BW INTO LL_BW FROM OPERACION.INSSRV
        WHERE ESTINSSRV = 1
        AND BW > 0
        AND CODCLI = PI_CODCLI
        AND CID   = PI_CID;
        IF PI_BW_NEW > LL_BW THEN
          li_valor_bw := 1;
        END IF;
        IF PI_BW_NEW = LL_BW OR PI_BW_NEW < LL_BW OR PI_BW_NEW IS NULL THEN
          li_valor_bw := 0;
        END IF;
      END IF;
      IF PO_VALOR = 0 THEN
        li_valor_bw := 0;
      END IF;
    RETURN li_valor_bw;
    EXCEPTION
    WHEN OTHERS THEN RETURN 0;
  END;

 FUNCTION SGAFU_BW_MENOR(PI_CODCLI VARCHAR2,
                         PI_CID NUMBER,
                         PI_BW_NEW NUMBER) RETURN NUMBER IS
  li_valor_bw NUMBER;
  LL_BW       NUMBER(10,2);
  PO_VALOR    NUMBER;
  BEGIN
    SELECT OPERACION.PKG_SIGCORP.SGAFU_VALIDACION(PI_CODCLI,PI_CID) INTO PO_VALOR FROM DUAL;
      IF PO_VALOR = 1 THEN
        SELECT BW INTO LL_BW FROM OPERACION.INSSRV
        WHERE ESTINSSRV = 1
        AND BW > 0
        AND CODCLI = PI_CODCLI
        AND CID   = PI_CID;
        IF PI_BW_NEW < LL_BW THEN
          li_valor_bw := 1;
        END IF;
        IF PI_BW_NEW = LL_BW OR PI_BW_NEW > LL_BW OR PI_BW_NEW IS NULL THEN
          li_valor_bw := 0;
        END IF;
      END IF;
      IF PO_VALOR = 0 THEN
        li_valor_bw := 0;
      END IF;
    RETURN li_valor_bw;
    EXCEPTION
    WHEN OTHERS THEN RETURN 0;
  END;
-- Fin 4.0


-- Ini 5.0
  FUNCTION SGAFU_VAL_PROY(PI_CODCLI VARCHAR2,
                          PI_CID NUMBER,
                          PI_BW_NEW NUMBER) RETURN NUMBER IS

  li_val_est_proy NUMBER;
  li_count_estado  CHAR(2);
  LI_VALOR_BW     NUMBER;
  ls_numslc       Varchar2(10);
  BEGIN
    SELECT SGAFU_OBT_BW_MAYOR(PI_CODCLI,PI_CID,PI_BW_NEW) INTO LI_VALOR_BW FROM DUAL;
      IF LI_VALOR_BW = 1 THEN
        SELECT NUMSLC INTO ls_numslc FROM OPERACION.INSSRV WHERE CODCLI = PI_CODCLI AND CID = PI_CID;
        SELECT count(A.ESTSOLFAC) INTO li_count_estado FROM SALES.VTATABSLCFAC A
        INNER JOIN OPERACION.INSSRV B ON (A.CODCLI = B.CODCLI AND A.NUMSLC = B.NUMSLC AND A.TIPSRV = B.TIPSRV)
        WHERE ESTINSSRV = 1 AND BW > 0 AND  CID IS NOT NULL
        AND B.CODCLI = PI_CODCLI
        AND B.Numslc <> ls_numslc
        AND A.ESTSOLFAC = '00';
          IF li_count_estado = 0 THEN
            li_val_est_proy := 1;
          END IF;
          IF li_count_estado > 0 THEN
            li_val_est_proy := 0;
          END IF;
      END IF;
      IF LI_VALOR_BW = 0 THEN
        li_val_est_proy := 0;
      END IF;
    RETURN li_val_est_proy;
    EXCEPTION
    WHEN OTHERS THEN RETURN 0;
  END;
-- Fin 5.0

-- Ini 6.0
PROCEDURE SGASU_GENNEWEF(as_numslc sales.vtatabslcfac.numslc%type
                        ,as_codcli sales.vtatabslcfac.codcli%type
                        ,as_tipsrv sales.vtatabslcfac.tipsrv%type
                        ,an_tipsolef sales.vtatabslcfac.tipsolef%type
                        ,as_cliint sales.vtatabslcfac.cliint%type
                        ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                        ,PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
  ln_estef NUMBER(2);
  ln_area  NUMBER(4);
  ls_observacion VARCHAR2(1000);
  BEGIN
  ln_estef := 2;
  ln_area  := 419;
  ls_observacion := 'Factibilidad Creada por Campaña de Fidelización por Saturación correspondiento al Nro . ';

   insert into ef(CODEF,                NUMSLC,    CODCLI,    ESTEF,    tipsrv,    tipsolef,    cliint, observacion, Numdiapla )
	         values(to_number(as_numslc), as_numslc, as_codcli, ln_estef, as_tipsrv, an_tipsolef, as_cliint,ls_observacion, 60 );

   Insert Into solefxarea(CODEF, NUMSLC,ESTSOLEF,ESRESPONSABLE,AREA, Numdiapla, Observacion)
                   values(to_number(as_numslc),as_numslc,ln_estef,1,ln_area, 60,ls_observacion);
   --commit;
   -- --
    PO_CODIGO_RESPUESTA := '0';
    PO_MENSAJE_RESPUESTA := 'Factibilidad Creada Correctamente';
    EXCEPTION
    WHEN no_data_found THEN
        PO_CODIGO_RESPUESTA := '-1';
        PO_MENSAJE_RESPUESTA := 'No se creó la factibilidad, verifique si la información está correcta.';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA:='-2';
      PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
END SGASU_GENNEWEF;

PROCEDURE SGASI_UPGRADE(ls_numslc sales.vtatabslcfac.numslc%type
                        ,ls_n_numslc sales.vtatabslcfac.numslc%type
                        ,PI_CID NUMBER
                        ,ls_codcli     sales.vtatabslcfac.codcli%type
                        ,ln_banwid     sales.vtadetptoenl.banwid%type
                        ,as_codsrv_bw  sales.tystabsrv.codsrv%type
                        ,an_tiptra     operacion.tiptrabajo.tiptra%type
                        ,as_tipsrv      sales.vtatabslcfac.tipsrv%type
                        ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                        ,PO_MENSAJE_RESPUESTA OUT VARCHAR2)  IS
  ls_codsuc        CHAR(10);
  ln_pid           NUMBER(10);
  ls_codsrv        CHAR(4);
  ls_numpto        CHAR(5);
  ln_codinssrv     NUMBER(10);
  ls_descpto       VARCHAR2(100);
  ls_dirpto        VARCHAR2(1000);
  ls_ubipto        CHAR(10);
  ls_crepto        CHAR(1);
  ls_estcse        CHAR(1);
  ln_idproducto    NUMBER(10);
  ln_idmodo_acceso NUMBER(1);
  ln_tipo_vta      NUMBER(2);
  ls_tipsrv        VARCHAR2(4);
  ln_paquete       NUMBER(4);
  ls_n_numpto      VARCHAR2(5);
  ln_idprecio      NUMBER(10);
  ln_prelis_srv    NUMBER(15,4);
  ln_prelis_ins    NUMBER(15,4);
  ln_monto_srv     NUMBER(15,4);
  ln_monto_ins     NUMBER(15,4);
  ln_porcimp_srv   NUMBER(5,2);
  ln_porcimp_ins   NUMBER(5,2);
  ln_monto_srv_imp NUMBER(15,4);
  ln_monto_ins_imp NUMBER(15,4);
  ln_preuni_srv    NUMBER(15,4);
  ln_preuni_ins    NUMBER(15,4);
  ----------
BEGIN
  ls_estcse        := '1';
  ln_idmodo_acceso := 1;
  ln_tipo_vta      := 2;
  ls_tipsrv        := as_tipsrv;
  -------------
  select distinct a.codsuc,      c.pid,         a.numpto,     b.codinssrv,  a.descpto,      a.dirpto,       a.ubipto,         a.crepto,         a.PAQUETE,     a.idprecio,
                  a.prelis_srv,  a.prelis_ins,  a.monto_srv,  a.monto_ins,  a.porcimp_srv,  a.porcimp_ins,  a.monto_srv_imp,  a.monto_ins_imp,  a.preuni_srv,  a.preuni_ins
             Into ls_codsuc,     ln_pid,        ls_numpto,    ln_codinssrv, ls_descpto,     ls_dirpto,      ls_ubipto,        ls_crepto,        ln_paquete,    ln_idprecio,
                  ln_prelis_srv, ln_prelis_ins, ln_monto_srv, ln_monto_ins, ln_porcimp_srv, ln_porcimp_ins, ln_monto_srv_imp, ln_monto_ins_imp, ln_preuni_srv, ln_preuni_ins
  from vtadetptoenl a
  inner join inssrv b on (a.numpto = b.numpto and a.numslc = b.numslc)
  inner join insprd c on (b.codinssrv = c.codinssrv and b.numslc = c.numslc and b.numpto = c.numpto)
  where a.numslc = ls_numslc
  and c.estinsprd = 1
  and b.estinssrv = 1
  and b.cid = PI_CID and b.codcli = ls_codcli
  and b.TIPSRV = ls_tipsrv;
  
  IF ls_tipsrv = '0006' THEN
    ls_codsrv := 'AMJM';
  ELSIF ls_tipsrv = '0096' or ls_tipsrv = '0052' THEN
    ls_codsrv := '1483';
  END IF;

  select idproducto into ln_idproducto from tystabsrv where codsrv = ls_codsrv;
    -------------
    Update vtadetptoenl
    set tiptra           = an_tiptra
        ,cid             = PI_CID
        ,tipo_vta        = ln_tipo_vta
        ,estcse          = ls_estcse
        ,idmodo_acceso   = ln_idmodo_acceso
        ,codinssrv       = ln_codinssrv
    where numslc         = ls_n_numslc;
    -------------
    Update vtadetptoenl set banwid = ln_banwid, pid_old = ln_pid, cid = PI_CID
    where numpto = ls_numpto and numslc = ls_n_numslc;
    ------------
    SALES.PQ_PROYECTO.P_CREAR_DETALLE(ls_n_numslc,ls_numpto);
    ------------
    SELECT max(numpto) INTO ls_n_numpto FROM VTADETPTOENL WHERE numslc = ls_n_numslc ;
    ------------
    update vtadetptoenl set tiptra = an_tiptra,
                    estcse     = ls_estcse,
                    cid    	   = PI_CID,
                    banwid     = 0.00,
                    tipo_vta   = ln_tipo_vta,
                    codinssrv  = ln_codinssrv,
                    codsrv     = ls_codsrv,
                    idproducto = ln_idproducto,
                    idprecio   = '',
                    pid_old    = '',
                    flgsrv_pri = '0',
                    prelis_srv = 0.00,
                    prelis_ins = 0.00,
                    desc_srv   = 0.00,
                    desc_ins   = 0.00,
                    monto_srv  = 0.00,
                    monto_ins  = 0.00,
                    porcimp_srv = 0.00,
                    porcimp_ins = 0.00,
                    monto_srv_imp = 0.00,
                    monto_ins_imp = 0.00,
                    compensacion_srv = 0.00,
                    compensacion_ins = 0.00,
                    multa = 0.00,
                    preuni_srv = 0.00,
                    preuni_ins = 0.00,
                    codequcom  = '',
                    idmodo_acceso=1
                    where numslc = ls_n_numslc
                    and numpto   = ls_n_numpto;
    ------------
    Update vtadetptoenl set cid = PI_CID where numslc = ls_n_numslc;

    ------------
    IF ln_paquete IS NULL or ln_paquete = 0 THEN
      ln_paquete := 1;
    END IF;
    ------------
    Update vtadetptoenl set paquete = ln_paquete where numslc = ls_n_numslc;
    ------------
    IF as_codsrv_bw is not null THEN
      update vtadetptoenl set codsrv  = as_codsrv_bw,
                              pid_old = '',
                              idprecio      = ln_idprecio,
                              prelis_srv    = ln_prelis_srv,
                              prelis_ins    = ln_prelis_ins,
                              monto_srv     = ln_monto_srv,
                              monto_ins     = ln_monto_ins,
                              porcimp_srv   = ln_porcimp_srv,
                              porcimp_ins	  = ln_porcimp_ins,
                              monto_srv_imp = ln_monto_srv_imp,
                              monto_ins_imp = ln_monto_ins_imp,
                              preuni_srv    = ln_preuni_srv,
                              preuni_ins    = ln_preuni_ins
      where numslc = ls_n_numslc
      and numpto   = ls_numpto;
    END IF;
    ------------
    commit;
    PO_CODIGO_RESPUESTA := '0';
    PO_MENSAJE_RESPUESTA := 'Upgrade/Downgrade Creada Correctamente';
    EXCEPTION
    WHEN no_data_found THEN
        PO_CODIGO_RESPUESTA := '1';
        PO_MENSAJE_RESPUESTA := 'No se creó el punto Upgrade/Downgrade, verifique si la información está correcta.';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA := '2';
      PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
END SGASI_UPGRADE;

PROCEDURE SGASI_CREA_OC(as_numslc vtatabslcfac.numslc%type
                        ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                        ,PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
vReg_sef vtatabslcfac%rowtype;
BEGIN
  select tipsrv, codcli, codsol, numslc, plazo_srv, obssolfac, srvpri
  into vReg_sef.tipsrv,
     vReg_sef.codcli,
     vReg_sef.codsol,
     vReg_sef.numslc,
     vReg_sef.plazo_srv,
     vReg_sef.obssolfac,
     vReg_sef.srvpri
  from vtatabslcfac
  where numslc = as_numslc;
  insert into vtatabpspcli(tipsrv,          codcli,          codect,          numslc,          durcon,             obspsp,             estpspcli, TITPSP,          res1,idopc)
                    values(vReg_sef.tipsrv, vReg_sef.codcli, vReg_sef.codsol, vReg_sef.numslc, vReg_sef.plazo_srv, vReg_sef.obssolfac, '02',      vReg_sef.srvpri, 1,   '00');
  COMMIT;
    PO_CODIGO_RESPUESTA := '0';
    PO_MENSAJE_RESPUESTA := 'Oferta Generada Correctamente';
    EXCEPTION
    WHEN no_data_found THEN
        PO_CODIGO_RESPUESTA := '-1';
        PO_MENSAJE_RESPUESTA := 'No se creó la Oferta Comercial, verifique si la información está correcta.';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA:='-2';
      PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
END SGASI_CREA_OC;

PROCEDURE SGASU_APROB_AR( an_codef ar.codef%type
                          ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                          ,PO_MENSAJE_RESPUESTA OUT VARCHAR2)IS
BEGIN
  update ar set estar = 3, rentable = 1,observacion='AR aprobado automáticamente.', fecapr = sysdate
  where codef = an_codef;
  --Commit;
    PO_CODIGO_RESPUESTA := '0';
    PO_MENSAJE_RESPUESTA := 'Rentabilidad Aprobada Correctamente';
    EXCEPTION
    WHEN no_data_found THEN
        PO_CODIGO_RESPUESTA := '-1';
        PO_MENSAJE_RESPUESTA := 'No se aprobó la Rentabilidad, verifique si la información está correcta.';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA:='-2';
      PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
END SGASU_APROB_AR;
-- Fin 6.0

-- Ini 7.0
PROCEDURE SGASI_GENSOTNEW(as_numslc sales.vtatabslcfac.numslc%type
                          ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                          ,PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
  as_numpsp  CHAR(10);
  a_idopc   CHAR(2);
  ls_codcli    varchar2(8);
  a_tipcon     char(1);
  a_estado     number(2);
  ls_observacion varchar2(4000);
  BEGIN
  a_tipcon :='C';
  a_estado := 10;
  select NUMPSP, IDOPC, CODCLI, OBSPSP Into as_numpsp, a_idopc, ls_codcli, ls_observacion
  from vtatabpspcli where numslc = as_numslc;

  --Generación de Sot
  OPERACION.PQ_INT_PRYOPE.p_exe_int_pryope(as_numslc,as_numpsp,'00',a_estado,a_tipcon);
  UPDATE SOLOT SET AREASOL      = 100
                  ,OBSERVACION  = ls_observacion
  where NUMSLC = as_numslc
    and NUMPSP = as_numpsp;

    PO_CODIGO_RESPUESTA := '0';
    PO_MENSAJE_RESPUESTA := 'SOT Generada Correctamente';
    EXCEPTION
    WHEN no_data_found THEN
        PO_CODIGO_RESPUESTA := '-1';
        PO_MENSAJE_RESPUESTA := 'No se generó la SOT, verifique si la información está correcta.';
    WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA:='-2';
      PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
END SGASI_GENSOTNEW;
-- Fin 7.0




PROCEDURE SGASI_CNT_SEF(as_numslc sales.vtatabslcfac.numslc%type,
                        as_codcli sales.vtatabslcfac.codcli%type,
                        PO_CODIGO_RESPUESTA  OUT VARCHAR2,
                        PO_MENSAJE_RESPUESTA OUT VARCHAR2)
IS

LS_TIPCNT VARCHAR2(2);
LS_CODCNT VARCHAR2(8);
LS_NOMCNT VARCHAR(300);
LS_CARCNT VARCHAR(2);
LI_CARGO  NUMBER;
BEGIN
LS_TIPCNT := '04';

  select COUNT(carcnt) INTO LI_CARGO from vtatabcntcli
  where TIPCNT = as_codcli
  and codcli   = LS_TIPCNT
  AND ESTADO=1
  AND ROWNUM=1
  AND carcnt like '%TECNICO%';
  IF LI_CARGO > 1 THEN
    SELECT CODCNT,    NOMCNT,    TIPCNT,   CARCNT
      INTO LS_CODCNT, LS_NOMCNT, LS_TIPCNT,LS_CARCNT
      FROM vtatabcntcli
    where TIPCNT = as_codcli
    and codcli   = LS_TIPCNT
    AND ESTADO=1 AND ROWNUM=1;
  ELSIF LI_CARGO = 1 THEN
    SELECT CODCNT,    NOMCNT,    TIPCNT,    CARCNT
      INTO LS_CODCNT, LS_NOMCNT, LS_TIPCNT, LS_CARCNT
      FROM vtatabcntcli
    where TIPCNT = as_codcli
    and codcli   = LS_TIPCNT
    AND ESTADO=1 AND ROWNUM=1
    AND carcnt like '%TECNICO%';
  END IF;

INSERT INTO sales.VTADETCNTSLC(numslc,    SECUENCIA, CODCNT,    NOMCNT,    TIPCNT,    FLG_PRINC)
                        VALUES(as_numslc, '00',      LS_CODCNT, LS_NOMCNT, LS_TIPCNT, 1 );

PO_CODIGO_RESPUESTA := '0';
PO_MENSAJE_RESPUESTA := 'Contacto Creado';
EXCEPTION
WHEN no_data_found THEN
    PO_CODIGO_RESPUESTA := '-1';
    PO_MENSAJE_RESPUESTA := 'No se generó el contacto, verifique si la información está correcta.';
WHEN OTHERS THEN
  PO_CODIGO_RESPUESTA:='-2';
  PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;

END;

-- Ini 8.0
PROCEDURE SGASI_GEN_NEW_PROY(as_codcli vtatabslcfac.codcli%type
                         ,an_cid marketing.sgat_proy_cli_cid.pccn_cid%type
                         ,an_bw  marketing.sgat_proy_cli_cid.pccn_bw%type
                         ,an_codsolot  out operacion.solot.codsolot%type
                         ,as_numslc    out sales.vtatabslcfac.numslc%type
                         ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                         ,PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
  ls_codsol       VARCHAR2(8);
  ls_tipsrv       VARCHAR2(4);
  ls_obssolfac    VARCHAR2(4000);
  ls_estsolfac    VARCHAR2(2);
  ld_fecpedsol    DATE;
  ls_numslc       VARCHAR2(10);
  ls_n_numslc     VARCHAR2(10);
  ls_srvpri       VARCHAR2(200);
  ld_moneda_id    NUMBER(2);
  li_plazo_srv    NUMBER(4);
  li_idsolucion   NUMBER(10);
  li_area         NUMBER(6);
  li_idcampanha   NUMBER(6);
  li_idtiposolucion       NUMBER(2);
  ls_nro_licitacion       VARCHAR2(50);
  ln_tipsolef             NUMBER(4);
  ls_cliint               CHAR(3);
  ls_n_estsolfac          CHAR(2);
  ln_idflujo              NUMBER;
  ln_codsolot             NUMBER(8);
  BEGIN
    select sysdate into ld_fecpedsol from dual;
    ls_estsolfac     := '00';
    select NUMSLC,    CODSOL,    SRVPRI,    TIPSRV,    MONEDA_ID,    PLAZO_SRV,    IDSOLUCION,    AREA,    IDCAMPANHA,    IDTIPOSOLUCION,  NRO_LICITACION
    INTO   ls_numslc, ls_codsol, ls_srvpri, ls_tipsrv, ld_moneda_id, li_plazo_srv, li_idsolucion, li_area, li_idcampanha, li_idtiposolucion, ls_nro_licitacion
    from vtatabslcfac
    where numslc IN ( SELECT DISTINCT B.NUMSLC FROM OPERACION.INSSRV B
                      WHERE B.ESTINSSRV = 1 AND B.BW > 0 AND B.CID IS NOT NULL
                      AND B.CODCLI = as_codcli AND B.CID = an_cid);

    select DSCTIPSRV into ls_srvpri from tystipsrv where tipsrv = ls_tipsrv;
      IF li_plazo_srv IS NULL THEN
        li_plazo_srv := 2;
      END IF;
      IF li_idcampanha IS NULL THEN
        li_idcampanha := 2;
      END IF;
      ls_obssolfac := 'Proyecto Creado por Campaña de Fidelización por Saturación correspondiento al Nro .'||' '||ls_numslc ;
    -- Generación de Cabecera SEF
    INSERT INTO vtatabslcfac(CODCLI,    FECPEDSOL,    ESTSOLFAC,    CODSOL,    SRVPRI,    OBSSOLFAC,    TIPSRV,    MONEDA_ID,    PLAZO_SRV,    IDSOLUCION,    AREA,    IDCAMPANHA,    IDTIPOSOLUCION,    NRO_LICITACION,    TIPSOLEF,    CLIINT)
                      VALUES(as_codcli, ld_fecpedsol, ls_estsolfac, ls_codsol, ls_srvpri, ls_obssolfac, ls_tipsrv, ld_moneda_id, li_plazo_srv, li_idsolucion, li_area, li_idcampanha, li_idtiposolucion, ls_nro_licitacion, ln_tipsolef, ls_cliint) returning numslc into ls_n_numslc;

    -- Generación de Detalle SEF
    INSERT INTO SALES.VTADETPTOENL
                (NUMSLC,   NUMPTO,DESCPTO,DIRPTO,UBIPTO,CREPTO,CODSRV,CODSUC,CODESF,ESTIST,CODESFM,FECINISER,CODCENINX,BANWID,MERABS1,MERORD1,MERABS2,MERORD2,NUMCKT,INTPTO,FECFINSER,ALIEQU,OBSEQU,NUMSLCPAD,
    FECINIEQU,NUMPTOPAD,CID,TIPTRA,NROLINEAS,NROFACREC,NROHUNG,NROIGUAL,NROCANAL,CODCLIANT,CODSUCANT,TIPTRAEF,LOGIN,DOMINIO,IDPRECIO,PRELIS_SRV,PRELIS_INS,MONTO_SRV,MONTO_INS,PORCIMP_SRV,
    PORCIMP_INS,MONTO_SRV_IMP,MONTO_INS_IMP, CANTIDAD, CODINSSRV, PID,CODINSSRV_TRAS,NUMPTO_PRIN,NUMPTO_ORIG,NUMPTO_DEST,CODINSSRV_ORIG,CODINSSRV_DEST,PAQUETE,FLGSRV_PRI, CODEQUCOM,    INFOVIA,MULTA,IDPRODUCTO,             PID_OLD,COMPENSACION_SRV,COMPENSACION_INS,
    PLANDESCUENTO,PLAZO_INSTALACION,OBSERVACION,GRUPO,TIPO_VTA,CODCAB,IDBONUS,PREUNI_SRV,PREUNI_INS,CODINSSRV_PAD,MONEDA_ID,QUOTE_NUMBER,IDSITE,IDTIPO_PTO,GRUPO_NUMPTO,IDINSXPAQ,IDPAQ,IDDET,IDPLATAFORMA,IDCUENTA)
    SELECT
    DISTINCT ls_n_numslc,b.NUMPTO,DESCPTO,DIRPTO,UBIPTO,CREPTO,a.CODSRV,CODSUC,CODESF,ESTIST,CODESFM,FECINISER,CODCENINX,BANWID,MERABS1,MERORD1,MERABS2,MERORD2,NUMCKT,INTPTO,FECFINSER,ALIEQU,OBSEQU,NUMSLCPAD,
    FECINIEQU,NUMPTOPAD,CID,TIPTRA,NROLINEAS,NROFACREC,NROHUNG,NROIGUAL,NROCANAL,CODCLIANT,CODSUCANT,TIPTRAEF,LOGIN,DOMINIO,IDPRECIO,PRELIS_SRV,PRELIS_INS,MONTO_SRV,MONTO_INS,PORCIMP_SRV,
    PORCIMP_INS,MONTO_SRV_IMP,MONTO_INS_IMP,a.CANTIDAD,b.CODINSSRV,a.PID,CODINSSRV_TRAS,NUMPTO_PRIN,NUMPTO_ORIG,NUMPTO_DEST,CODINSSRV_ORIG,CODINSSRV_DEST,PAQUETE,FLGSRV_PRI,a.CODEQUCOM,INFOVIA,MULTA,IDPRODUCTO,b.pid PID_OLD,COMPENSACION_SRV,COMPENSACION_INS,
    PLANDESCUENTO,PLAZO_INSTALACION,OBSERVACION,GRUPO,TIPO_VTA,CODCAB,IDBONUS,PREUNI_SRV,PREUNI_INS,CODINSSRV_PAD,MONEDA_ID,QUOTE_NUMBER,IDSITE,IDTIPO_PTO,GRUPO_NUMPTO,IDINSXPAQ,a.IDPAQ,a.IDDET,a.IDPLATAFORMA,IDCUENTA
    From SALES.VTADETPTOENL a
    INNER JOIN insprd b ON (a.numslc= b.numslc AND a.numpto=b.numpto)
    WHERE a.numslc = ls_numslc;

    -- Creación de Upgrade
    OPERACION.PKG_SIGCORP.SGASI_UPGRADE(ls_numslc,ls_n_numslc,an_cid,as_codcli,an_bw,'',2,ls_tipsrv,PO_CODIGO_RESPUESTA,PO_MENSAJE_RESPUESTA);

    -- Creación de Estudio de Factibilidad - EF
    OPERACION.PKG_SIGCORP.SGASU_GENNEWEF(ls_n_numslc,as_codcli,ls_tipsrv,ln_tipsolef,ls_cliint,PO_CODIGO_RESPUESTA,PO_MENSAJE_RESPUESTA);
    OPERACION.p_act_ef_de_sol(to_number( ls_n_numslc) );

    -- Actualizar Estado Aprobado SEF
    ls_n_estsolfac   := '03';
    ln_idflujo       := 84;
    SALES.PQ_PROYECTO.P_EJECUTA_FLUJO_AUTOMATICO(ls_n_numslc,ls_n_estsolfac,ln_idflujo);

    -- Generación de Rentabilidad de Rentabilidad
    P_ACT_COSTO_EF( to_number(ls_n_numslc) );
    P_ACT_EF_DE_SOL( to_number(ls_n_numslc) );
    P_GEN_AR(to_number(ls_n_numslc));
    P_VERIFICA_RENTABILIDAD( to_number(ls_n_numslc) );
    OPERACION.PKG_SIGCORP.SGASU_APROB_AR( to_number(ls_n_numslc),PO_CODIGO_RESPUESTA,PO_MENSAJE_RESPUESTA );

    -- Genera Oferta Comercial
    OPERACION.PKG_SIGCORP.SGASI_CREA_OC(ls_n_numslc,PO_CODIGO_RESPUESTA,PO_MENSAJE_RESPUESTA);
    SALES.PQ_OFERTA_COMERCIAL.P_CREAR_DETALLE(ls_n_numslc);

    -- Aprobación de Créditos
    SALES.PQ_INT_TPINT_VTA.p_update_aprob_aut( ls_n_numslc );

    -- Aprobación automática Oferta Comercial
    SALES.PQ_CONTRATOS_AUTOMATICO.P_ACTUALIZAR_ESTADO_OC(ls_n_numslc, '02');

    -- Generación SOT
    OPERACION.PKG_SIGCORP.SGASI_GENSOTNEW( ls_n_numslc,PO_CODIGO_RESPUESTA,PO_MENSAJE_RESPUESTA );

    -- Numero de Proyecto y Numero de SOT
    SELECT codsolot INTO ln_codsolot FROM solot WHERE numslc=ls_n_numslc;
    as_numslc      := ls_n_numslc;
    an_codsolot    := ln_codsolot;
    -- --
    PO_CODIGO_RESPUESTA := '0';
    PO_MENSAJE_RESPUESTA := 'SOT Generada Correctamente';
    COMMIT;
     EXCEPTION
     WHEN no_data_found THEN
        PO_CODIGO_RESPUESTA := '-1';
        PO_MENSAJE_RESPUESTA := 'No se generó SOT, verifique si la información está correcta.';
        RollBack;
     WHEN OTHERS THEN
      PO_CODIGO_RESPUESTA:='-2';
      PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
      RollBack;
END SGASI_GEN_NEW_PROY;
-- Fin 8.0
  /*****************************************************************************************
  * Nombre SP :         OPERACION.PKG_SIGCORP.SGASS_CONSULTA_CLIENTES_CORP
  * Propósito :         Obtención de los clientes moviles corporativos
  * Input :             PI_RUC - Codigo del RUC
  * Output :            PO_CODIGO_RESPUESTA - Codigo resultado
                        PO_MENSAJE_RESPUESTA - Mensaje resultado
  * Creado por :        Hitss
  * Fec Creación :      23/09/2019
  * Fec Actualización :  -
  *****************************************************************************************/
-- Ini 9.0
  PROCEDURE SGASS_CONSULTA_CLIENTES_CORP( PO_CURSOR OUT SYS_REFCURSOR
                                          ,PO_CODIGO_RESPUESTA  OUT VARCHAR2
                                          ,PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
    BEGIN
      OPEN PO_CURSOR FOR
        SELECT DISTINCT C.CSCOMPREGNO RUC
          FROM SYSADM.CUSTOMER_ALL@DBL_BSCS_BF C
          LEFT JOIN MARKETING.VTATABCLI V
            ON C.CSCOMPREGNO = V.NTDIDE
         WHERE V.CODCLI IS NULL
           AND SUBSTR(C.CSCOMPREGNO, 1, 2) IN ('10', '15', '17', '20')
           AND LENGTH(C.CSCOMPREGNO) = 11
           AND C.PRGCODE = 1
           AND C.CSLEVEL = '40'
           AND C.CSTYPE = 'a'
           AND C.CSENTDATE > (TRUNC(SYSDATE) - 1);
           PO_CODIGO_RESPUESTA := '0';
           PO_MENSAJE_RESPUESTA := 'EXITO';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        PO_CODIGO_RESPUESTA := '-1';
        PO_MENSAJE_RESPUESTA := 'NO SE ENCONTRO REGISTROS';
      WHEN OTHERS THEN
        PO_CODIGO_RESPUESTA:='-2';
        PO_MENSAJE_RESPUESTA:=SQLCODE||'/'||SQLERRM;
  END SGASS_CONSULTA_CLIENTES_CORP;
-- Fin 9.0
-- Ini 10.0
  PROCEDURE SGASU_UPD_CRED(A_RENTABLE OPERACION.AR.RENTABLE%TYPE,
                           A_CODEF  OPERACION.EF.CODEF%TYPE,
                           P_COD OUT VARCHAR2,
                           P_MSG OUT VARCHAR2)
  IS
  LS_NUMSLC VARCHAR2(10);
  LD_FECMOD DATE;
  LC_ESTAPR CHAR;
  BEGIN

    SELECT SYSDATE INTO LD_FECMOD FROM DUAL;
    LS_NUMSLC := LPAD(A_CODEF,10,'0');
     
    IF A_RENTABLE = 1 THEN
      LC_ESTAPR :='P';
    ELSIF A_RENTABLE = 0 THEN
      LC_ESTAPR :='';
      LD_FECMOD :='';
    END IF;
      
    UPDATE COLLECTIONS.CXCPSPCHQ
     SET ESTAPR = LC_ESTAPR,
         FECMOD = LD_FECMOD,
         USUMOD = USER
     WHERE NUMSLC = LS_NUMSLC;
      COMMIT;

      P_COD := '0';
      P_MSG := 'EXITO'||' - '||TO_CHAR(LD_FECMOD)||' - '||A_RENTABLE||' - '||LS_NUMSLC;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_COD := '1';
          P_MSG := 'No se actualizó en registro.';
        WHEN OTHERS THEN
          P_COD := '2';
          P_MSG := SQLCODE||'SGASU_UPD_CRED'||SQLERRM;

  END SGASU_UPD_CRED;
-- Fin 10.00
-- Ini 11.00
  /*****************************************************************************************
  * Nombre SP :         OPERACION.PKG_SIGCORP.SGASS_AREA_ADECUACION
  * Propósito :         Obtención de sots de adecuación de capacidad y puertos
  * Input :             
  * Output :            PO_CURSOR            - Cursor
                        PO_CODIGO_RESPUESTA  - Codigo resultado
                        PO_MENSAJE_RESPUESTA - Mensaje resultado
  * Creado por :        Johana Roque 
  * Fec Creación :      18/10/2019
  * Fec Actualización :  -
  *****************************************************************************************/
  PROCEDURE SGASS_AREA_ADECUACION(PO_CURSOR            OUT SYS_REFCURSOR,
                                   PO_CODIGO_RESPUESTA  OUT NUMBER,
                                   PO_MENSAJE_RESPUESTA OUT VARCHAR2) IS
    BEGIN
      --Obtiene información para el envio de correo
      OPEN PO_CURSOR FOR 
           SELECT DISTINCT E.DESCRIPCION SOLICITUD,
                        A.NUMSLC PROYECTO,
                        D.NTDIDE RUC,
                        D.NOMCLI CLIENTE,
                        A.OBSERVACION COMENTARIO,
                        B.DESCRIPCION TIPTRABAJO,
                        C.DSCTIPSRV TIPO_SERV,
                        S.CODSOLOT SOT,
                        S.OBSERVACION COMENTARIO_SOT,
                        S.FECUSU FECHA_SOT,
                        G.NOMBRE ADP,
                        S.FECCOM
        FROM OPERACION.SOLOT S
        INNER JOIN OPERACION.SOLEFXAREA A
          ON S.NUMSLC = A.NUMSLC
        INNER JOIN OPERACION.TIPTRABAJO B
          ON S.TIPTRA = B.TIPTRA
        INNER JOIN SALES.TYSTIPSRV C
          ON S.TIPSRV = C.TIPSRV
        INNER JOIN MARKETING.VTATABCLI D
          ON S.CODCLI = D.CODCLI
        INNER JOIN OPERACION.AREAOPE E
          ON A.AREA = E.AREA
        LEFT JOIN ATCCORP.CUSTOMER_ATENTION F
          ON D.CODCLI = F.CUSTOMERCODE
        LEFT JOIN OPEWF.USUARIOOPE G
          ON F.CODCCAREUSER = G.USUARIO
        WHERE A.AREA in (468,469)
         AND TRUNC(S.FECAPR) = TRUNC(SYSDATE);
      PO_CODIGO_RESPUESTA:=0;
      PO_MENSAJE_RESPUESTA:='EXITO';                                
    EXCEPTION
      WHEN OTHERS THEN
       PO_CODIGO_RESPUESTA := -1;
       PO_CODIGO_RESPUESTA := SQLCODE || 'SGASS_AREA_ADECUACION' || SQLERRM;     
  END SGASS_AREA_ADECUACION;
-- Fin 11.00


-- Ini 12.0
FUNCTION SGAFU_DATOS_CNT(PI_CODCNT MARKETING.VTAMEDCOMCNT.CODCNT%TYPE)
  RETURN NUMBER
  IS
  LI_CANT_TEL NUMBER(1);
  LI_CANT_CEL NUMBER(1);
  LI_CANT_COR NUMBER(1);
  LI_VAL_CNT NUMBER(1);
  BEGIN
    SELECT COUNT(*) INTO LI_CANT_TEL FROM MARKETING.VTAMEDCOMCNT
    WHERE IDMEDCOM IN ('001','002','014','024','025') AND NUMCOM IS NOT NULL AND CODCNT = PI_CODCNT;
    
    SELECT COUNT(*) INTO LI_CANT_CEL FROM MARKETING.VTAMEDCOMCNT
    WHERE IDMEDCOM IN ('003','016') AND NUMCOM IS NOT NULL AND CODCNT = PI_CODCNT;
      
    SELECT COUNT(*) INTO LI_CANT_COR FROM MARKETING.VTAMEDCOMCNT
    WHERE IDMEDCOM = '008' AND NUMCOM IS NOT NULL AND CODCNT = PI_CODCNT;
    
    IF LI_CANT_TEL=0 AND LI_CANT_CEL=0 THEN
       LI_VAL_CNT := 0;
    END IF;

    IF LI_CANT_TEL >= 1 AND LI_CANT_COR = 0 THEN
      LI_VAL_CNT := 0;
    END IF;
    
    IF LI_CANT_CEL >= 1 AND LI_CANT_COR = 0 THEN
      LI_VAL_CNT := 0;
    END IF;
    
    IF LI_CANT_TEL >= 1 AND LI_CANT_COR >= 1 THEN
      LI_VAL_CNT := 1;
    END IF;
    
    IF LI_CANT_CEL >= 1 AND LI_CANT_COR >= 1 THEN
      LI_VAL_CNT := 1;
    END IF;
    
    IF LI_CANT_TEL = 0 AND LI_CANT_CEL = 0 AND LI_CANT_COR >= 1 THEN
      LI_VAL_CNT := 0;
    END IF;
    
    IF LI_CANT_TEL = 0 AND LI_CANT_CEL = 0 AND LI_CANT_COR = 0 THEN
      LI_VAL_CNT := 0;
    END IF;
    
  RETURN LI_VAL_CNT;
    EXCEPTION
  WHEN OTHERS THEN RETURN 0;
END;

PROCEDURE SGASI_DATOS_CNT(PI_CODCNT    MARKETING.VTATABCNTCLI.CODCNT%TYPE,
                          PI_IDMEDCOM  MARKETING.VTAMEDCOMCNT.IDMEDCOM%TYPE,
                          PI_NUMCOM    MARKETING.VTAMEDCOMCNT.NUMCOM%TYPE,
                          PI_ANEXO     MARKETING.VTAMEDCOMCNT.ANEXO%TYPE,
                          PO_CODIGO    OUT VARCHAR2,
                          PO_MENSAJE   OUT VARCHAR2)
  IS
  LI_CANT NUMBER(1);
  BEGIN
    SELECT COUNT(*) INTO LI_CANT FROM VTAMEDCOMCNT WHERE IDMEDCOM = PI_IDMEDCOM AND CODCNT = PI_CODCNT;
    IF LI_CANT = 0 THEN
      INSERT INTO MARKETING.VTAMEDCOMCNT( IDMEDCOM,    CODCNT,    NUMCOM,    ANEXO )
                                  VALUES( PI_IDMEDCOM, PI_CODCNT, PI_NUMCOM, PI_ANEXO );
    END IF;
    
    IF LI_CANT >= 1 THEN
      UPDATE MARKETING.VTAMEDCOMCNT
      SET NUMCOM  = PI_NUMCOM,
          ANEXO      = PI_ANEXO
      WHERE IDMEDCOM = PI_IDMEDCOM
      AND   CODCNT   = PI_CODCNT;
    END IF;
    COMMIT;
    PO_CODIGO  := '0';
    PO_MENSAJE := 'EXITO';
    EXCEPTION
    WHEN no_data_found THEN
        PO_CODIGO  := '1';
        PO_MENSAJE := 'No se generó datos del contacto, verificar información.';
    WHEN OTHERS THEN
        PO_CODIGO  := '2';
        PO_MENSAJE := SQLCODE||' SGASI_DATOS_CNT '||SQLERRM;
END SGASI_DATOS_CNT;
-- Fin 12.0

END PKG_SIGCORP;
/
