CREATE OR REPLACE PACKAGE BODY OPERACION.Pq_Agenda IS


 FUNCTION f_valida_agenda(
                           ln_idzona      CHAR,
                           P_FECHA        VARCHAR2,
                           P_HORA         VARCHAR2,
               P_BLOQUE      NUMBER) RETURN VARCHAR2
  IS
     ln_asigmax    NUMBER;
     ln_diferencia NUMBER;
     ln_dispcontrata NUMBER;
     ln_asignaciones NUMBER;
     ln_dispxbloque NUMBER;
  BEGIN


      SELECT COUNT(*) INTO ln_dispcontrata FROM DISPXCONTRATA
      WHERE TRIM(IDZONA)= trim(ln_idzona)
      AND asigmax > 0;


      IF ln_dispcontrata=0 THEN
          RETURN 'La zona no ha sido asignada a ninguna contrata';
      END IF;

     /* INICIO SEGUNDA VALIDACIÓN*/

    SELECT SUM(asigmax)
      INTO ln_asigmax
      FROM DISPXCONTRATA
      WHERE TRIM(idzona) = trim(ln_idzona)
      AND asigmax > 0 ;

      IF ln_asigmax = 0 THEN -- MI 20070508 Valida Horas disponibles en la zona
         RETURN 'Advertencia, No se tienen cuadrillas disponibles en la zona, no se puede programar';
      END IF;

    /*INICIO TERCERA VALIDACIÓN*/
    SELECT SUM(cant_inst)
    INTO ln_asignaciones
    FROM MOV_AGENDA_DET
    WHERE TRIM(idzona)=trim(ln_idzona)
    AND FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
    AND idbloque=p_bloque;

    IF ln_asignaciones >= ln_asigmax THEN
          RETURN 'Se ha llegado al maximo de asignaciones para la contrata en esta zona.';
      END IF;

    /*INICIO CUARTA VALIDACIÓN*/
      SELECT COUNT(*)
      INTO ln_dispxbloque
      FROM ZONABLOQUEHORARIO
      WHERE TRIM(coddep)=trim(ln_idzona)
      AND idbloque=p_bloque;

      IF ln_dispxbloque=0 THEN
         RETURN 'No existe contratista para éste bloque horario';
      END IF;

     /*INICIO CUARTA VALIDACIÓN
     SELECT (TO_DATE(p_fecha || ' ' || +P_hora, 'dd/mm/yyyy hh24:mi')-SYSDATE) * 24
       INTO ln_diferencia
       FROM dual;

       IF ln_diferencia < 2 THEN
         RETURN 'No es posible agendar con menos de 2 horas de anticipacion.';
       END IF;*/

     RETURN 'OK';

  END;



  FUNCTION F_OBTIENE_CONTRATA(P_BLOQUE NUMBER,
                       P_CODUBI CHAR,
                  P_FECHA   VARCHAR2) RETURN NUMBER
  IS

    ln_cantinst         NUMBER;
    LN_CANTIDAD       NUMBER;
    LN_CANT_MAX_INST    NUMBER;
    LN_FLG_SALTO      NUMBER;


   CURSOR C_CONTRATA IS
       /*OBTENGO TODAS LAS CONTRATAS QUE ATIENDAN UNA ZONA EN ESPECIAL, DE ACUERDO A LA FECHA
     Y EL BLOQUE HORARIO*/
     SELECT D.CODCON, C.NOMBRE, C.RANKING FROM
     DISPXCONTRATA D, CONTRATA C
     WHERE D.CODCON=C.CODCON
     AND IDZONA IN (SELECT Z.CODDEP FROM ZONABLOQUEHORARIO Z
                WHERE TRIM(Z.CODDEP)=trim(P_CODUBI))
     ORDER BY C.RANKING, C.CODCON;

   BEGIN

     SELECT COUNT(*)
     INTO LN_CANTINST
     FROM MOV_AGENDA_DET
     WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy');

     /*RECORREMOS EL CURSOR*/
     FOR CUR_CONTRATA IN C_CONTRATA LOOP
         /*SI NO HAY NINGUNA CONTRATA PROGRAMADA PARA ESA FECHA*/
        IF LN_CANTINST=0 THEN
         RETURN CUR_CONTRATA.CODCON;
       ELSE

          BEGIN
            /*VERIFICAR SI EXISTE DATOS PARA ESA FECHA CON ESE CONTRATISTA*/
           SELECT DISTINCT A.FLG_SALTO
           INTO LN_FLG_SALTO
           FROM MOV_AGENDA_DET A
           WHERE A.FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
           AND A.CODCON=CUR_CONTRATA.CODCON;

               EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
                RETURN CUR_CONTRATA.CODCON;
           END;

          IF LN_FLG_SALTO=0 THEN
                  BEGIN
                /*VERIFICO SI HAY DATOS PARA ESE CONTRATISTA, ZONA,BLOQUE Y FECHA*/
                         SELECT CANT_INST, CANT_MAX_INST
               INTO LN_CANTIDAD, LN_CANT_MAX_INST
               FROM MOV_AGENDA_DET
               WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
               AND TRIM(IDZONA)=trim(P_CODUBI)
               AND IDBLOQUE=P_BLOQUE
               AND CODCON=CUR_CONTRATA.CODCON;
            EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
                      RETURN CUR_CONTRATA.CODCON;
                END;

             /*SI YA LLEGO AL MAXIMO DE LAS INSTALACIONES RECORRE EL SIGUIENTE REGISTRO*/
             IF LN_CANTIDAD<>LN_CANT_MAX_INST THEN
                         RETURN CUR_CONTRATA.CODCON;
             END IF;
                END IF;


