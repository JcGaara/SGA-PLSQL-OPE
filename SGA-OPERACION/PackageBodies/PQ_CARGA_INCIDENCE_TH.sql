CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CARGA_INCIDENCE_TH IS
  /*******************************************************************************************************
    NOMBRE:       OPERACION.PQ_CONCILIACION_HFC
    PROPOSITO:
    REVISIONES:
    Version    Fecha       Autor            Solicitado por    Descripcion
    ---------  ----------  ---------------  --------------    -----------------------------------------
     1.0       01/03/2017  Luis Flores      Luis Flores       Cargar incidencias
  *******************************************************************************************************/
    PROCEDURE P_CARGA_INCIDENCE_TMP IS

      pragma autonomous_transaction;
      limite_in PLS_INTEGER DEFAULT 1000;

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence7
      CURSOR c_tmpresincidence7 is
        SELECT codincidence, MAX(codsequence) codsequence
        FROM incidence_sequence
        WHERE receiverdepartment = 29
          AND (codincidence, codsequence) IN
             (SELECT codincidence, codsequence FROM trouble)
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = incidence_sequence.CODINCIDENCE) --
        GROUP BY codincidence;

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence8
      CURSOR c_tmpresincidence8 IS
        SELECT e1.codincidence,
               e1.codsequence,
               e1.observation,
               e2.codtroubletype averia,
               e2.description    problema,
               e3.description    tipo,
               e4.description    responsable
        FROM trouble e1, trouble_type e2, associated e3, associated_detail e4
        WHERE e1.codtroubletype = e2.codtroubletype
          AND e1.codassociated = e3.codassociated(+)
          AND e1.codassocdetail = e4.codassocdetail(+)
          AND e1.codassociated = e4.codassociated(+)
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = e1.CODINCIDENCE);

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence9
      CURSOR c_tmpresincidence9 IS
        SELECT a.codincidence,
               a.codsequence,
               a.startdate,
               a.enddate,
               b.codassociated,
               NVL(a.enddate - a.startdate, 0) resta
        FROM time_interruption a, trouble b
        WHERE (a.codincidence, a.codsequence) IN
              (SELECT c.codincidence, MAX(codsequence) codsequence
               FROM trouble c
               WHERE c.codassociated = 1
               GROUP BY c.codincidence)
          AND a.codincidence = b.codincidence
          AND a.codsequence = b.codsequence
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = a.CODINCIDENCE);

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence10
      CURSOR c_tmpresincidence10 IS
        SELECT SUM(ra.duracion) duracion, ra.codincidence
        FROM (SELECT SUM(NVL((x.enddate - x.startdate), 0)) duracion, ii.codincidence
              FROM time_interruption x, incidence_sequence ii
              WHERE x.codincidence = ii.codincidence
                AND x.codsequence = ii.codsequence
                AND ii.codincseqtype = 3
              GROUP BY ii.codincidence
                UNION ALL
              SELECT SUM(NVL((a.enddate - a.startdate), 0)) duracion,
                     a.codincidence
              FROM time_interruption a, trouble b
              WHERE (a.codincidence, a.codsequence) IN
                    (SELECT c.codincidence, MAX(codsequence) codsequence
                     FROM trouble c
                     WHERE c.codassociated <> 1
                     GROUP BY c.codincidence)
                AND a.codincidence = b.codincidence
                AND a.codsequence = b.codsequence
               GROUP BY a.codincidence) ra
        WHERE NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = ra.CODINCIDENCE)--
        GROUP BY ra.codincidence;

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence11
      CURSOR c_tmpresincidence11 IS
        SELECT sequencedate, codincidence
        FROM  incidence_sequence
        WHERE (codincidence, codsequence) IN
              (SELECT codincidence, MIN(codsequence)
               FROM incidence_sequence
               WHERE deliverdepartment = 29
               GROUP BY codincidence)
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = incidence_sequence.CODINCIDENCE);

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence12
      CURSOR c_tmpresincidence12 IS
        SELECT sequencedate, codincidence
        FROM incidence_sequence
        WHERE (codincidence, codsequence) IN
              (SELECT codincidence, MAX(codsequence)
               FROM incidence_sequence
               WHERE receiverdepartment = 29
               GROUP BY codincidence)
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = incidence_sequence.CODINCIDENCE);

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence13
      CURSOR c_tmpresincidence13 IS
        SELECT inc.codincidence,
               SUM(DECODE(ROUND((p.enddate - ini_noc.sequencedate) * 24, 2),
                          NULL,
                          ROUND(((fin_noc.sequencedate - ini_noc.sequencedate) -
                                  NVL(r.duracion, 0)) * 24,2),
                          ROUND((p.resta) * 24, 2))) duracion
        FROM incidence          inc,
             ATCCORP.tmpresincidence7   noc,
             ATCCORP.tmpresincidence8   pro,
             v_incidence_maxseq fin,
             ATCCORP.tmpresincidence9   p,
             ATCCORP.tmpresincidence10  r,
             ATCCORP.tmpresincidence11  ini_noc,
             ATCCORP.tmpresincidence12  fin_noc
        WHERE inc.codincidence = noc.codincidence(+)
          AND ini_noc.codincidence = inc.codincidence
          AND fin_noc.codincidence = inc.codincidence
          AND noc.codincidence = pro.codincidence(+)
          AND noc.codsequence = pro.codsequence(+)
          AND inc.codincidence = fin.codincidence
          AND r.codincidence(+) = inc.codincidence
          AND p.codincidence(+) = inc.codincidence
          AND ((inc.codstatus > 3) OR
                   (fin.deliverdepartment <> 29 AND inc.codstatus < 4))
        GROUP BY inc.codincidence;

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence14
      CURSOR c_tmpresincidence14 IS
        SELECT a.codincidence,
               a.codsequence,
               a.codassociated,
               MAX(a.enddate) fecha_fin
        FROM time_interruption a, trouble b
        WHERE (a.codincidence, a.codassociated, a.codsequence) in
              (SELECT c.codincidence,
                      c.codassociated,
                      MAX(codsequence) codsequence
               FROM trouble c, trouble_type t
               WHERE c.codassociated = 1
                 AND t.codtroubletype = c.codtroubletype
               GROUP BY c.codincidence, c.codassociated)
          AND a.codincidence = b.codincidence
          AND a.codsequence = b.codsequence
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = a.CODINCIDENCE)
        GROUP BY a.codincidence, a.codsequence, a.codassociated;

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence15
      CURSOR c_tmpresincidence15 IS
        SELECT c.codincidence, c.codassociated, max(codsequence) codsequence
        FROM trouble c, trouble_type t
        WHERE c.codassociated = 6
          AND t.codtroubletype = c.codtroubletype
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = c.CODINCIDENCE)---
        GROUP BY c.codincidence, c.codassociated;


      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence16
      CURSOR c_tmpresincidence16 IS
        SELECT codincidence, MAX(codsequence) codsequence
        FROM incidence_sequence
        WHERE receiverdepartment = 29
          AND NOT EXISTS (SELECT 1 FROM resincidence RS WHERE RS.CODINCIDENCE = incidence_sequence.CODINCIDENCE)
        GROUP BY codincidence;

      -- Cursos que obtiene datos para cargalos en la tabla temporal tmpresincidence17
      CURSOR c_tmpresincidence17 IS
        SELECT i.codincidence,
               DECODE(v_trouble.fecha_fin - i.userdate -
                      ABS(v_trouble.fecha_fin - i.userdate),
                          0,
                      ROUND((v_trouble.fecha_fin - i.userdate) * 24, 2),
                          0) tiempo_reparacion
        FROM incidence          i,
             incidence_sequence s,
             status             st,
             ATCCORP.tmpresincidence14  v_trouble
        WHERE i.codincidence = v_trouble.codincidence
          AND v_trouble.codincidence = s.codincidence
          AND v_trouble.codsequence = s.codsequence
          AND st.codstatus = i.codstatus
          AND st.sequencetype >= 3
        UNION ALL
        SELECT i.codincidence,
               DECODE(s.sequencedate - i.userdate -
                      ABS(s.sequencedate - i.userdate),
                          0,
                      (s.sequencedate - i.userdate) * 24,
                          0) tiempo_reparacion
        FROM incidence          i,
             incidence_sequence s,
             status             st,
             ATCCORP.tmpresincidence15  v_trouble,
             ATCCORP.tmpresincidence16  v_max_noc
        WHERE i.codincidence = v_trouble.codincidence
          AND v_max_noc.codincidence = i.codincidence
          AND s.codincidence = v_max_noc.codincidence(+)
          AND s.codsequence = v_max_noc.codsequence(+)
          AND st.codstatus = i.codstatus
          AND st.sequencetype >= 3;

      TYPE reg_tmpresincidence7 IS TABLE OF c_tmpresincidence7%rowtype INDEX BY PLS_INTEGER;
      l_instancia_7 reg_tmpresincidence7;

      TYPE reg_tmpresincidence8 IS TABLE OF c_tmpresincidence8%rowtype INDEX BY PLS_INTEGER;
      l_instancia_8 reg_tmpresincidence8;

      TYPE reg_tmpresincidence9 IS TABLE OF c_tmpresincidence9%rowtype INDEX BY PLS_INTEGER;
      l_instancia_9 reg_tmpresincidence9;

      TYPE reg_tmpresincidence10 IS TABLE OF c_tmpresincidence10%rowtype INDEX BY PLS_INTEGER;
      l_instancia_10 reg_tmpresincidence10;

      TYPE reg_tmpresincidence11 IS TABLE OF c_tmpresincidence11%rowtype INDEX BY PLS_INTEGER;
      l_instancia_11 reg_tmpresincidence11;

      TYPE reg_tmpresincidence12 IS TABLE OF c_tmpresincidence12%rowtype INDEX BY PLS_INTEGER;
      l_instancia_12 reg_tmpresincidence12;

      TYPE reg_tmpresincidence13 IS TABLE OF c_tmpresincidence13%rowtype INDEX BY PLS_INTEGER;
      l_instancia_13 reg_tmpresincidence13;

      TYPE reg_tmpresincidence14 IS TABLE OF c_tmpresincidence14%rowtype INDEX BY PLS_INTEGER;
      l_instancia_14 reg_tmpresincidence14;

      TYPE reg_tmpresincidence15 IS TABLE OF c_tmpresincidence15%rowtype INDEX BY PLS_INTEGER;
      l_instancia_15 reg_tmpresincidence15;

      TYPE reg_tmpresincidence16 IS TABLE OF c_tmpresincidence16%rowtype INDEX BY PLS_INTEGER;
      l_instancia_16 reg_tmpresincidence16;

      TYPE reg_tmpresincidence17 IS TABLE OF c_tmpresincidence17%rowtype INDEX BY PLS_INTEGER;
      l_instancia_17 reg_tmpresincidence17;

      BEGIN

       /* P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio truncate tables atccorp');

        ATCCORP.P_LIMPIA_TAB_RESUMEN_INC;

       \* --trunca la tabla atcresincidence_t para recargarla
        EXECUTE IMMEDIATE 'truncate table atccorp.atcresincidence_t reuse storage';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE7 ';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE8 ';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE9 ';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE10';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE11';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE12';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE13';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE14';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE15';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE16';
        EXECUTE IMMEDIATE 'truncate table atccorp.TMPRESINCIDENCE17';*\

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin truncate tables atccorp');*/

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Delete table resincidence for mes_cierre is null or mes_cierre = yyyymm actual');

        -- Limpiando data
        DELETE FROM resincidence
        WHERE mes_cierre IS NULL
           OR mes_cierre = to_char(SYSDATE, 'yyyymm');
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Delete table resincidence for mes_cierre is null or mes_cierre = yyyymm actual');

        IF to_char(SYSDATE, 'dd') in ('01', '02') THEN

          P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Delete table resincidence for mes_cierre = yyyymm - 1 actual si es d?a 01 or 02');

          DELETE FROM resincidence
          WHERE mes_cierre = to_char(SYSDATE, 'yyyymm') - 1;

          COMMIT;

          P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Delete table resincidence for mes_cierre = yyyymm - 1 actual si es d?a 01 or 02');

        END IF ;

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence7 por cursor c_tmpresincidence7');

        OPEN c_tmpresincidence7;
          LOOP
            FETCH c_tmpresincidence7 BULK COLLECT
              INTO l_instancia_7 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_7.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence7
                  (CODINCIDENCE, CODSEQUENCE)
                VALUES
                  (l_instancia_7(indx).codincidence,
                   l_instancia_7(indx).codsequence);
                commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;

            EXIT WHEN l_instancia_7.COUNT = 0;
          END LOOP;
        CLOSE c_tmpresincidence7;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence7 por cursor c_tmpresincidence7');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence8 por cursor c_tmpresincidence8');

        OPEN c_tmpresincidence8;
          LOOP
            FETCH c_tmpresincidence8 BULK COLLECT
            INTO l_instancia_8 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_8.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence8
                  (CODINCIDENCE,
                   CODSEQUENCE,
                   OBSERVATION,
                   AVERIA,
                   PROBLEMA,
                   TIPO,
                   RESPONSABLE)
                VALUES
                  (l_instancia_8(indx).codincidence,
                   l_instancia_8(indx).codsequence,
                   l_instancia_8(indx).observation,
                   l_instancia_8(indx).averia,
                   l_instancia_8(indx).problema,
                   l_instancia_8(indx).tipo,
                   l_instancia_8(indx).responsable);

                   commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_8.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence8;

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence8 por cursor c_tmpresincidence8');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence9 por cursor c_tmpresincidence9');

        OPEN c_tmpresincidence9;
          LOOP
            FETCH c_tmpresincidence9 BULK COLLECT
             INTO l_instancia_9 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_9.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence9
                  (CODINCIDENCE,
                   CODSEQUENCE,
                   STARTDATE,
                   ENDDATE,
                   CODASSOCIATED,
                   RESTA)
                VALUES
                  (l_instancia_9(indx).codincidence,
                   l_instancia_9(indx).codsequence,
                   l_instancia_9(indx).startdate,
                   l_instancia_9(indx).enddate,
                   l_instancia_9(indx).codassociated,
                   l_instancia_9(indx).resta);
               commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_9.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence9;

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence9 por cursor c_tmpresincidence9');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence10 por cursor c_tmpresincidence10');

        OPEN c_tmpresincidence10;
          LOOP
            FETCH c_tmpresincidence10 BULK COLLECT
             INTO l_instancia_10 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_10.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence10
                  (CODINCIDENCE, DURACION)
                VALUES
                  (l_instancia_10(indx).codincidence,
                   l_instancia_10(indx).duracion);
              commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_10.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence10;

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence10 por cursor c_tmpresincidence10');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence11 por cursor c_tmpresincidence11');

        OPEN c_tmpresincidence11;
          LOOP
            FETCH c_tmpresincidence11 BULK COLLECT
             INTO l_instancia_11 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_11.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence11
                  (CODINCIDENCE, SEQUENCEDATE)
                VALUES
                  (l_instancia_11(indx).codincidence,
                   l_instancia_11(indx).sequencedate);
              commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_11.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence11;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence11 por cursor c_tmpresincidence11');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence12 por cursor c_tmpresincidence12');

        OPEN c_tmpresincidence12;
          LOOP
            FETCH c_tmpresincidence12 BULK COLLECT
             INTO l_instancia_12 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_12.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence12
                  (CODINCIDENCE, SEQUENCEDATE)
                VALUES
                  (l_instancia_12(indx).codincidence,
                   l_instancia_12(indx).sequencedate);
              commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_12.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence12;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence12 por cursor c_tmpresincidence12');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence13 por cursor c_tmpresincidence13');

        OPEN c_tmpresincidence13;
          LOOP
            FETCH c_tmpresincidence13 BULK COLLECT
             INTO l_instancia_13 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_13.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence13
                  (CODINCIDENCE, DURACION)
                VALUES
                  (l_instancia_13(indx).codincidence,
                   l_instancia_13(indx).duracion);
              commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_13.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence13;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence13 por cursor c_tmpresincidence13');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence14 por cursor c_tmpresincidence14');

        --Seteando el tiempo de Reparacion
        OPEN c_tmpresincidence14;
          LOOP
            FETCH c_tmpresincidence14 BULK COLLECT
             INTO l_instancia_14 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_14.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence14
                  (CODINCIDENCE, CODSEQUENCE, CODASSOCIATED, FECHA_FIN)
                VALUES
                  (l_instancia_14(indx).codincidence,
                   l_instancia_14(indx).codsequence,
                   l_instancia_14(indx).codassociated,
                   l_instancia_14(indx).fecha_fin);
              commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_14.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence14;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence14 por cursor c_tmpresincidence14');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence15 por cursor c_tmpresincidence15');

        OPEN c_tmpresincidence15;
          LOOP
            FETCH c_tmpresincidence15 BULK COLLECT
             INTO l_instancia_15 LIMIT limite_in;
            FOR indx IN 1 .. l_instancia_15.count LOOP
              BEGIN
                INSERT INTO ATCCORP.tmpresincidence15
                  (CODINCIDENCE, CODASSOCIATED, CODSEQUENCE)
                VALUES
                  (l_instancia_15(indx).codincidence,
                   l_instancia_15(indx).codassociated,
                   l_instancia_15(indx).codsequence);
              commit;
              exception
                when others then
                  rollback;
              END;
            END LOOP;
            EXIT WHEN l_instancia_15.COUNT < limite_in;
          END LOOP;
        CLOSE c_tmpresincidence15;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence15 por cursor c_tmpresincidence15');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence16 por cursor c_tmpresincidence16');

        OPEN c_tmpresincidence16;
        LOOP
          FETCH c_tmpresincidence16 BULK COLLECT
            INTO l_instancia_16 LIMIT limite_in;
          FOR indx IN 1 .. l_instancia_16.count LOOP
            BEGIN
              INSERT INTO ATCCORP.tmpresincidence16
                (CODINCIDENCE, CODSEQUENCE)
              VALUES
                (l_instancia_16(indx).codincidence,
                 l_instancia_16(indx).codsequence);
            commit;
              exception
                when others then
                  rollback;
            END;
          END LOOP;
          EXIT WHEN l_instancia_16.COUNT < limite_in;
        END LOOP;
        CLOSE c_tmpresincidence16;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence16 por cursor c_tmpresincidence16');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table tmpresincidence17 por cursor c_tmpresincidence17');

        OPEN c_tmpresincidence17;
        LOOP
          FETCH c_tmpresincidence17 BULK COLLECT
            INTO l_instancia_17 LIMIT limite_in;
          FOR indx IN 1 .. l_instancia_17.count LOOP
            BEGIN
              INSERT INTO ATCCORP.tmpresincidence17
                (CODINCIDENCE, TIEMPO_REPARACION)
              VALUES
                (l_instancia_17(indx).codincidence,
                 l_instancia_17(indx).tiempo_reparacion);
            commit;
              exception
                when others then
                  rollback;
            END;
          END LOOP;
          EXIT WHEN l_instancia_17.COUNT < limite_in;
        END LOOP;
        CLOSE c_tmpresincidence17;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table tmpresincidence17 por cursor c_tmpresincidence17');

      END;

    PROCEDURE p_carga_incidence_ln IS

      ln_hilos     NUMBER;
      ln_idproceso NUMBER;
      lv_username  VARCHAR2(100);
      lv_password  VARCHAR2(100);
      lv_url       VARCHAR2(200);
      lv_nsp       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||
                                  '.p_carga_incidence_bl';
      lv_nsp_im       VARCHAR2(100) := 'OPERACION.' || $$plsql_unit ||
                                  '.p_genera_imagen_mensual_bl';
      BEGIN

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio truncate tables atccorp P_LIMPIA_TAB_RESUMEN_INC');

        ATCCORP.P_LIMPIA_TAB_RESUMEN_INC;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin truncate tables atccorp P_LIMPIA_TAB_RESUMEN_INC');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio llamada al proceso OPERACION.P_CARGA_INCIDENCE_TMP');

        -- Cargamos las tablas temporales
        P_CARGA_INCIDENCE_TMP;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin llamada al proceso OPERACION.P_CARGA_INCIDENCE_TMP');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio llamada al sequence OPERACION.SQ_TAB_TH_INCIDENCE.NEXTVAL');

        -- Obtenemos el nro. proceso
        SELECT OPERACION.SQ_TAB_TH_INCIDENCE.NEXTVAL
        INTO ln_idproceso
        FROM DUAL;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin llamada al sequence OPERACION.SQ_TAB_TH_INCIDENCE.NEXTVAL');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio llamada a funcion f_getConstante ');

        -- Obtener datos iniciales
        ln_hilos    := to_number(f_getConstante('NUMH_CARGA_INC'));
        lv_username := f_getConstante('OPTHFCUSER');
        lv_password := f_getConstante('OPTHFCPWD');
        lv_url      := f_getConstante('OPTHFCURL');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin llamada a funcion f_getConstante. Nro. Hilos: '||ln_hilos);

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio insert OPERACION.THINCIDENCE');

        -- Cargar datos
        INSERT INTO /*+ append */
          OPERACION.THINCIDENCE(IDPROCESO, CODINCIDENCE, ID_TAREA, ESTADO)
        SELECT ln_idproceso, q.codincidence, ROWNUM, 0
        FROM (SELECT DISTINCT i.codincidence FROM incidence i
              WHERE NOT EXISTS (SELECT 1 FROM resincidence rs WHERE rs.codincidence = i.codincidence)) q;

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin insert OPERACION.THINCIDENCE ');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio update OPERACION.THINCIDENCE');

        --Agrupar los hilos
        UPDATE /*+ parallel(b,4)*/ operacion.thincidence b
          SET b.id_tarea = DECODE(MOD(b.id_tarea, ln_hilos),
                                 0,
                                 ln_hilos,
                                 MOD(b.id_tarea, ln_hilos))
        WHERE b.idproceso = ln_idproceso;

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin update OPERACION.THINCIDENCE');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio llamada al metodo del hilo OPERACION.PQ_CARGA_INCIDENCE_TH.p_ThreadRun - Ejecuta p_carga_incidence_bl');

        --Ejecutamos los Hilos
        OPERACION.PQ_CARGA_INCIDENCE_TH.p_ThreadRun(lv_username, lv_password,
                                                lv_url, lv_nsp, ln_idproceso,
                                                ln_hilos);

        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin llamada al metodo del hilo OPERACION.PQ_CARGA_INCIDENCE_TH.p_ThreadRun - Ejecuta p_carga_incidence_bl');


        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio delete table resincidence por mes');

        delete from resincidence
        where mes_cierre is null or mes_cierre = to_char(sysdate,'yyyymm');

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin delete table resincidence por mes');

        if to_char(sysdate,'dd') in ('01','02') then
          P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio delete table resincidence por mes anterior');

          delete from resincidence
          where mes_cierre = to_char(sysdate,'yyyymm')-1;

          P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin delete table resincidence por mes anterior');

        end if;
        COMMIT;

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio llamada al metodo del hilo OPERACION.PQ_CARGA_INCIDENCE_TH.p_ThreadRun - Ejecuta p_genera_imagen_mensual_bl');
        --P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio llamada al procedimiento OPERACION.PQ_CARGA_INCIDENCE_TH.p_genera_imagen_mensual_ln');

        --Registramos los valores obtenidos de la tabla ATCCORP.atcresincidence_t a atccorp.reincidence
        --ATCCORP.pq_pe_util_atc.p_genera_imagen_mensual;
        --OPERACION.PQ_CARGA_INCIDENCE_TH.p_genera_imagen_mensual;
        --OPERACION.PQ_CARGA_INCIDENCE_TH.p_genera_imagen_mensual_ln;
        --Ejecutamos los Hilos para insertar datos de la tabla atccorp.atcresincidence_t hacia ATCCORP.resincidence
        OPERACION.PQ_CARGA_INCIDENCE_TH.p_ThreadRun(lv_username, lv_password,
                                                lv_url, lv_nsp_im, ln_idproceso,
                                                ln_hilos);

        COMMIT;

        --P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin llamada al procedimiento OPERACION.PQ_CARGA_INCIDENCE_TH.p_genera_imagen_mensual_ln');
        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin llamada al metodo del hilo OPERACION.PQ_CARGA_INCIDENCE_TH.p_ThreadRun - Ejecuta p_genera_imagen_mensual_bl');

      END;

    PROCEDURE p_carga_incidence_bl(an_idproceso NUMBER, an_idtarea   NUMBER) IS

      -- Obtenet el limite para bulk collect
      ln_limit_in PLS_INTEGER DEFAULT 1000;


      CURSOR c_incidence IS
        SELECT incidence.codincidence codincidence,
               incidence.nticket nticket,
               (SELECT incidence_type.description || '-' || d.description
                FROM incidence_description d, incidence_subtype s
                WHERE s.codincdescription = d.codincdescription
                  AND s.codsubtype = incidence_subtype.codsubtype) subtipo,
               incidence_type.description tipo,
               DECODE(incidence.codincmotive, 9, 'Calidad', 'Administrativo') tipo_reclamo,
               DECODE(incidence_subtype.flagoneclient, 1, 'Cliente', 'Masivo') es_masivo,
               incidence_motive.description motivo,
               typeservice_atention.description servicio,
               responsible_atention.userid responsable,
               case_atention.description tipo_caso,
               type_atention.description tipo_atencion,
               incidence.userdate f_generacion,
               incidence.usercode registrado_por,
               status.description estado,
               incidence_type.codinctype,
               incidence_subtype.codsubtype,
               DECODE(incidence_subtype.flagclientexists,
                      1,
                      'Cliente',
                      'No Cliente') es_cliente,
               typeservice_atention.codtypeservice,
               incidence_motive.codincmotive,
               case_atention.codcase,
               responsible_atention.codresponsible,
               status.codstatus,
               type_atention.codtypeatention,
               channel.codchannel,
               channel.description,
               severidad.dessev,
               severidad.codsev,
               incidence.flagfounded,
               (select cod_grouptype
                from incidence_group_type
                where cod_grouptype = incidence_type.cod_grouptype) codgrouptype,
               (select description
                from incidence_group_type
                where cod_grouptype = incidence_type.cod_grouptype) desc_grouptype
        FROM responsible_atention,
             case_atention,
             incidence,
             incidence_motive,
             incidence_subtype,
             incidence_type,
             typeservice_atention,
             status,
             type_atention,
             channel,
             severidad
        WHERE (case_atention.codcase = incidence.codcase)
          AND (incidence_subtype.codinctype = incidence_type.codinctype)
          AND (incidence.codsubtype = incidence_subtype.codsubtype)
          AND (incidence.codtypeservice = typeservice_atention.codtypeservice)
          AND (responsible_atention.codresponsible(+) = incidence.userresponsible)
          AND (case_atention.codincmotive = incidence_motive.codincmotive(+))
          AND incidence.codstatus = status.codstatus
          AND incidence.codtypeatention = type_atention.codtypeatention
          AND incidence.codchannel = channel.codchannel
          AND case_atention.codsev = severidad.codsev(+)
          AND EXISTS (SELECT 1 FROM operacion.thincidence t
                      WHERE t.idproceso = an_idproceso
                        AND t.id_tarea = an_idtarea
                        AND t.codincidence = incidence.codincidence);

      TYPE array_object IS TABLE OF c_incidence%ROWTYPE INDEX BY BINARY_INTEGER;
      var_array array_object;


      ln_cntrec   NUMBER := 0;
      ln_cnterr   NUMBER := 0;
      ln_cntok    NUMBEr := 0;

      le_pq EXCEPTION;

      lv_userid                 VARCHAR2(30);
      ln_receiverdepartment     NUMBER;
      ln_deliverdepartment      NUMBER;
      lv_deliveruser            VARCHAR2(30);
      ld_sequencedate           DATE;
      lv_mesgeneracion          VARCHAR2(6);
      ln_clo_codsequence        NUMBER;
      lv_clo_userid             VARCHAR2(30);
      ln_clo_receiverdepartment NUMBER;
      lv_clo_deliverdepartment  NUMBER;
      lv_clo_deliveruser        VARCHAR2(30);
      ld_fecha_cierre           DATE;
      lv_mes_cierre             VARCHAR2(6);
      ld_fecha_solucion         DATE;

      ln_tiempo_solucion        NUMBER;
      ln_num_clientes           NUMBER(10);
      ln_num_servicios          NUMBER(10);

      lc_codcli                 CHAR(8);
      lv_cliente                VARCHAR2(200);
      lv_segmento               VARCHAR2(100);
      ln_codsegmark             NUMBER(2);
      lv_sector                 VARCHAR2(200);
      lv_tipper                 VARCHAR2(3);

      lv_nro_servicio           VARCHAR2(20);
      lv_producto               VARCHAR2(200);

      ln_codsolot               NUMBER;
      ln_codot                  NUMBER;
      lv_areaope                VARCHAR2(200);

      ln_duracion_interrup      NUMBER;

      ln_codCategoria           NUMBER(2);
      lv_categoria              VARCHAR2(50);

      ln_tiempo_reparacion      NUMBER(10,2);
      ln_tiempo_corte           NUMBER(10,2);

      ld_sequencedate_tmp11     DATE;

      ld_sequencedate_tmp12     DATE;


      BEGIN

        P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio cursor c_incidence, proceso:  '||an_idproceso||' tarea:  '||an_idtarea);

        OPEN c_incidence;
          LOOP
            FETCH c_incidence BULK COLLECT INTO var_array LIMIT ln_limit_in;
            FOR indx IN 1 .. var_array.COUNT LOOP
              BEGIN
                lv_userid             := null;
                ln_receiverdepartment := null;
                ln_deliverdepartment  := null;
                lv_deliveruser        := null;
                ld_sequencedate       := null;
                lv_mesgeneracion      := null;

                ln_clo_codsequence        := null;
                lv_clo_userid             := null;
                ln_clo_receiverdepartment := null;
                lv_clo_deliverdepartment  := null;
                lv_clo_deliveruser        := null;
                ld_fecha_cierre           := null;
                lv_mes_cierre             := null;
                ld_fecha_solucion         := null;

                ln_cntrec := ln_cntrec + 1;

                ln_tiempo_solucion     := null;
                ln_num_clientes        := null;
                ln_num_servicios       := null;

                lc_codcli              := null;
                lv_cliente             := null;
                lv_segmento            := null;
                ln_codsegmark          := null;
                lv_sector              := null;
                lv_tipper              := null;

                lv_nro_servicio        := null;
                lv_producto            := null;

                ln_codsolot            := null;
                ln_codot               := null;
                lv_areaope             := null;

                ln_duracion_interrup   := null;

                ln_codCategoria        := null;
                lv_categoria           := null;

                BEGIN

                  SELECT incidence_sequence.userid,
                         incidence_sequence.receiverdepartment,
                         incidence_sequence.deliverdepartment,
                         incidence_sequence.deliveruser,
                         incidence_sequence.sequencedate,
                         TO_CHAR(incidence_sequence.sequencedate, 'YYYYMM')
                    INTO lv_userid,
                         ln_receiverdepartment,
                         ln_deliverdepartment,
                         lv_deliveruser,
                         ld_sequencedate,
                         lv_mesgeneracion
                  FROM ATCCORP.incidence_sequence
                  WHERE incidence_sequence.codsequence = 1
                    AND incidence_sequence.codincidence = var_array(indx).codincidence;

                EXCEPTION
                  WHEN OTHERS THEN
                    lv_userid             := null;
                    ln_receiverdepartment := null;
                    ln_deliverdepartment  := null;
                    lv_deliveruser        := null;
                    ld_sequencedate       := null;
                    lv_mesgeneracion      := null;
                END;

                BEGIN

                  SELECT incidence_sequence.codsequence,
                         incidence_sequence.userid,
                         incidence_sequence.receiverdepartment,
                         incidence_sequence.deliverdepartment,
                         incidence_sequence.deliveruser,
                         incidence_sequence.sequencedate,
                         TO_CHAR(incidence_sequence.sequencedate, 'YYYYMM') mes_cierre,
                         incidence_sequence.sequencedate
                    INTO ln_clo_codsequence,
                         lv_clo_userid,
                         ln_clo_receiverdepartment,
                         lv_clo_deliverdepartment,
                         lv_clo_deliveruser,
                         ld_fecha_cierre,
                         lv_mes_cierre,
                         ld_fecha_solucion
                  FROM ATCCORP.incidence_sequence
                  WHERE incidence_sequence.codincidence = var_array(indx).codincidence
                    AND incidence_sequence.codsequence =
                        (SELECT MIN(codsequence)
                         FROM incidence_sequence a1, status
                         WHERE a1.codincidence = var_array(indx).codincidence
                           AND a1.codstatus = status.codstatus
                           AND (status.sequencetype = 3 OR status.sequencetype = 4)
                           AND codincseqtype <> 2);
                EXCEPTION
                  WHEN OTHERS THEN
                    ln_clo_codsequence        := null;
                    lv_clo_userid             := null;
                    ln_clo_receiverdepartment := null;
                    lv_clo_deliverdepartment  := null;
                    lv_clo_deliveruser        := null;
                    ld_fecha_cierre           := null;
                    lv_mes_cierre             := null;
                    ld_fecha_solucion         := null;
                END;

                --calculamos el tiempo de Solucion
                IF (ld_fecha_solucion IS NOT NULL AND var_array(indx).f_generacion IS NOT NULL ) THEN
                   ln_tiempo_solucion :=  round((ld_fecha_solucion - var_array(indx).f_generacion) * 24, 2);
                ELSE
                   ln_tiempo_solucion := NULL;
                END IF;

                -- Verificamos si la incidencia fue registrada por un cliente o no
                IF (var_array(indx).es_cliente = 'Cliente') THEN

                  SELECT COUNT(DISTINCT customercode), COUNT(DISTINCT servicenumber)
                    INTO ln_num_clientes, ln_num_servicios
                  FROM ATCCORP.customerxincidence c
                  WHERE c.codincidence = var_array(indx).codincidence;

                  -- Si la cantidad de clientes es 1
                  IF ln_num_clientes = 1 THEN

                    BEGIN
                      -- Obtenemos los datos del ciente
                      SELECT cli.codcli, cli.nomcli,
                             decode(s.dscsegmark, null, 'SIN DEFINIR', s.dscsegmark) as dscsegmark,
                             s.codsegmark,
                             decode(sec.dscsecmark, null, 'SIN DEFINIR', sec.dscsecmark) as dscsecmark,
                             cli.tipper
                        INTO  lc_codcli, lv_cliente, lv_segmento, ln_codsegmark, lv_sector, lv_tipper
                      FROM customerxincidence c,
                           vtatabcli          cli,
                           vtatabsegmark      s,
                           vtatabsecmark      sec
                      WHERE c.customercode = cli.codcli
                        AND cli.codsegmark = s.codsegmark(+)
                        AND c.codincidence = var_array(indx).codincidence
                        AND cli.codsecmark = sec.codsecmark(+);
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        lc_codcli       := null;
                        lv_cliente      := null;
                        lv_segmento     := null;
                        ln_codsegmark   := null;
                        lv_sector       := null;
                        lv_tipper       := null;

                      WHEN OTHERS THEN
                        lc_codcli       := null;
                        lv_cliente      := null;
                        lv_segmento     := null;
                        ln_codsegmark   := null;
                        lv_sector       := null;
                        lv_tipper       := null;
                    END;

                    BEGIN

                      -- Obtenemos la solot que se encuentra asociado a una incidencia
                      SELECT d2.codsolot, d2.codot, d3.descripcion
                        INTO ln_codsolot, ln_codot, lv_areaope
                      FROM OPERACION.solot d1, OPERACION.ot d2, OPERACION.areaope d3,
                           (SELECT MAX(codsolot) codsolot, recosi FROM OPERACION.solot WHERE recosi IS NOT NULL GROUP BY recosi) d4 --
                      WHERE d1.codsolot = d2.codsolot
                        AND d2.area = d3.area(+)
                        AND d1.recosi IS NOT NULL
                        AND d1.recosi = d4.recosi
                        AND d1.codsolot = d4.codsolot
                        AND d1.recosi = var_array(indx).codincidence
                        AND ROWNUM = 1
                        ;

                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        ln_codsolot   := null;
                        ln_codot      := null;
                        lv_areaope    := null;

                      WHEN OTHERS THEN
                        ln_codsolot   := null;
                        ln_codot      := null;
                        lv_areaope    := null;
                    END;
                  END IF;

                  BEGIN
                    /****Actualiza el servicio y el producto************/
                    SELECT cxi.service, prodcorp.descripcion
                      INTO lv_nro_servicio, lv_producto
                    FROM ATCCORP.customerxincidence cxi,
                         (SELECT DISTINCT codinssrv, codprd FROM acceso) acc,
                         METASOLV.productocorp prodcorp
                    WHERE cxi.servicenumber = acc.codinssrv(+)
                      AND acc.codprd = prodcorp.codprd(+)
                      AND cxi.codincidence = var_array(indx).codincidence;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      lv_nro_servicio  := null;
                      lv_producto      := null;

                    WHEN OTHERS THEN
                      lv_nro_servicio  := null;
                      lv_producto      := null;
                  END;

                -- Si no es cliente
                ELSIF (var_array(indx).es_cliente = 'No Cliente') THEN

                  -- Obtenemos cantidad de servicios y clientes
                  SELECT COUNT(DISTINCT customercode), COUNT(DISTINCT servicenumber)
                    INTO ln_num_clientes, ln_num_servicios
                  FROM ATCCORP.customerxincidence c
                  WHERE c.codincidence = var_array(indx).codincidence;

                  -- Si numero de clientes es 1
                  IF ln_num_clientes = 1 THEN

                    BEGIN
                      -- Seteamos los datos para el clientes
                      SELECT NULL, UPPER(field1), 'SIN DEFINIR', 'SIN DEFINIR'
                        INTO lc_codcli, lv_cliente, lv_segmento, lv_sector
                      FROM ATCCORP.anexoxcustomerxinc c
                      WHERE c.codincidence =  var_array(indx).codincidence;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        lc_codcli      := null;
                        lv_cliente     := null;
                        lv_segmento    :=NULL;
                        lv_sector      :=NULL;
                      WHEN OTHERS THEN
                        lc_codcli      := null;
                        lv_cliente     := null;
                        lv_segmento    :=NULL;
                        lv_sector      :=NULL;
                    END;

                  END IF;

                  BEGIN
                    /****Actualiza el servicio y el producto************/
                    SELECT c.customercode, 'Sin definir'
                      INTO lv_nro_servicio, lv_producto
                    FROM ATCCORP.anexoxcustomerxinc c
                    WHERE c.codincidence =  var_array(indx).codincidence
                      AND ROWNUM = 1;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      lv_nro_servicio      := null;
                      lv_producto     := null;
                    WHEN OTHERS THEN
                      lv_nro_servicio      := null;
                      lv_producto     := null;
                  END;

                END IF;

                -- Datos de Cliente - Masivas
                IF (ln_num_clientes <> 1) THEN

                  lc_codcli := NULL;
                  lv_cliente := 'MASIVA';
                  lv_segmento := 'SIN DEFINIR';
                  lv_sector := 'SIN DEFINIR';

                END IF;

                BEGIN
                  -- Obtenemos el tiempo de interrupcion de la incidencia en horas
                  SELECT a.resta
                    INTO ln_duracion_interrup
                  FROM (SELECT codincidence, SUM(ROUND(nvl(enddate - startdate, 0)*24,4)) resta
                        FROM ATCCORP.time_interruption
                        GROUP BY codincidence) a
                  WHERE a.codincidence = var_array(indx).codincidence
                    AND ROWNUM = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ln_duracion_interrup   := null;
                  WHEN OTHERS THEN
                    ln_duracion_interrup   := null;
                END;


                BEGIN
                  -- obtenemos la Categoria
                  SELECT c.codcategory, c.description
                    INTO ln_codCategoria, lv_categoria
                  FROM ATCCORP.customer_category c
                  WHERE c.codcategory = atccorp.f_inc_obtiene_categoria(var_array(indx).codincidence);

                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ln_codCategoria        := null;
                    lv_categoria           := null;

                  WHEN OTHERS THEN
                    ln_codCategoria        := null;
                    lv_categoria           := null;
                END;

                -- En caso no exita categoria, seteamos como categor?a 0
                IF (ln_codCategoria IS NULL) THEN --OR TRIM(ln_codCategoria) = ''

                  SELECT c.codcategory, c.description
                    INTO ln_codCategoria, lv_categoria
                  FROM ATCCORP.customer_category c
                  WHERE c.codcategory = 0;

                END IF;

                BEGIN
                  SELECT vReg1.duracion
                    INTO ln_tiempo_corte
                  FROM atccorp.tmpresincidence13 vReg1
                  WHERE vReg1.codincidence = var_array(indx).codincidence;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ln_tiempo_corte   := null;
                  WHEN OTHERS THEN
                    ln_tiempo_corte   := null;
                END;

                BEGIN
                  SELECT vReg1.tiempo_reparacion
                    INTO ln_tiempo_reparacion
                  FROM atccorp.tmpresincidence17 vReg1
                  WHERE vReg1.codincidence = var_array(indx).codincidence
                    and rownum = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ln_tiempo_reparacion      := null;
                  WHEN OTHERS THEN
                    ln_tiempo_reparacion      := null;
                END;

                BEGIN
                  SELECT a.sequencedate
                    INTO ld_sequencedate_tmp11
                  FROM atccorp.tmpresincidence11 a
                  WHERE codincidence = var_array(indx).codincidence
                    AND ROWNUM = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ld_sequencedate_tmp11      := null;
                  WHEN OTHERS THEN
                    ld_sequencedate_tmp11      := null;
                END;

                BEGIN
                  SELECT a.sequencedate
                    INTO ld_sequencedate_tmp12
                  FROM atccorp.tmpresincidence12 a
                  WHERE codincidence = var_array(indx).codincidence
                    AND ROWNUM = 1;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    ld_sequencedate_tmp12      := null;
                  WHEN OTHERS THEN
                    ld_sequencedate_tmp12      := null;
                END;

                IF (ld_sequencedate_tmp11 <> ld_sequencedate_tmp12) THEN
                  ld_sequencedate_tmp11 := ld_sequencedate_tmp12;
                END IF;

                BEGIN
                  INSERT INTO ATCCORP.atcresincidence_t
                  ( codincidence,
                    nticket,
                    subtipo,
                    tipo,
                    tipo_reclamo,
                    es_masivo,
                    motivo,
                    servicio,
                    responsable,
                    tipo_caso,
                    tipo_atencion,
                    fecha_registro,
                    registrado_por,
                    estado,
                    codinctype,
                    codsubtype,
                    es_cliente,
                    codtypeservice,
                    codincmotive,
                    codcase,
                    codresponsible,
                    codstatus,
                    codtypeatention,
                    codchannel,
                    channel,
                    severidad,
                    codsev,
                    flagfounded,
                    cod_grouptype,
                    grouptype,
                    gen_userid, -- Generacion
                    gen_receiverdepartment,
                    gen_deliverdepartment,
                    gen_deliveruser,
                    fecha_generacion,
                    mes_generacion,
                    clo_codsequence, -- Solucion
                    clo_userid,
                    clo_receiverdepartment,
                    clo_deliverdepartment,
                    clo_deliveruser,
                    fecha_cierre,
                    mes_cierre,
                    fecha_solucion,
                    tiempo_solucion, -- tiempo solucion
                    num_clientes,    -- Cantidad de clientes
                    num_servicios,
                    codsolot,         -- Incidencia asociado a solot
                    codot,
                    areaope,
                    duracion_interrup,
                    codcli,          -- datos cliente
                    cliente,
                    segmento,
                    codsegmark,
                    sector,
                    tipper,
                    nro_servicio,
                    producto,
                    codCategory,  -- categoria
                    categoria,
                    TIEMPO_CORTE,  -- 1er Escenario
                    TIEMPO_REPARACION,
                    FECINI_NOC
                   )
                 VALUES
                   (var_array(indx).codincidence,
                    var_array(indx).nticket,
                    var_array(indx).subtipo,
                    var_array(indx).tipo,
                    var_array(indx).tipo_reclamo,
                    var_array(indx).es_masivo,
                    var_array(indx).motivo,
                    var_array(indx).servicio,
                    var_array(indx).responsable,
                    var_array(indx).tipo_caso,
                    var_array(indx).tipo_atencion,
                    var_array(indx).f_generacion,
                    var_array(indx).registrado_por,
                    var_array(indx).estado,
                    var_array(indx).codinctype,
                    var_array(indx).codsubtype,
                    var_array(indx).es_cliente,
                    var_array(indx).codtypeservice,
                    var_array(indx).codincmotive,
                    var_array(indx).codcase,
                    var_array(indx).codresponsible,
                    var_array(indx).codstatus,
                    var_array(indx).codtypeatention,
                    var_array(indx).codchannel,
                    var_array(indx).description,
                    var_array(indx).dessev,
                    var_array(indx).codsev,
                    var_array(indx).flagfounded,
                    var_array(indx).codgrouptype,
                    var_array(indx).desc_grouptype,
                    lv_userid,
                    ln_receiverdepartment,
                    ln_deliverdepartment,
                    lv_deliveruser,
                    ld_sequencedate,
                    lv_mesgeneracion,
                    ln_clo_codsequence,
                    lv_clo_userid,
                    ln_clo_receiverdepartment,
                    lv_clo_deliverdepartment,
                    lv_clo_deliveruser,
                    ld_fecha_cierre,
                    lv_mes_cierre,
                    ld_fecha_solucion,
                    ln_tiempo_solucion,  -- tiempo solucion
                    ln_num_clientes,     -- cantidad clientes
                    ln_num_servicios,
                    ln_codsolot,         -- incidencia asociado a solot
                    ln_codot,
                    lv_areaope,
                    ln_duracion_interrup,
                    lc_codcli,           -- Datos cliente
                    lv_cliente,
                    lv_segmento,
                    ln_codsegmark,
                    lv_sector,
                    lv_tipper,
                    lv_nro_servicio,     -- Servicio
                    lv_producto,          -- producto
                    ln_codCategoria,     -- categoria
                    lv_categoria,
                    ln_tiempo_corte,     -- 1er Escenario
                    ln_tiempo_reparacion,
                    ld_sequencedate_tmp11
                   );

              ln_cntok := ln_cntok + 1;

              EXCEPTION
                WHEN le_pq THEN
                  ln_cnterr := ln_cnterr + 1;

                WHEN OTHERS THEN
                  ln_cnterr := ln_cnterr + 1;

              END;
            END;
          END LOOP;
          EXIT WHEN var_array.COUNT = 0;
        END LOOP;
      CLOSE c_incidence;

      COMMIT;

      P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin cursor c_incidence, proceso:  '||an_idproceso||' tarea:  '||an_idtarea||'  Registros Procesados: ' || ln_cntrec ||'  Registros sin errores:  '||ln_cntok||'  Registros con errores:  '||ln_cnterr);


    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;

    END;

    PROCEDURE p_ThreadRun(av_username  VARCHAR2,
                        av_password  VARCHAR2,
                        av_url       VARCHAR2,
                        av_nsp       VARCHAR2,
                        an_idproceso NUMBER,
                        an_hilos     IN NUMBER) AS

      LANGUAGE JAVA NAME 'com.creo.operacion.ProcesaGrupoHilo.procesa(java.lang.String,java.lang.String,java.lang.String,java.lang.String, long, int)';

    FUNCTION f_getConstante(av_constante operacion.constante.constante%TYPE) RETURN VARCHAR2 IS
      lv_valor VARCHAR2(100);

      BEGIN

        IF av_constante = 'OPTHFCPWD' THEN
           SELECT utl_raw.cast_to_varchar2(valor)
                  INTO lv_valor
                  FROM constante
                  WHERE constante = av_constante;
        ELSE
          SELECT valor
            INTO lv_valor
            FROM constante
           WHERE constante = av_constante;
        END IF;

        RETURN lv_valor;

      END;

    PROCEDURE P_GRABA_LOG_CARGA_INCIDENCE(nIdTipoLog number, vDescripcion varchar2) IS

      nIdLog number;
      pragma autonomous_transaction;

      BEGIN
        SELECT OPERACION.SQ_TAB_OPE_LOG_CARGA_INCIDENCE.NEXTVAL
        INTO nIdLog
        FROM DUAL;

        INSERT INTO OPERACION.OPE_LOG_CARGA_INCIDENCE
          (IDLOG, IDTIPOLOG, DESCRIPCION)
        VALUES
          (nIdLog, nIdTipoLog, vDescripcion);

        COMMIT;

      EXCEPTION
        WHEN OTHERS THEN
          rollback;
      END;


      PROCEDURE p_genera_imagen_mensual_bl(an_idproceso NUMBER, an_idtarea NUMBER) IS

        ln_cntrec   NUMBER := 0;
        ln_cnterr   NUMBER := 0;
        ln_cntok    NUMBEr := 0;

        limite_in PLS_INTEGER DEFAULT 1000;
        -- Cursor que obtiene datos para cargalos en la tabla resincidence
        CURSOR c_atcresincidence_t is
          SELECT
                res.codincidence,
                res.nticket,
                res.tipo,
                res.subtipo,
                res.tipo_reclamo,
                res.es_masivo,
                res.motivo,
                res.servicio,
                res.responsable,
                res.tipo_caso,
                res.tipo_atencion,
                res.estado,
                res.es_cliente,
                res.codcli,          -- datos cliente
                res.cliente,
                res.num_clientes,    -- cantidad de clientes
                res.num_servicios,
                res.categoria,
                res.segmento,
                res.fecha_registro,
                res.registrado_por,
                res.fecha_generacion,
                res.fecha_cierre,
                res.mes_generacion,
                res.mes_cierre,
                res.codinctype,
                res.codsubtype,
                res.codtypeservice,
                res.codincmotive,
                res.codcase,
                res.codresponsible,
                res.codstatus,
                res.codtypeatention,
                res.codcategory,  -- categoria
                res.gen_userid, -- generacion
                res.gen_receiverdepartment,
                res.gen_deliverdepartment,
                res.gen_deliveruser,
                res.clo_codsequence, -- solucion
                res.clo_userid,
                res.clo_receiverdepartment,
                res.clo_deliverdepartment,
                res.clo_deliveruser,
                res.usumod,
                res.fecmod,
                res.codsegmark,
                res.nro_servicio,
                res.producto,
                res.codsolot,         -- incidencia asociado a solot
                res.codot,
                res.areaope,
                res.duracion_interrup,
                res.fecini_noc,
                res.fecfin_noc,
                res.sector,
                res.codchannel,
                res.channel,
                res.tipper,
                res.severidad,
                res.fecha_solucion,
                res.codsev,
                res.tiempo_solucion, -- tiempo solucion
                res.tiempo_corte,  -- 1er escenario
                res.tiempo_reparacion,
                res.flagfounded,
                res.cod_grouptype,
                res.grouptype
          FROM atccorp.atcresincidence_t res
          WHERE res.codincidence not in (select codincidence from resincidence)
        -- where not exists (select 1 from resincidence ri where ri.codincidence = res.codincidence )
            AND EXISTS (SELECT 1 FROM operacion.thincidence t
                        WHERE t.idproceso = an_idproceso
                          AND t.id_tarea = an_idtarea
                          AND t.codincidence = res.codincidence);

          TYPE reg_atcresincidence_t IS TABLE OF c_atcresincidence_t%rowtype INDEX BY PLS_INTEGER;
          l_instancia_7 reg_atcresincidence_t;

          BEGIN
            /*insert into resincidence select * from atccorp.atcresincidence_t
            where codincidence not in (select codincidence from resincidence);
            commit;*/

            P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Inicio Insert table resincidence por cursor c_atcresincidence_t, proceso:  '||an_idproceso||' tarea:  '||an_idtarea);

            OPEN c_atcresincidence_t;
              LOOP
                FETCH c_atcresincidence_t BULK COLLECT
                  INTO l_instancia_7 LIMIT limite_in;
                FOR indx IN 1 .. l_instancia_7.count LOOP
                  BEGIN

                    ln_cntrec := ln_cntrec + 1;

                      INSERT INTO ATCCORP.resincidence
                        (
                          codincidence,
                          nticket,
                          tipo,
                          subtipo,
                          tipo_reclamo,
                          es_masivo,
                          motivo,
                          servicio,
                          responsable,
                          tipo_caso,
                          tipo_atencion,
                          estado,
                          es_cliente,
                          codcli,          -- datos cliente
                          cliente,
                          num_clientes,    -- cantidad de clientes
                          num_servicios,
                          categoria,
                          segmento,
                          fecha_registro,
                          registrado_por,
                          fecha_generacion,
                          fecha_cierre,
                          mes_generacion,
                          mes_cierre,
                          codinctype,
                          codsubtype,
                          codtypeservice,
                          codincmotive,
                          codcase,
                          codresponsible,
                          codstatus,
                          codtypeatention,
                          codcategory,  -- categoria
                          gen_userid, -- generacion
                          gen_receiverdepartment,
                          gen_deliverdepartment,
                          gen_deliveruser,
                          clo_codsequence, -- solucion
                          clo_userid,
                          clo_receiverdepartment,
                          clo_deliverdepartment,
                          clo_deliveruser,
                          usumod,
                          fecmod,
                          codsegmark,
                          nro_servicio,
                          producto,
                          codsolot,         -- incidencia asociado a solot
                          codot,
                          areaope,
                          duracion_interrup,
                          fecini_noc,
                          fecfin_noc,
                          sector,
                          codchannel,
                          channel,
                          tipper,
                          severidad,
                          fecha_solucion,
                          codsev,
                          tiempo_solucion, -- tiempo solucion
                          tiempo_corte,  -- 1er escenario
                          tiempo_reparacion,
                          flagfounded,
                          cod_grouptype,
                          grouptype
                          )
                      VALUES
                        (
                          l_instancia_7(indx).codincidence,
                          l_instancia_7(indx).nticket,
                          l_instancia_7(indx).tipo,
                          l_instancia_7(indx).subtipo,
                          l_instancia_7(indx).tipo_reclamo,
                          l_instancia_7(indx).es_masivo,
                          l_instancia_7(indx).motivo,
                          l_instancia_7(indx).servicio,
                          l_instancia_7(indx).responsable,
                          l_instancia_7(indx).tipo_caso,
                          l_instancia_7(indx).tipo_atencion,
                          l_instancia_7(indx).estado,
                          l_instancia_7(indx).es_cliente,
                          l_instancia_7(indx).codcli,          -- datos cliente
                          l_instancia_7(indx).cliente,
                          l_instancia_7(indx).num_clientes,    -- cantidad de clientes
                          l_instancia_7(indx).num_servicios,
                          l_instancia_7(indx).categoria,
                          l_instancia_7(indx).segmento,
                          l_instancia_7(indx).fecha_registro,
                          l_instancia_7(indx).registrado_por,
                          l_instancia_7(indx).fecha_generacion,
                          l_instancia_7(indx).fecha_cierre,
                          l_instancia_7(indx).mes_generacion,
                          l_instancia_7(indx).mes_cierre,
                          l_instancia_7(indx).codinctype,
                          l_instancia_7(indx).codsubtype,
                          l_instancia_7(indx).codtypeservice,
                          l_instancia_7(indx).codincmotive,
                          l_instancia_7(indx).codcase,
                          l_instancia_7(indx).codresponsible,
                          l_instancia_7(indx).codstatus,
                          l_instancia_7(indx).codtypeatention,
                          l_instancia_7(indx).codcategory,  -- categoria
                          l_instancia_7(indx).gen_userid, -- generacion
                          l_instancia_7(indx).gen_receiverdepartment,
                          l_instancia_7(indx).gen_deliverdepartment,
                          l_instancia_7(indx).gen_deliveruser,
                          l_instancia_7(indx).clo_codsequence, -- solucion
                          l_instancia_7(indx).clo_userid,
                          l_instancia_7(indx).clo_receiverdepartment,
                          l_instancia_7(indx).clo_deliverdepartment,
                          l_instancia_7(indx).clo_deliveruser,
                          l_instancia_7(indx).usumod,
                          l_instancia_7(indx).fecmod,
                          l_instancia_7(indx).codsegmark,
                          l_instancia_7(indx).nro_servicio,
                          l_instancia_7(indx).producto,
                          l_instancia_7(indx).codsolot,         -- incidencia asociado a solot
                          l_instancia_7(indx).codot,
                          l_instancia_7(indx).areaope,
                          l_instancia_7(indx).duracion_interrup,
                          l_instancia_7(indx).fecini_noc,
                          l_instancia_7(indx).fecfin_noc,
                          l_instancia_7(indx).sector,
                          l_instancia_7(indx).codchannel,
                          l_instancia_7(indx).channel,
                          l_instancia_7(indx).tipper,
                          l_instancia_7(indx).severidad,
                          l_instancia_7(indx).fecha_solucion,
                          l_instancia_7(indx).codsev,
                          l_instancia_7(indx).tiempo_solucion, -- tiempo solucion
                          l_instancia_7(indx).tiempo_corte,  -- 1er escenario
                          l_instancia_7(indx).tiempo_reparacion,
                          l_instancia_7(indx).flagfounded,
                          l_instancia_7(indx).cod_grouptype,
                          l_instancia_7(indx).grouptype
                      );
                     -- commit;
                      ln_cntok := ln_cntok + 1;
                  EXCEPTION
                    WHEN OTHERS THEN
                      ln_cnterr := ln_cnterr + 1;
                    --rollback;
                  END;
                END LOOP;
              EXIT WHEN l_instancia_7.COUNT = 0;
            END LOOP;
          CLOSE c_atcresincidence_t;
          COMMIT;

          P_GRABA_LOG_CARGA_INCIDENCE(1000, 'Fin Insert table resincidence por cursor c_atcresincidence_t, proceso:  '||an_idproceso||' tarea:  '||an_idtarea||'  Registros insertados: ' || ln_cntrec ||'  Registros sin errores:  '||ln_cntok||'  Registros con errores:  '||ln_cnterr);

      EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
      END;

 END;
/