--            BEGIN
--               /*VERIFICO SI HAY DATOS PARA ESE CONTRATISTA, ZONA,BLOQUE Y FECHA*/
--                        SELECT CANT_INST, CANT_MAX_INST
--              INTO LN_CANTIDAD, LN_CANT_MAX_INST
--              FROM MOV_AGENDA_DET
--              WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
--              AND IDZONA=P_CODUBI
--              AND IDBLOQUE=P_BLOQUE
--              AND CODCON=CUR_CONTRATA.CODCON;
--           EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
--                     RETURN CUR_CONTRATA.CODCON;
--               END;
--
--            /*SI YA LLEGO AL MAXIMO DE LAS INSTALACIONES RECORRE EL SIGUIENTE REGISTRO*/
--            IF LN_CANTIDAD<>LN_CANT_MAX_INST THEN
--                  IF LN_FLG_SALTO=0 THEN
--                        RETURN CUR_CONTRATA.CODCON;
--                  END IF;
--            END IF;

       END IF;
     END LOOP;

     RETURN NULL;

  END;




  PROCEDURE P_AGENDA(p_DIRSUC       VARCHAR2,
                     p_codcli       VARCHAR2,
                     P_PROYECTO     VARCHAR2,
                     p_fecha        VARCHAR2,
                     p_hora         VARCHAR2,
                     P_CODUBI       CHAR,
                     P_CODSOLOT     NUMBER,
           P_BLOQUE    NUMBER,
           P_OBSERVACION  VARCHAR2,
           P_REFERENCIA   VARCHAR2)
  IS
    ln_contrata NUMBER;
  LN_CANTIDAD NUMBER;
  LN_IDWF   NUMBER;
  LN_IDTAREAWF NUMBER;
v_mensaje  varchar2(3000);
v_error   number;
    BEGIN
begin
    --UPDATE SOLOT SET CODSOLOT=P_CODSOLOT WHERE CODSOLOT=P_CODSOLOT;
  SELECT F_OBTIENE_CONTRATA(P_BLOQUE,P_CODUBI,P_FECHA)
    INTO ln_contrata
    FROM dual;
     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
           ln_contrata:=null;
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;

  <<CONTINUAR>>
  IF LN_CONTRATA IS NOT NULL THEN

  begin
      /*INSERTO REGISTROS A LA TABLA AGENDA_TAREAS*/
      INSERT INTO AGENDA_TAREAS
      (CODCON,CODCLI,SOLOT,DIRECCION,CODUSU,FECUSU,STATUS,
         PROYECTO,IDZONA,FECHA_INSTALACION, OBSERVACION, REFERENCIA,estage) --TPI Coaxial--<3.0>
      VALUES
      (LN_CONTRATA, P_CODCLI, P_CODSOLOT, P_DIRSUC, USER, SYSDATE, 'AGENDADA',
       P_PROYECTO, P_CODUBI, TO_DATE(P_FECHA || ' '|| P_HORA,'dd/mm/yyyy hh24:mi'),
       P_OBSERVACION, P_REFERENCIA,1);--TPI Coaxial--<3.0>

       UPDATE SOLOTPTO_ID
       SET FECPROG=  TO_DATE(P_FECHA || ' '|| P_HORA,'dd/mm/yyyy hh24:mi')
       WHERE CODSOLOT=P_CODSOLOT;


       /*INSERTO O ACTUALIZO REGISTROS EN LA TABLA MOV_AGENDA_DET*/
       SELECT COUNT(*)
       INTO LN_CANTIDAD
       FROM MOV_AGENDA_DET
       WHERE CODCON=LN_CONTRATA
       AND FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
       AND TRIM(IDZONA)=trim(P_CODUBI)
       AND IDBLOQUE=P_BLOQUE;
     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
         --              RAISE_APPLICATION_ERROR(-20600,'Faltan datos de la contrata');
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;

       IF LN_CANTIDAD=0 THEN
          /*INSERTO MOV_AGENDA_DET*/
    BEGIN
          INSERT INTO MOV_AGENDA_DET
          (CODCON, FECHA, IDBLOQUE, CANT_INST, IDZONA, SALTO, CANT_MAX_INST)
          VALUES
          (LN_CONTRATA, TO_DATE(P_FECHA,'dd/mm/yyyy'), P_BLOQUE, 1, P_CODUBI,
          (SELECT CARGA_TRABAJO FROM CONTRATA WHERE CONTRATA.CODCON=LN_CONTRATA),
          (SELECT D.ASIGMAX FROM DISPXCONTRATA D WHERE D.CODCON=LN_CONTRATA AND
          trim(D.IDZONA)=trim(P_CODUBI)));
     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
                --       RAISE_APPLICATION_ERROR(-20600,'Error al insertar en MOV_AGENDA_DET');
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;

       ELSE
       BEGIN
         /*ACTUALIZO MOV_AGENDA_DET*/
         UPDATE MOV_AGENDA_DET
         SET CANT_INST=CANT_INST+1
         WHERE CODCON=LN_CONTRATA
         AND FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
         AND IDBLOQUE=P_BLOQUE
         AND trim(IDZONA)=trim(P_CODUBI);
     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
                --       RAISE_APPLICATION_ERROR(-20600,'Error al actualizar en MOV_AGENDA_DET');
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;

       END IF;

       P_ACTUALIZA_FLG_SALTO(LN_CONTRATA,P_FECHA);


       /*CIERRO EL ESTADO DE LA TAREA*/
       -- Se incluye la condicion valido=1 para tomar solo el WF activo 12/03/2008  GORMEÑO/MBALCAZAR
       BEGIN
           SELECT IDWF INTO LN_IDWF FROM WF WHERE VALIDO=1 AND CODSOLOT=P_CODSOLOT;
       EXCEPTION
       WHEN OTHERS THEN
         LN_IDWF:=NULL;
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
         END;

         BEGIN
       SELECT IDTAREAWF
       INTO LN_IDTAREAWF
       FROM TAREAWF
       WHERE IDWF=LN_IDWF
       AND TAREADEF IN (SELECT VALOR FROM CONSTANTE
       WHERE UPPER(CONSTANTE) LIKE 'AGENDAMIENTO%');
       EXCEPTION
       WHEN OTHERS THEN
         LN_IDTAREAWF:=NULL;
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
         END;
        /*UPDATE TAREAWF
       SET ESTTAREA=4
       WHERE IDWF=LN_IDWF
       AND TAREADEF IN (SELECT VALOR FROM CONSTANTE
       WHERE UPPER(CONSTANTE) LIKE 'AGENDAMIENTO%');*/

       /*CERRAMOS LA TAREA DE AGENDAMIENTO*/
        if LN_IDTAREAWF is not null then --<3.0>
           PQ_WF.P_CHG_STATUS_TAREAWF(LN_IDTAREAWF,4,4,NULL,SYSDATE,SYSDATE);
        end if; --<3.0>
        COMMIT;
       ELSE

       begin
             --RAISE_APPLICATION_ERROR(-20600,'No se obtuvo contratista');
           SELECT F_OBTIENE_CONTRATA_NULL(P_BLOQUE,P_CODUBI,P_FECHA)
           INTO ln_contrata
           FROM dual;
             EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
                 --                       RAISE_APPLICATION_ERROR(-20600,'Error al obtener la contrata');
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;

           GOTO CONTINUAR;
     END IF;


  END P_AGENDA;

  PROCEDURE P_AGENDA_TAREAS(P_PROYECTO     VARCHAR2,
                            p_fecha        VARCHAR2,
                            p_hora         VARCHAR2,
                            P_CODSOLOT     NUMBER,
              P_OBSERVACION  VARCHAR2,
              P_REFERENCIA   VARCHAR2)
   IS

  lv_nomcli   VARCHAR2(200);
--    lv_DIRSUC   VARCHAR2(120);
lv_DIRSUC   VARCHAR2(480);
    lv_NOMPVC   VARCHAR2(40);
    lv_codcli   VARCHAR2(8);
    lv_codpvc   VARCHAR2(3);
    lv_codsuc   VARCHAR2(10);
    lv_errorvalida VARCHAR2(4000);
  lv_coddep   CHAR(3);
  lv_nomdep   VARCHAR2(40);
  ln_idbloque NUMBER;
  LN_IDBLOQUE1 NUMBER;
  LN_IDBLOQUE2 NUMBER;
  LN_IDBLOQUE3 NUMBER;
  LN_IDBLOQUE4 NUMBER;
  LV_HORA1   VARCHAR2(10);
  LV_HORA2   VARCHAR2(10);
  LV_HORA3   VARCHAR2(10);
    LV_HORA4   VARCHAR2(10);
v_mensaje  varchar2(3000);
v_error   number;

    BEGIN

v_error:=0;

      BEGIN
           SELECT
               c.nomcli,
               SC.DIRSUC,
               u.NOMPVC,
               c.codcli,
               u.codpvc,
               sc.codsuc codsuc,
               u.CODEST,
               u.NOMEST
         INTO
               lv_nomcli,
               lv_DIRSUC,
               lv_NOMPVC,
               lv_codcli,
               lv_codpvc,
               lv_codsuc,
               lv_coddep,
               lv_nomdep
          FROM vtatabcli    c,
               vtasuccli    SC,
               v_ubicaciones u,
               SOLOT S,
               SOLOTPTO SP,
               INSSRV
         WHERE S.codcli=c.codcli
               AND S.CODSOLOT=SP.CODSOLOT
               AND SP.CODINSSRV=INSSRV.CODINSSRV
               AND INSSRV.CODSUC=SC.CODSUC
               AND c.codcli=SC.CODCLI
               AND SC.UBISUC=U.codubi
               AND SP.CODSOLOT=P_CODSOLOT
               AND u.CODPAI='51'
               AND ROWNUM = 1;

     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;
       /*HALLAR CUÁL ES EL BLOQUE AL QUE PERTENECE LA HORA*/
       BEGIN
     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE1,LV_HORA1
     FROM BLOQUEHORARIO
     WHERE BLOQUE=1;

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE2,LV_HORA2
     FROM BLOQUEHORARIO
     WHERE BLOQUE=2;

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE3,LV_HORA3
     FROM BLOQUEHORARIO
     WHERE BLOQUE=3;

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE4,LV_HORA4
     FROM BLOQUEHORARIO
     WHERE BLOQUE=4;

     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
     --       RAISE_APPLICATION_ERROR(-20600,'Faltan datos BLOQUEO');
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;
     IF (P_HORA>=LV_HORA1) AND (P_HORA<LV_HORA2) THEN
       LN_IDBLOQUE:=LN_IDBLOQUE1;
     ELSIF (P_HORA>=LV_HORA2) AND (P_HORA<LV_HORA3) THEN
       LN_IDBLOQUE:=LN_IDBLOQUE2;
     ELSIF (P_HORA>=LV_HORA3) AND (P_HORA<LV_HORA4) THEN
       LN_IDBLOQUE:=LN_IDBLOQUE3;
     ELSE
       LN_IDBLOQUE:=LN_IDBLOQUE4;
     END IF;
     begin

       /*INICIO DE LA VALIDACIÓN*/
     SELECT f_valida_agenda(lv_coddep,P_FECHA, P_HORA, ln_idbloque)
       INTO lv_errorvalida
       FROM dual;
     EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
           lv_errorvalida:=null;
        v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END;
       IF lv_errorvalida <> 'OK' THEN
          RAISE_APPLICATION_ERROR(-20500, lv_errorvalida);
       v_mensaje   := SQLERRM;
       v_error     := SQLCODE;
       END IF;

     P_AGENDA(lv_DIRSUC,lv_codcli,
             P_PROYECTO, p_fecha, p_hora,lv_coddep,
         P_CODSOLOT,LN_IDBLOQUE,P_OBSERVACION,P_REFERENCIA);

  END P_AGENDA_TAREAS;


  PROCEDURE P_ACTUALIZA_FLG_SALTO(P_CONTRATISTA  NUMBER,
                     P_FECHA VARCHAR2)
  IS
    LN_SALTO NUMBER;
  LN_INSTALACIONES NUMBER;
  LN_SALTAR NUMBER;
  LN_INSTALACIONES_MAX NUMBER;
v_mensaje  varchar2(3000);
v_error   number;
    BEGIN

  LN_SALTO := 0;
    LN_INSTALACIONES :=0;
    LN_SALTAR:=0;
    LN_INSTALACIONES_MAX:=0;

    /*RECOJO EL SALTO QUE TIENE EL CONTRATISTA*/
    SELECT CONTRATA.CARGA_TRABAJO
    INTO LN_SALTO
    FROM CONTRATA
    WHERE CONTRATA.CODCON=P_CONTRATISTA;

    BEGIN
      /*RECOJO LA CANTIDAD DE INSTALACIONES*/
      SELECT NVL(SUM(CANT_INST),0)
      INTO LN_INSTALACIONES
      FROM MOV_AGENDA_DET
      WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
      AND CODCON=P_CONTRATISTA;
    EXCEPTION
    WHEN OTHERS THEN
       LN_INSTALACIONES := 0;
    END;

    BEGIN
      /*RECOJO LA SUMA DE LA CANTIDAD MAXIMA A INSTALAR*/
      /*SELECT NVL(SUM(CANT_MAX_INST),0)
      INTO LN_INSTALACIONES_MAX
      FROM MOV_AGENDA_DET
      WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
      AND CODCON=P_CONTRATISTA;*/
      SELECT SUM(ASIGMAX)
      INTO LN_INSTALACIONES_MAX
      FROM DISPXCONTRATA DC, ZONABLOQUEHORARIO ZB
      WHERE  TRIM(DC.IDZONA)=TRIM(ZB.CODDEP)
      AND CODCON=P_CONTRATISTA;
    EXCEPTION
    WHEN OTHERS THEN
       LN_INSTALACIONES_MAX := 0;
    END;

    BEGIN
      /*RECOJO EL RESIDUO DE LAS INSTALACIONES CON EL SALTO*/
      SELECT MOD(LN_INSTALACIONES, LN_SALTO)
      INTO LN_SALTAR
      FROM DUAL;
    EXCEPTION
    WHEN OTHERS THEN
       LN_INSTALACIONES_MAX := 0;
    END;

    /*SI YA SE LLEGO AL NUMERO MAXIMO DE INSTALACIONES PARA ESA CONTRATA, ENTONCES ACTUALIZA A 2 EL FLG_SALTO*/
    IF LN_INSTALACIONES=LN_INSTALACIONES_MAX THEN
      UPDATE MOV_AGENDA_DET
      SET FLG_SALTO=2
      WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
      AND CODCON=P_CONTRATISTA;
    ELSE
    /*COMPLETO SU SALTO (O CARGA DE TRABAJO) DE INSTALACIONES*/
      IF LN_SALTAR=0 THEN
        UPDATE MOV_AGENDA_DET
        SET FLG_SALTO=1
        WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
        AND CODCON=P_CONTRATISTA;
      ELSE
        UPDATE MOV_AGENDA_DET
        SET FLG_SALTO=0
        WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
        AND CODCON=P_CONTRATISTA;
      END IF;
    END IF;


  END P_ACTUALIZA_FLG_SALTO;


    FUNCTION F_OBTIENE_CONTRATA_NULL(P_BLOQUE NUMBER,
                       P_CODUBI CHAR,
                  P_FECHA   VARCHAR2) RETURN NUMBER

    IS

    LN_CANTIDAD       NUMBER;
    LN_CANT_MAX_INST    NUMBER;



   CURSOR C_CONTRATA IS
       /*OBTENGO TODAS LAS CONTRATAS QUE ATIENDAN UNA ZONA EN ESPECIAL, DE ACUERDO A LA FECHA
     Y EL BLOQUE HORARIO*/
     SELECT D.CODCON, C.NOMBRE, C.RANKING FROM
     DISPXCONTRATA D, CONTRATA C
     WHERE D.CODCON=C.CODCON
     AND IDZONA IN (SELECT Z.CODDEP FROM ZONABLOQUEHORARIO Z
                WHERE TRIM(Z.CODDEP)=trim(P_CODUBI))
     ORDER BY C.RANKING, C.CODCON;

   BEGIN


     /*RECORREMOS EL CURSOR*/
     FOR CUR_CONTRATA IN C_CONTRATA LOOP
         /*SI NO HAY NINGUNA CONTRATA PROGRAMADA PARA ESA FECHA*/


           BEGIN
              /*VERIFICO SI HAY DATOS PARA ESE CONTRATISTA, ZONA,BLOQUE Y FECHA*/
                       SELECT CANT_INST, CANT_MAX_INST
             INTO LN_CANTIDAD, LN_CANT_MAX_INST
             FROM MOV_AGENDA_DET
             WHERE FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
             AND TRIM(IDZONA)=trim(P_CODUBI)
             AND IDBLOQUE=P_BLOQUE
             AND CODCON=CUR_CONTRATA.CODCON;
          EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
                    RETURN CUR_CONTRATA.CODCON;
              END;

           /*SI YA LLEGO AL MAXIMO DE LAS INSTALACIONES RECORRE EL SIGUIENTE REGISTRO*/
           IF LN_CANTIDAD<>LN_CANT_MAX_INST THEN
                 RETURN CUR_CONTRATA.CODCON;
           END IF;

     END LOOP;
  END;



PROCEDURE P_REAGENDA_TAREAS(P_PROYECTO     VARCHAR2,
                            p_fecha        VARCHAR2,
                            p_hora         VARCHAR2,
                            P_CODSOLOT     NUMBER,
              P_OBSERVACION  VARCHAR2,
              P_REFERENCIA   VARCHAR2)

  IS

    lv_errorvalida VARCHAR2(4000);
  lv_coddep   CHAR(3);
  ln_idbloque NUMBER;
  LN_IDBLOQUE1 NUMBER;
  LN_IDBLOQUE2 NUMBER;
  LN_IDBLOQUE3 NUMBER;
  LN_IDBLOQUE4 NUMBER;
  LV_HORA1   VARCHAR2(10);
  LV_HORA2   VARCHAR2(10);
  LV_HORA3   VARCHAR2(10);
  LV_HORA4   VARCHAR2(10);
  LV_FECINST   VARCHAR2(10);
  LV_HORAINST   VARCHAR2(10);
  LN_IDBLOQUEANT NUMBER;
  LN_CONTRATA   NUMBER;

    BEGIN


      BEGIN
       /*RECOGEMOS LA ZONA A INSTALAR,
       LA ANTIGUA FECHA DE INSTALACIÓN,
       LA ANTIGUA HORA DE INSTALACIÓN*/
        SELECT IDZONA,
           TO_CHAR(FECHA_INSTALACION,'dd/mm/yyyy'),
            TO_CHAR(FECHA_INSTALACION,'hh24:mi'),
         CODCON
      INTO lv_coddep,
           lv_fecinst,
         lv_horainst,
         LN_CONTRATA
      FROM AGENDA_TAREAS
      WHERE SOLOT=P_CODSOLOT;

       END;

     /*HALLAR CUÁL ES EL BLOQUE AL QUE PERTENECE LA HORA*/

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE1,LV_HORA1
     FROM BLOQUEHORARIO
     WHERE BLOQUE=1;

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE2,LV_HORA2
     FROM BLOQUEHORARIO
     WHERE BLOQUE=2;

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE3,LV_HORA3
     FROM BLOQUEHORARIO
     WHERE BLOQUE=3;

     SELECT BLOQUE, TO_CHAR(HORAINICIO,'hh24:mi')
     INTO LN_IDBLOQUE4,LV_HORA4
     FROM BLOQUEHORARIO
     WHERE BLOQUE=4;


     /*OBTENGO EL BLOQUE PARA EL AGENDAMIENTO ANTIGUO*/
     IF (lv_horainst>=LV_HORA1) AND (lv_horainst<LV_HORA2) THEN
       LN_IDBLOQUEANT:=LN_IDBLOQUE1;
     ELSIF (lv_horainst>=LV_HORA2) AND (lv_horainst<LV_HORA3) THEN
       LN_IDBLOQUEANT:=LN_IDBLOQUE2;
     ELSIF (lv_horainst>=LV_HORA3) AND (lv_horainst<LV_HORA4) THEN
       LN_IDBLOQUEANT:=LN_IDBLOQUE3;
     ELSE
        LN_IDBLOQUEANT:=LN_IDBLOQUE4;
     END IF;

     /*OBTENGO EL BLOQUE PARA EL AGENDAMIENTO ACTUAL*/
     IF (P_HORA>=LV_HORA1) AND (P_HORA<LV_HORA2) THEN
       LN_IDBLOQUE:=LN_IDBLOQUE1;
     ELSIF (P_HORA>=LV_HORA2) AND (P_HORA<LV_HORA3) THEN
       LN_IDBLOQUE:=LN_IDBLOQUE2;
     ELSIF (P_HORA>=LV_HORA3) AND (P_HORA<LV_HORA4) THEN
       LN_IDBLOQUE:=LN_IDBLOQUE3;
     ELSE
        LN_IDBLOQUE:=LN_IDBLOQUE4;
     END IF;

     /*SI MUEVO LA HORA PERTENECIENTE AL MISMO BLOQUE HORARIO DEL MISMO DIA, SOLO SE
     ACTUALIZA LA TABLA AGENDA_TAREAS*/
     IF (P_FECHA=LV_FECINST) AND (LN_IDBLOQUE=LN_IDBLOQUEANT) THEN
       UPDATE AGENDA_TAREAS
      SET FECHA_INSTALACION=TO_DATE(P_FECHA || ' '|| P_HORA,'dd/mm/yyyy hh24:mi'),
        OBSERVACION=P_OBSERVACION,
        REFERENCIA=P_REFERENCIA,
        STATUS='REAGENDADA'
      WHERE SOLOT=P_CODSOLOT;

      COMMIT;
     ELSE
        /*INICIO DE LA VALIDACIÓN*/
       SELECT f_valida_reagenda(lv_coddep,P_FECHA, P_HORA, ln_idbloque, LN_CONTRATA)
         INTO lv_errorvalida
         FROM dual;

         IF lv_errorvalida <> 'OK' THEN
            RAISE_APPLICATION_ERROR(-20500, lv_errorvalida);
         END IF;

       P_REAGENDA(lv_fecinst,lv_horainst, LN_IDBLOQUEANT,
               P_FECHA, P_HORA, LN_IDBLOQUE,
            LN_CONTRATA, P_CODSOLOT, P_OBSERVACION,
            P_REFERENCIA,LV_CODDEP);
     END IF;

  END P_REAGENDA_TAREAS;




  FUNCTION f_valida_reagenda(
                           ln_idzona      CHAR,
                           P_FECHA        VARCHAR2,
                           P_HORA         VARCHAR2,
               P_BLOQUE      NUMBER,
               P_CONTRATA    NUMBER) RETURN VARCHAR2
  IS
     ln_asigmax    NUMBER;
     ln_diferencia NUMBER;
     ln_dispcontrata NUMBER;
   ln_asignaciones NUMBER;
     ln_dispxbloque NUMBER;
   LN_CANT_INST NUMBER;
   LN_CANT_MAX_INST NUMBER;
  BEGIN


      SELECT COUNT(*) INTO ln_dispcontrata FROM DISPXCONTRATA
      WHERE TRIM(IDZONA)= trim(ln_idzona)
      AND asigmax > 0;


      IF ln_dispcontrata=0 THEN
          RETURN 'La zona no ha sido asignada a ninguna contrata';
      END IF;

     /* INICIO SEGUNDA VALIDACIÓN*/
    BEGIN
      SELECT CANT_INST, CANT_MAX_INST
      INTO LN_CANT_INST, LN_CANT_MAX_INST
      FROM MOV_AGENDA_DET
        WHERE CODCON=P_CONTRATA
      AND FECHA=TO_DATE(P_FECHA,'DD/MM/YYYY')
      AND IDBLOQUE=P_BLOQUE
      AND TRIM(IDZONA)=trim(LN_IDZONA);
    EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
      LN_CANT_INST:=0;
      LN_CANT_MAX_INST:=0;
    END;

    IF (LN_CANT_INST=LN_CANT_MAX_INST) AND (LN_CANT_INST<>0) AND (LN_CANT_MAX_INST<>0) THEN
       RETURN 'Se ha llegado al maximo de asignaciones para la contrata';
    END IF;


     /*INICIO TERCERA VALIDACION DE CONTRATA*/
    SELECT SUM(asigmax)
      INTO ln_asigmax
      FROM DISPXCONTRATA
      WHERE TRIM(idzona) = trim(ln_idzona)
      AND asigmax > 0 ;

      IF ln_asigmax = 0 THEN -- MI 20070508 Valida Horas disponibles en la zona
         RETURN 'Advertencia, No se tienen cuadrillas disponibles en la zona, no se puede programar';
      END IF;


    /*INICIO CUARTA VALIDACIÓN*/
    SELECT SUM(cant_inst)
    INTO ln_asignaciones
    FROM MOV_AGENDA_DET
    WHERE TRIM(idzona)=trim(ln_idzona)
    and FECHA=TO_DATE(P_FECHA,'dd/mm/yyyy')
    AND idbloque=p_bloque;

    IF ln_asignaciones >= ln_asigmax THEN
          RETURN 'Se ha llegado al maximo de asignaciones para la contrata en esta zona.';
      END IF;

    /*INICIO QUINTA VALIDACIÓN*/
      SELECT COUNT(*)
      INTO ln_dispxbloque
      FROM ZONABLOQUEHORARIO
      WHERE TRIM(coddep)=trim(ln_idzona)
      AND idbloque=p_bloque;

      IF ln_dispxbloque=0 THEN
         RETURN 'No existe contratista para éste bloque horario';
      END IF;

     /*INICIO SEXTA VALIDACIÓN
     SELECT (TO_DATE(p_fecha || ' ' || +P_hora, 'dd/mm/yyyy hh24:mi')-SYSDATE) * 24
       INTO ln_diferencia
       FROM dual;

       IF ln_diferencia < 2 THEN
         RETURN 'No es posible agendar con menos de 2 horas de anticipacion.';
       END IF;*/

     RETURN 'OK';

  END;

  PROCEDURE P_REAGENDA(P_FECHA1    VARCHAR2,
               P_HORA1     VARCHAR2,
             P_IDBLOQUE1 NUMBER,
             P_FECHA2    VARCHAR2,
               P_HORA2     VARCHAR2,
             P_IDBLOQUE2 NUMBER,
             P_CODCON    NUMBER,
             P_CODSOLOT  NUMBER,
             P_OBSERVACION VARCHAR2,
             P_REFERENCIA   VARCHAR2,
             P_ZONA CHAR)
   IS

   LN_CANT_INST_ANT NUMBER;
   LN_CANT_INST_NUE NUMBER;
   LN_TAREADEF NUMBER;
   LN_IDWF NUMBER;
   LN_ESTTAREA NUMBER;
   LN_IDTAREAWF NUMBER;

   BEGIN

       UPDATE AGENDA_TAREAS
     SET FECHA_INSTALACION=TO_DATE(P_FECHA2 || ' '|| P_HORA2,'dd/mm/yyyy hh24:mi'),
     OBSERVACION=P_OBSERVACION,
     REFERENCIA=P_REFERENCIA,
     STATUS='REAGENDADA'
     WHERE SOLOT=P_CODSOLOT;


     UPDATE SOLOTPTO_ID
       SET FECPROG=  TO_DATE(P_FECHA2 || ' '|| P_HORA2,'dd/mm/yyyy hh24:mi')
     WHERE CODSOLOT=P_CODSOLOT;

     /*CUANDO LAS FECHAS SON IGUALES, SOLO CAMBIA EL BLOQUE HORARIO*/
     IF (P_FECHA1=P_FECHA2) THEN

      SELECT CANT_INST
      INTO LN_CANT_INST_ANT
      FROM MOV_AGENDA_DET
      WHERE CODCON=P_CODCON
      AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
      AND IDBLOQUE=P_IDBLOQUE1
      AND TRIM(IDZONA)=trim(P_ZONA);

      BEGIN
        SELECT CANT_INST
        INTO LN_CANT_INST_NUE
        FROM MOV_AGENDA_DET
        WHERE CODCON=P_CODCON
        AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
        AND IDBLOQUE=P_IDBLOQUE2
        AND TRIM(IDZONA)=trim(P_ZONA);
      EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
          LN_CANT_INST_NUE:=0;
      END;

            /*HACER LOS CAMBIOS EN EL ANTIGUO REGISTRO*/
      IF LN_CANT_INST_ANT=1 THEN
         DELETE MOV_AGENDA_DET
         WHERE CODCON=P_CODCON
         AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
         AND IDBLOQUE=P_IDBLOQUE1
         AND TRIM(IDZONA)=trim(P_ZONA);
      ELSE
        UPDATE MOV_AGENDA_DET
        SET CANT_INST=CANT_INST-1
        WHERE CODCON=P_CODCON
          AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
          AND IDBLOQUE=P_IDBLOQUE1
          AND TRIM(IDZONA)=trim(P_ZONA);
      END IF;

      /*HACER LOS CAMBIOS EN EL NUEVO REGISTRO*/
      IF LN_CANT_INST_NUE=0 THEN
         INSERT INTO MOV_AGENDA_DET
         (CODCON, FECHA, IDBLOQUE, CANT_INST, IDZONA, SALTO, CANT_MAX_INST)
          VALUES
         (P_CODCON, TO_DATE(P_FECHA1,'dd/mm/yyyy'), P_IDBLOQUE2, 1, P_ZONA,
         (SELECT CARGA_TRABAJO FROM CONTRATA WHERE CONTRATA.CODCON=P_CODCON),
         (SELECT D.ASIGMAX FROM DISPXCONTRATA D WHERE D.CODCON=P_CODCON AND
          D.IDZONA=P_ZONA));
      ELSE
        UPDATE MOV_AGENDA_DET
        SET CANT_INST=CANT_INST+1
        WHERE CODCON=P_CODCON
          AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
          AND IDBLOQUE=P_IDBLOQUE2
          AND trim(IDZONA)=trim(P_ZONA);
      END IF;

      P_ACTUALIZA_FLG_SALTO(P_CODCON,P_FECHA1);

     ELSE
        /*CUANDO LAS FECHAS SON DISTINTAS*/
      SELECT CANT_INST
      INTO LN_CANT_INST_ANT
      FROM MOV_AGENDA_DET
      WHERE CODCON=P_CODCON
      AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
      AND IDBLOQUE=P_IDBLOQUE1
      AND TRIM(IDZONA)=trim(P_ZONA);

      IF LN_CANT_INST_ANT=1 THEN
         DELETE MOV_AGENDA_DET
         WHERE CODCON=P_CODCON
         AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
         AND IDBLOQUE=P_IDBLOQUE1
         AND TRIM(IDZONA)=trim(P_ZONA);
      ELSE
        UPDATE MOV_AGENDA_DET
        SET CANT_INST=CANT_INST-1
        WHERE CODCON=P_CODCON
          AND FECHA=TO_DATE(P_FECHA1,'DD/MM/YYYY')
          AND IDBLOQUE=P_IDBLOQUE1
          AND TRIM(IDZONA)=trim(P_ZONA);
      END IF;

      P_ACTUALIZA_FLG_SALTO(P_CODCON,P_FECHA1);


      BEGIN
        SELECT CANT_INST
        INTO LN_CANT_INST_NUE
        FROM MOV_AGENDA_DET
        WHERE CODCON=P_CODCON
        AND FECHA=TO_DATE(P_FECHA2,'DD/MM/YYYY')
        AND IDBLOQUE=P_IDBLOQUE2
        AND TRIM(IDZONA)=trim(P_ZONA);
      EXCEPTION WHEN NO_DATA_FOUND THEN --NO SE OBTIENE RESULTADOS CON EL SELECT
          LN_CANT_INST_NUE:=0;
      END;

            IF LN_CANT_INST_NUE=0 THEN
         INSERT INTO MOV_AGENDA_DET
         (CODCON, FECHA, IDBLOQUE, CANT_INST, IDZONA, SALTO, CANT_MAX_INST)
          VALUES
         (P_CODCON, TO_DATE(P_FECHA2,'dd/mm/yyyy'), P_IDBLOQUE2, 1, P_ZONA,
         (SELECT CARGA_TRABAJO FROM CONTRATA WHERE CONTRATA.CODCON=P_CODCON),
         (SELECT D.ASIGMAX FROM DISPXCONTRATA D WHERE D.CODCON=P_CODCON AND
          trim(D.IDZONA)=trim(P_ZONA)));
      ELSE
        UPDATE MOV_AGENDA_DET
        SET CANT_INST=CANT_INST+1
        WHERE CODCON=P_CODCON
          AND FECHA=TO_DATE(P_FECHA2,'DD/MM/YYYY')
          AND IDBLOQUE=P_IDBLOQUE2
          AND trim(IDZONA)=trim(P_ZONA);
      END IF;

      P_ACTUALIZA_FLG_SALTO(P_CODCON,P_FECHA2);

     END IF;

     COMMIT;
---Modificado por Mbalcazar el  24/07/2008: Inicio
       BEGIN
           SELECT IDWF INTO LN_IDWF FROM WF WHERE VALIDO=1 AND CODSOLOT=P_CODSOLOT;
       EXCEPTION
       WHEN OTHERS THEN
         LN_IDWF:=NULL;
       END;

       SELECT IDTAREAWF, ESTTAREA, TAREADEF
       INTO LN_IDTAREAWF, LN_ESTTAREA, LN_TAREADEF FROM TAREAWF
       WHERE IDWF=LN_IDWF AND TAREADEF=667;

       --\*Cerramos la tarea de Agendamiento*\
       IF LN_ESTTAREA=1 AND LN_TAREADEF=667 THEN
             PQ_WF.P_CHG_STATUS_TAREAWF(LN_IDTAREAWF,4,4,NULL,SYSDATE,SYSDATE);
       END IF;
---Modificado por Mbalcazar el  24/07/2008: Fin

   END P_REAGENDA;

PROCEDURE P_AGENDAMIENTO_MASIVO(l_codsolot    number,
l_punto solotpto.punto%type,
l_responsable  solotpto_id.responsable_pi%type,
l_codcon solotpto_id.codcon%type,
l_fecestprog solotpto_id.fecestprog%type,
l_observacion  solotpto_id.observacion%type,
o_mensaje        in out varchar2 ,
o_error          in out number
) IS
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/11/2008  Hector Huaman M. Agendamiento masivo
******************************************************************************/
l_numslc  solot.numslc%type;
l_idwf    wf.idwf%type;
  v_mensaje   varchar(1000);
  v_error     number;
  l_cont number;
l_contagenda number;

CURSOR c1 IS select idtareawf,tarea,idwf,tareadef,tipo from tareawfcpy where idwf=l_idwf;



BEGIN

BEGIN
v_error   := 0;
select idwf into l_idwf from wf where codsolot=l_codsolot and valido=1;

select numslc into l_numslc from solot where codsolot=l_codsolot;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_numslc := NULL;
    END;

--Asignamiento de contrata, responsable y fecha de programación
BEGIN
update SOLOTPTO_ID
   set RESPONSABLE_PI = l_responsable,
       OBSERVACION    = l_observacion,
       CODCON         = l_codcon,
       ESTADO         = 'Generado',
       FECESTPROG     = l_fecestprog,
       FECPROG        = l_fecestprog,
       CODUSUESTPROG  = user
 where codsolot = l_codsolot;

UPDATE SOLOTPTO SET CINTILLO='0' WHERE CODSOLOT=l_codsolot AND PUNTO=l_punto;
commit;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       o_mensaje   := SQLERRM;
       o_error     := SQLCODE;
    END;

-- Se valida que no existan tareas abiertas y se cierra el WF

    BEGIN
    select count(idwf) into l_cont from wf where codsolot=l_codsolot and valido=1 ;
       select count(*) into l_cont from tareawfcpy, tareawf
       where tareawfcpy.idtareawf = tareawf.idtareawf (+)
       and tareawfcpy.idwf =l_idwf
       and tareawfcpy.tareadef in(669,668)
       and nvl(tareawf.tipesttar,1) in (1,2,3);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         l_cont := NULL;
                  END;
    if l_cont is  not null then

   FOR a1 IN c1 LOOP
    if a1.tareadef in(669,668,684) then
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(a1.idtareawf,4,4,0,SYSDATE,SYSDATE);
     end if;
   END LOOP;
   end if;
      o_error    := v_error;
      o_mensaje  := v_mensaje;
--Agendamiento
select count(*)
  into l_contagenda
  from tareawfcpy
 where idwf = l_idwf
   and tareadef = 667;

if l_contagenda >0 then
PQ_AGENDA.P_AGENDA_TAREAS(l_numslc,TO_CHAR(sysdate,'dd/mm/yyyy'),TO_CHAR(sysdate,'hh24:mi'),l_codsolot,'Servicio Puerta - Puerta', null);
end if;

BEGIN
update SOLOTPTO_ID
   set RESPONSABLE_PI = l_responsable,
       OBSERVACION    = l_observacion,
       CODCON         = l_codcon,
       ESTADO         = 'Generado',
       FECESTPROG     = l_fecestprog,
       FECPROG        = l_fecestprog,
       CODUSUESTPROG  = user
 where codsolot = l_codsolot;

UPDATE SOLOTPTO SET CINTILLO='0' WHERE CODSOLOT=l_codsolot AND PUNTO=l_punto;
commit;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       o_mensaje   := SQLERRM;
       o_error     := SQLCODE;
    END;

   EXCEPTION
   when others then
       o_mensaje   := SQLERRM;
       o_error     := SQLCODE;


END P_AGENDAMIENTO_MASIVO;


PROCEDURE P_ASIGRESPONSABLE_MASIVO(l_codsolot    number,
l_punto solotpto.punto%type,
l_estado solotpto_id.estado%type,
l_responsable_pi  solotpto_id.responsable_pi%type,
l_codcon solotpto_id.codcon%type,
l_observacion  solotpto_id.observacion%type,
o_mensaje        in out varchar2 ,
o_error          in out number
) IS

l_numslc  solot.numslc%type;
l_idwf    wf.idwf%type;
  v_mensaje   varchar(1000);
  v_error     number;
  l_cont number;
l_contagenda number;
l_asigrespon number;
l_idtareawf tareawfcpy.idtareawf%type;
CURSOR c1 IS select idtareawf,tarea,idwf,tareadef,tipo from tareawfcpy where idwf=l_idwf;



BEGIN

BEGIN
v_error   := 0;
select idwf into l_idwf from wf where codsolot=l_codsolot and valido=1;

select numslc into l_numslc from solot where codsolot=l_codsolot;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    l_numslc := NULL;
    END;

--Asignamiento de contrata, responsable y fecha de programación
BEGIN
update SOLOTPTO_ID
   set RESPONSABLE_PI = l_responsable_pi,
       ESTADO         = l_estado,
       OBSERVACION    = l_observacion,
       CODCON         = l_codcon,
       CODUSUESTPROG  = user
 where codsolot = l_codsolot;

UPDATE SOLOTPTO SET CINTILLO='0' WHERE CODSOLOT=l_codsolot AND PUNTO=l_punto;
commit;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       o_mensaje   := SQLERRM;
       o_error     := SQLCODE;
    END;

-- Se valida que no existan tareas abiertas y se cierra el WF

    BEGIN
    --Obtiene Tarea Asignar Responsable
    SELECT VALOR INTO l_asigrespon  FROM CONSTANTE
             WHERE UPPER(CONSTANTE) LIKE 'ARESPONSABLE%';


    SELECT idtareawf into l_idtareawf
    FROM  TAREAWF
    WHERE IDWF=l_idwf
    AND TAREADEF = l_asigrespon;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         l_idtareawf := NULL;
     END;
    if l_idtareawf is  not null then
       OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(l_idtareawf,4,4,0,SYSDATE,SYSDATE);
   end if;
      o_error    := v_error;
      o_mensaje  := v_mensaje;
   EXCEPTION
   when others then
       o_mensaje   := SQLERRM;
       o_error     := SQLCODE;


END P_ASIGRESPONSABLE_MASIVO;
PROCEDURE P_CHG_ESTADO_AGENDA(a_idagenda      IN NUMBER,
                                a_tipo          IN NUMBER, -- >> 1, aplica permisos
                                a_estagenda     IN NUMBER,
                                a_estagenda_old IN NUMBER,
                                a_observacion   IN VARCHAR2 DEFAULT NULL,
                                a_codmotot      IN NUMBER DEFAULT NULL) IS
    ln_estsol_act    number;
    ln_permiso_flujo number;
    ln_estado_final  number;
    ln_mail          number;
    l_tipo           number;
    ln_tipoagenda    number;
    ln_idflujo       number;
  l_proc        number;
  l_sql        VARCHAR2(500);

  begin

    --Validando si el estado coincide con el valor actual.
    select estage, tipo_agenda
      into ln_estsol_act, ln_tipoagenda
      from agenda_tareas
     where idagenda = a_idagenda;

    if ln_estsol_act <> nvl(a_estagenda_old, ln_estsol_act) THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'Error - El estado no coincide con el valor actual en la Base de Datos.');
    end if;

    if a_tipo = 1 then

      --Verificar es estado de la agenda, no se puede cambiar a estados finales.
      select estfinal
        into ln_estado_final
        from estagenda
       where estage = a_estagenda_old;

      if ln_estado_final = 1 then
        raise_application_error(-20500,
                                'No puede cambiar de estado. La tarea se encuentra en estado final.');
      end if;

    end if;
    --Validando la observacion.
    if a_observacion is null or a_observacion = '' then
      raise_application_error(-20500,
                              'Debe ingresar un comentario para poder cambiar de estado.');
    end if;

    SELECT tipestage INTO l_tipo from estagenda where estage = a_estagenda;
    -- 02-04-2008 Ejecucion de Procedimientos segun el Estado.
     begin
       l_proc := null;
     end;
    if l_proc is not null then
        begin
           l_sql := 'begin '|| l_proc || ' ( :1, :2, :3 ); End; ';
         EXECUTE IMMEDIATE l_sql USING a_idagenda, a_estagenda_old, a_estagenda;
          EXCEPTION WHEN OTHERS THEN
            RAISE;
       end;
    end if;

    if l_tipo = 7 then
      -- Instalado/Ejecutado.
      p_ejecutar_agenda(a_idagenda, a_estagenda, l_tipo);
    elsif l_tipo = 5 then
      -- Cancelado (Abortado).
      null;
      --p_abortar_agenda(a_idagenda, a_estagenda, l_tipo);
    elsif l_tipo = 4 then
      -- Cerrado.
      null;
      --p_cerrar_agenda(a_idagenda, a_estagenda, l_tipo);
    else
      Update agenda_tareas
         set estage = a_estagenda, observacion = a_observacion
       where idagenda = a_idagenda;
    end if;

  END;


PROCEDURE P_EJECUTAR_AGENDA(a_idagenda  in number,
                              a_estagenda in number,
                              a_tipo      in number) IS

    ln_idtareawf number;
    ln_idwf number;
  BEGIN
   select idwf into ln_idwf from wf a, agenda_tareas b
   where a.codsolot= b.solot and a.valido=1
   and b.idagenda= a_idagenda;

   BEGIN
   SELECT idtareawf into ln_idtareawf FROM  TAREAWF
   WHERE IDWF= ln_idwf
   AND TAREADEF IN (SELECT VALOR FROM CONSTANTE
             WHERE UPPER(CONSTANTE) LIKE 'ARESPONSABLE%');
   EXCEPTION
   WHEN OTHERS THEN
   ln_idtareawf:=NULL;
   END;
   IF ln_idtareawf is not null then
    PQ_WF.P_CHG_STATUS_TAREAWF(ln_idtareawf,4,4,NULL,sysdate,sysdate);
  end if;
    Update agenda_tareas set estage = a_estagenda
        where idagenda = a_idagenda;


  END;


END Pq_Agenda;
/


