create or replace package body operacion.pq_gestiona_bono is

  procedure SGASI_GENERAR_CO_ID(ac_tip number,
                                ac_codrespuesta out number,
                                av_msgrespuesta out varchar2) is
    ln_idseq_max   tareawfchg.idseq%type;
    ln_idseq_min   tareawfchg.idseq%type;
    ln_count       number;
    ln_co_id       number;
    ln_co_id_old   number;
    ln_customer_id number;

		K_CUR_RESULTADO SYS_REFCURSOR;
		CO_ID ATCCORP.SGAT_CO_ID.CO_ID%TYPE;
		SN_CODE ATCCORP.SGAT_CO_ID.SN_CODE%TYPE;
		CUSTOMER_ID ATCCORP.SGAT_CO_ID.CUSTOMER_ID%TYPE;
    ID_SEQ ATCCORP.SGAT_CO_ID.ID_SEQ%TYPE;

    lv_idseq         number;
  begin

  IF ac_tip = 1 THEN


    --Estado 7
    UPDATE ATCCORP.SGAT_CO_ID T
       SET T.ESTADO = 7
     where LOWER(t.message_resuLt) like LOWER('%CLIENTE NO APLICA A BONO%')
       AND ESTADO IN (4, 5, 6);

    -- valores iniciales
    ac_codrespuesta := 0;
    av_msgrespuesta := 'Ok';

    -- Obtener parametro
    SELECT CODIGON
      into ln_idseq_min
      FROM OPERACION.opedd
     WHERE LOWER(DESCRIPCION) = LOWER('idseq_min_bono');

    SELECT max(idseq) into ln_idseq_max FROM tareawfchg;

    -- Cargar tabla temporal
    delete from ATCCORP.SGAT_TAREAWFCHG_SH_TMP;
    insert into ATCCORP.SGAT_TAREAWFCHG_SH_TMP
      select a.idtareawf, 0, NULL
        from tareawfchg a
       where a.idseq > ln_idseq_min
         and a.idseq <= ln_idseq_max
         and a.esttarea = cn_esttarea_cerrada;

    -- Cargar tabla temporal
    insert into ATCCORP.SGAT_TAREAWFCHG_SH_TMP
      select b.idwf, 1, NULL
        from ATCCORP.SGAT_TAREAWFCHG_SH_TMP a, tareawf b
       where b.idtareawf = a.id
         and b.tareadef = cn_tareadef_activacion_serv;
    delete from ATCCORP.SGAT_TAREAWFCHG_SH_TMP where ESTCONSULTA = 0;

    -- Validacion de bono
    for lr_seq in (select a.idwf, count(*) ln_count
                     from wf                             a,
                          solotpto                       b,
                          inssrv                         c,
                          solot                          d,
                          ATCCORP.SGAT_TAREAWFCHG_SH_TMP e
                    where a.idwf = e.id
                      and b.codsolot = a.codsolot
                      and c.codinssrv = b.codinssrv
                      and c.tipsrv in
                          (SELECT CODIGOC
                             FROM OPERACION.opedd
                            WHERE LOWER(DESCRIPCION) = LOWER('tipsrv_bono'))
                      and d.codsolot = b.codsolot
                      and d.tiptra in
                          (SELECT CODIGON
                             FROM OPERACION.opedd
                            WHERE LOWER(DESCRIPCION) = LOWER('tiptra_bono'))
                    group by a.idwf) loop

      if lr_seq.ln_count > 0 then

        -- busca co_id
        select a.cod_id, a.cod_id_old, a.customer_id
          into ln_co_id, ln_co_id_old, ln_customer_id
          from solot a, wf b
         where a.codsolot = b.codsolot
           and b.idwf = lr_seq.idwf;

        if ln_co_id is not null then
          -- ejecuta el SP de BSCS para validar si aplica o no BONO, y si aplica debe crear la SOT y la INSBONO
          /*
          sp_valida_bono(ln_co_id,
          'BSCS_01'--Dato de prueba
          );
          */

          select ATCCORP.SEQ_SGAT_CO_ID.nextval into lv_idseq from dummy_sgacrm;

          INSERT INTO ATCCORP.SGAT_CO_ID
            (CO_ID, ESTADO, ID_SEQ)
          values
            (ln_co_id, 4, lv_idseq);

        end if;

      end if;

    end loop;

    -- Actualizar parametro
    update OPERACION.opedd
       set CODIGON = ln_idseq_max
     where LOWER(DESCRIPCION) = LOWER('idseq_min_bono');

    commit;

  	OPEN K_CUR_RESULTADO FOR
		SELECT T.CO_ID, T.ID_SEQ
    FROM ATCCORP.SGAT_CO_ID T
    WHERE T.ESTADO IN (4, 5, 6)
    AND (LOWER(MESSAGE_RESULT) NOT LIKE LOWER('%Espera de Desactivacion BSCS%') OR MESSAGE_RESULT IS NULL);
		LOOP
		FETCH K_CUR_RESULTADO
		INTO CO_ID, ID_SEQ;
		EXIT WHEN K_CUR_RESULTADO%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(CO_ID || '|' || ID_SEQ);
		END LOOP;
		CLOSE K_CUR_RESULTADO;

  ELSIF ac_tip = 2 THEN


  	OPEN K_CUR_RESULTADO FOR
		SELECT T.CO_ID, T.SN_CODE, T.CUSTOMER_ID, T.ID_SEQ FROM ATCCORP.SGAT_CO_ID T WHERE T.ESTADO IN (4, 5, 6) AND LOWER(MESSAGE_RESULT) LIKE LOWER('%Espera de Desactivacion BSCS%');
		LOOP
		FETCH K_CUR_RESULTADO
		INTO CO_ID, SN_CODE, CUSTOMER_ID, ID_SEQ;
		EXIT WHEN K_CUR_RESULTADO%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(CUSTOMER_ID || '|' || '0' || '|' || CO_ID || '|' || SN_CODE || '|' || ID_SEQ);
		END LOOP;
		CLOSE K_CUR_RESULTADO;

  END IF;

  exception
    when others then
      ac_codrespuesta := sqlcode;
      av_msgrespuesta := sqlerrm;
  end;

  procedure SGASI_GENERAR_INSBONO(an_co_id        number,
                                  an_sncode       varchar2,
                                  an_customer_id  number,
                                  an_estado       varchar2,
                                  an_seq          number,
                                  an_codinsbono   out number,
                                  an_codrespuesta out number,
                                  av_msgrespuesta out varchar2) as

    an_pid_old       insprd.pid%type;
    ln_codcli        inssrv.codcli%type;
    an_codinssrv_old inssrv.codinssrv%type;
    an_codsrv_old    insprd.codsrv%type;
    ln_codbono       number;
    ln_codsrv_new    insprd.codsrv%type;
    ln_codusu        ATCCORP.SGAT_BONO.CODUSU%type;
    ln_count         number;
    ln_count_d       number;
    ln_descrip       varchar2(100);
    an_pid_new       insprd.pid%type;
    an_codsrv_new    insprd.codsrv%type;
    ln_codsuc        inssrv.codsuc%type;
    an_codinssrv_new inssrv.codinssrv%type;
    lv_idseq         number;

  begin

    an_codrespuesta := 1;
    av_msgrespuesta := 'Exitoso';

    begin
        select count(*)
        into ln_count
        from ATCCORP.SGAT_INSBONO
       where CO_ID = an_co_id
         and estado=1
         and codigo_respuesta=3;

       if ln_count > 0 and an_estado = 'A' then


          select ATCCORP.SEQ_SGAT_CO_ID.nextval into lv_idseq from dummy_sgacrm;

          an_codrespuesta := 7;
          av_msgrespuesta := 'Espera de Desactivacion BSCS';

          select count(*) into ln_count from atccorp.sgat_co_id
          where co_id=an_co_id and sn_code = an_sncode and code_result=an_codrespuesta
          and estado in (4,5,6);

          if ln_count = 0 then
          insert into atccorp.sgat_co_id (CO_ID,SN_CODE,ESTADO,CUSTOMER_ID,CODE_RESULT,message_result,id_seq)
          values (an_co_id,an_sncode,4,an_customer_id,an_codrespuesta,av_msgrespuesta,lv_idseq);
          return;
          end if;

       end if;

    end;


    BEGIN
      select a.codbono, b.codsrv, b.codusu
        into ln_codbono, ln_codsrv_new, ln_codusu
        from ATCCORP.SGAT_BONO_INTERFAZ a, ATCCORP.SGAT_BONO b
       where a.codbono_ext = an_sncode
         and a.codbono = b.codbono;
    EXCEPTION
      WHEN OTHERS THEN
        begin
                select * into ln_codsrv_new, ln_descrip from  (
                               select b.codsrv, c.dscsrv
                        from sales.servicio_sisact               b,
                             usrpvu.sisact_ap_servicio@dbl_pvudb a,
                             tystabsrv                           c
                       where b.idservicio_sisact = a.servv_codigo
                         and a.servv_id_bscs = an_sncode
                         and b.codsrv = c.codsrv
                         and c.codigo_ext is not null
                         order by 1 asc)where rownum=1;

          SELECT MAX(CODBONO) + 1 INTO LN_CODBONO FROM ATCCORP.SGAT_BONO;

          insert into ATCCORP.SGAT_BONO_INTERFAZ
            (CODBONO, CODBONO_EXT, SISTEMA, ESTADO)
          values
            (LN_CODBONO, an_sncode, 'BSCS', 1);
          insert into ATCCORP.SGAT_BONO
            (CODBONO, DESCRIPCION, ESTADO, CODSRV)
          VALUES
            (LN_CODBONO, ln_descrip, 1, ln_codsrv_new);

          goto avanza;
        exception
          when others THEN

            if an_estado = 'D' then
              goto avanza;
            end if;

            an_codrespuesta := -3;
        end;

        an_codrespuesta := -3;
        av_msgrespuesta := 'SNCODE no configurado';

          if an_seq > 0 then

                  update atccorp.sgat_co_id
                     set sn_code        = an_sncode,
                         code_result    = an_codrespuesta,
                         message_result = av_msgrespuesta,
                         estado = 7
                   where co_id = an_co_id
                         and estado=4
                         and id_seq = an_seq;
                  RETURN;

          end if;
    END;

    <<avanza>>
    if an_estado = 'A' then

         select count(*)
        into ln_count
        from ATCCORP.SGAT_INSBONO
       where CO_ID = an_co_id
         and estado=1;

         select count(*)
         into ln_count_d
         from ATCCORP.SGAT_INSBONO
       where CO_ID = an_co_id
         and estado=3 and codigo_respuesta = 3;

      if ln_count = 0 or ln_count_d > 0 then

        select c.pid, d.codcli, c.codinssrv, c.codsrv
          into an_pid_old, ln_codcli, an_codinssrv_old, an_codsrv_old
          from solot a, solotpto b, insprd c, inssrv d
         where a.cod_id = an_co_id
           and a.codsolot = b.codsolot
           and b.pid = c.pid
           and c.flgprinc = 1
           and d.codinssrv = b.codinssrv
           and d.tipsrv = cc_tipsrv_internet
           and c.estinsprd = 1
           and d.estinssrv = 1;

        select ATCCORP.SEQ_CODINSBONO.nextval
          into an_codinsbono
          from dummy_sgacrm;

        insert into ATCCORP.SGAT_INSBONO
          (CODINSBONO,
           CODCLI,
           CODINSSRV_OLD,
           PID_OLD,
           CODSRV_OLD,
           CODSRV_NEW,
           ESTADO,
           CO_ID,
           IDBONO,
           FECUSU,
           SNCODE_A,
           CUSTOMER_ID)
        values
          (an_codinsbono,
           ln_codcli,
           an_codinssrv_old,
           an_pid_old,
           an_codsrv_old,
           ln_codsrv_new,
           4,
           an_co_id,
           ln_codbono,
           sysdate,
           an_sncode,
           an_customer_id);

      end if;

    else

      select count(*)
        into ln_count
        from ATCCORP.SGAT_INSBONO
       where CO_ID = an_co_id
         and SNCODE_D is null;

      if ln_count > 0 then

        select CODINSBONO
          into an_codinsbono
          from ATCCORP.SGAT_INSBONO
         where co_id = an_co_id
           and SNCODE_D is null;

        update ATCCORP.SGAT_INSBONO
           set sncode_d = an_sncode
         where codinsbono = an_codinsbono;

      --Para casos en que se desactive y no este en la Insbono
      else

             select count(*)
             into ln_count
             from ATCCORP.SGAT_INSBONO
             where CO_ID = an_co_id
             and SNCODE_D is not null ;

             if ln_count = 0 then

              select c.pid, d.codcli,d.codsuc ,c.codinssrv, c.codsrv
                into an_pid_new, ln_codcli,ln_codsuc ,an_codinssrv_new, an_codsrv_new
                from solot a, solotpto b, insprd c, inssrv d
               where a.cod_id = an_co_id
                 and a.codsolot = b.codsolot
                 and b.pid = c.pid
                 and c.flgprinc = 1
                 and d.codinssrv = b.codinssrv
                 and d.tipsrv = cc_tipsrv_internet
                 and c.estinsprd = 1
                 and d.estinssrv = 1;


              select * into an_pid_old,an_codinssrv_old,an_codsrv_old
              from (select c.pid, c.codinssrv, c.codsrv
                from insprd c, inssrv d
               where c.flgprinc = 1
                 and d.codinssrv = c.codinssrv
                 and d.tipsrv = cc_tipsrv_internet
                 and d.codcli=ln_codcli
                 and d.codsuc=ln_codsuc
                 and c.estinsprd = 3
                 order by 1 desc)x
                where rownum=1;


              select ATCCORP.SEQ_CODINSBONO.nextval
                into an_codinsbono
                from dummy_sgacrm;

              insert into ATCCORP.SGAT_INSBONO
                (CODINSBONO,
                 CODCLI,
                 CODINSSRV_OLD,
                 CODINSSRV_NEW,
                 PID_OLD,
                 PID_NEW,
                 CODSRV_OLD,
                 CODSRV_NEW,
                 ESTADO,
                 CO_ID,
                 FECUSU,
                 SNCODE_D,
                 CUSTOMER_ID)
                values
                (an_codinsbono,
                 ln_codcli,
                 an_codinssrv_old,
                 an_codinssrv_new,
                 an_pid_old,
                 an_pid_new,
                 an_codsrv_old,
                 an_codsrv_new,
                 1,
                 an_co_id,
                 sysdate,
                 an_sncode,
                 an_customer_id);


              else

                 an_codrespuesta := -2;
                 av_msgrespuesta := 'Bono ya desactivo';


              end if;

      end if;

    end if;

        if an_seq > 0 then

        update atccorp.sgat_co_id
           set sn_code        = an_sncode,
               code_result    = an_codrespuesta,
               message_result = av_msgrespuesta
         where co_id = an_co_id
               and estado in (1,4)
               and id_seq = an_seq;

         end if;

    commit;
  exception
    when others then

      an_codrespuesta := -1;
      av_msgrespuesta := 'Bono no configurado';
       if an_seq > 0 then
          update atccorp.sgat_co_id
               set sn_code        = an_sncode,
                   code_result    = an_codrespuesta,
                   message_result = av_msgrespuesta,
                   estado = 7
             where co_id = an_co_id
                   and estado=4
                   and id_seq = an_seq;
       end if;
  end;



procedure SGASS_OBTENER_BANWID( an_sncode       varchar2,
                                LN_BANWID   out TYSTABSRV.BANWID%TYPE,
                                an_codrespuesta out number,
                                av_msgrespuesta out varchar2) as
  ln_codsrv_new    insprd.codsrv%type;
  ln_descrip       tystabsrv.dscsrv%type;
  LN_CODBONO       ATCCORP.SGAT_BONO.CODBONO%type;
begin
  an_codrespuesta := 1;
  av_msgrespuesta := 'Exitoso';
      BEGIN
          select b.codsrv
            into ln_codsrv_new
            from ATCCORP.SGAT_BONO_INTERFAZ a, ATCCORP.SGAT_BONO b
           where a.codbono_ext = an_sncode
             and a.codbono = b.codbono;
      EXCEPTION
        WHEN OTHERS THEN

          begin

              select * into ln_codsrv_new, ln_descrip from  (
                               select b.codsrv, c.dscsrv
                        from sales.servicio_sisact               b,
                             usrpvu.sisact_ap_servicio@dbl_pvudb a,
                             tystabsrv                           c
                       where b.idservicio_sisact = a.servv_codigo
                         and a.servv_id_bscs = an_sncode
                         and b.codsrv = c.codsrv
                         and c.tipsrv=cc_tipsrv_internet
                         and c.codigo_ext is not null
                         order by 1 asc)where rownum=1;

              SELECT NVL(MAX(CODBONO),0) + 1 INTO LN_CODBONO FROM ATCCORP.SGAT_BONO;

              insert into ATCCORP.SGAT_BONO_INTERFAZ
                (CODBONO, CODBONO_EXT, SISTEMA, ESTADO)
              values
                (LN_CODBONO, an_sncode, 'BSCS', 1);
              insert into ATCCORP.SGAT_BONO
                (CODBONO, DESCRIPCION, ESTADO, CODSRV)
              VALUES
                (LN_CODBONO, ln_descrip, 1, ln_codsrv_new);

              goto avanza;
          exception
              when others THEN
                an_codrespuesta := -2;
            end;

          an_codrespuesta := -2;
          av_msgrespuesta := 'EL SN_CODE:' || an_sncode ||
                             ' NO EXISTE EN ATCCORP.SGAT_BONO_INTERFAZ';
          RETURN;
      END;
      <<avanza>>
      SELECT A.BANWID INTO LN_BANWID FROM TYSTABSRV A WHERE A.CODSRV=ln_codsrv_new;
      IF LN_BANWID IS NULL THEN
        an_codrespuesta := -1;
        av_msgrespuesta := 'El CODSRV ASOCIADO DEL SN_CODE:' || an_sncode ||
                             ' NO TIENE BANWID ';
      END IF;
exception
  when others then
    an_codrespuesta := -1;
    av_msgrespuesta := 'El CODSRV ASOCIADO DEL SN_CODE:' || an_sncode ||
                             ' NO TIENE BANWID ';
end;



  procedure SGASI_IDENTIFICAR_ACCION_BONO(a_idtareawf number,
                                          a_idwf      number,
                                          a_tarea     number,
                                          a_tareadef  number) as

    an_codsolot solot.codsolot%type;

    ln_pid_princ_new       insprd.pid%type;
    lr_inssrv_new          inssrv%rowtype;
    ln_codinssrv_new       inssrv.codinssrv%type;
    ln_pid_princ_old       insprd.pid%type;
    lv_velocidad_old       configuracion_itw.codigo_ext%type;
    lv_velocidad_new       configuracion_itw.codigo_ext%type;
    ln_insidcom_old        ft_instdocumento.insidcom%type;
    ln_servicetype_old     ft_instdocumento.valortxt%type;
    ln_insidcom_new        ft_instdocumento.insidcom%type;
    ln_observacion         varchar2(100);
    ln_insbono             ATCCORP.SGAT_INSBONO%rowtype;
    ln_count_old           number;
    ln_count_new           number;
    an_serviceid           ft_instdocumento.valortxt%type;
    an_codrespuesta        number;
    av_msgrespuesta        varchar2(100);
    ln_incognito           pls_integer;
    ln_idlista_macad_cm    FT_INSTDOCUMENTO.IDLISTA%TYPE;
    ln_idlista_model_cm    FT_INSTDOCUMENTO.IDLISTA%TYPE;
    ln_idlista_serviceid   FT_INSTDOCUMENTO.IDLISTA%TYPE;
    ln_idlista_servicetype FT_INSTDOCUMENTO.IDLISTA%TYPE;
    ln_idcomponente_inter  FT_INSTDOCUMENTO.IDCOMPONENTE%TYPE;

  begin

    an_codrespuesta := 1;
    av_msgrespuesta := 'Exitoso';

    select codsolot into an_codsolot from wf where idwf = a_idwf;

    SELECT D.CODIGON
      INTO ln_idcomponente_inter
      FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
     WHERE C.TIPOPEDD = D.TIPOPEDD
       AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
       AND D.DESCRIPCION = 'Componente_basico_I';

    SELECT D.CODIGON
      INTO ln_idlista_macad_cm
      FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
     WHERE C.TIPOPEDD = D.TIPOPEDD
       AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
       AND D.DESCRIPCION = 'MacAddress_CM';

    SELECT D.CODIGON
      INTO ln_idlista_model_cm
      FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
     WHERE C.TIPOPEDD = D.TIPOPEDD
       AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
       AND D.DESCRIPCION = 'Model_CM';

    SELECT D.CODIGON
      INTO ln_idlista_serviceid
      FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
     WHERE C.TIPOPEDD = D.TIPOPEDD
       AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
       AND D.DESCRIPCION = 'SERVICE_ID';

    SELECT D.CODIGON
      INTO ln_idlista_servicetype
      FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
     WHERE C.TIPOPEDD = D.TIPOPEDD
       AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
       AND D.DESCRIPCION = 'serviceType';

    -- Validamos si modifica servicio principal, se captura pid y INSSRV
    begin
      select c.pid, b.codinssrv
        into ln_pid_princ_new, ln_codinssrv_new
        from solotpto a, inssrv b, insprd c
       where b.codinssrv = a.codinssrv
         and c.pid = a.pid
         and b.codinssrv = c.codinssrv
         and a.codsolot = an_codsolot
         and b.tipsrv = cc_tipsrv_internet
         and c.flgprinc = 1;

      select *
        into lr_inssrv_new
        from inssrv
       where codinssrv = ln_codinssrv_new;

    exception
      when others then
        ln_pid_princ_new := 0;

    end;

    if ln_pid_princ_new <> 0 then

      --se busca si hay un inssrv de internet anterior activo o suspendido

     select *
        into ln_insbono
        from ATCCORP.SGAT_INSBONO
       where codinsbono=(select max(codinsbono) from ATCCORP.SGAT_INSBONO
                         where codinssrv_old = ln_codinssrv_new) ;

      select nvl(SNCODE_A, 0)
        into ln_count_old
        FROM ATCCORP.SGAT_INSBONO
       WHERE codinsbono = ln_insbono.codinsbono;

      select nvl(SNCODE_D, 0)
        into ln_count_new
        FROM ATCCORP.SGAT_INSBONO
       WHERE codinsbono = ln_insbono.codinsbono;

      if ln_count_old > 0 and ln_count_new = 0 then

        UPDATE ATCCORP.SGAT_INSBONO
           set PID_NEW = ln_pid_princ_new, CODINSSRV_NEW = ln_codinssrv_new
         where CODINSBONO = ln_insbono.codinsbono;

      elsif ln_count_old > 0 and ln_count_new > 0 then

        UPDATE ATCCORP.SGAT_INSBONO
           set PID_D = ln_pid_princ_new, CODINSSRV_D = ln_codinssrv_new
         where CODINSBONO = ln_insbono.codinsbono;

      end if;

      update solot
         set customer_id = ln_insbono.customer_id,
             cod_id      = ln_insbono.co_id
       where codsolot = an_codsolot;

      -- Se crea nueva ficha al tocar el servicio principal
      sgacrm.pq_fichatecnica.p_crear_instdoc('INSPRD_EQU',
                                             ln_pid_princ_new,
                                             ln_codinssrv_new,
                                             to_char(ln_insbono.customer_id));

    end if;

    --Se valida que la sot modifica el servicio principal, pero tiene codigo de servicio anterior.

    if ln_pid_princ_new > 0 then

      -- Calcular pid Principal old
      select pid
        into ln_pid_princ_old
        from insprd
       where codinssrv = ln_codinssrv_new
         and flgprinc = 1
         and estinsprd = 1;

      -- Validar si hay cambio de Velocidad
      select a.codigo_ext
        into lv_velocidad_old
        from configuracion_itw a, tystabsrv b, insprd c
       where a.idconfigitw = b.codigo_ext
         and c.pid = ln_pid_princ_old
         and b.codsrv = c.codsrv;

      select a.codigo_ext
        into lv_velocidad_new
        from configuracion_itw a, tystabsrv b, insprd c
       where a.idconfigitw = b.codigo_ext
         and c.pid = ln_pid_princ_new
         and b.codsrv = c.codsrv;

      -- Actualiza el SERVICE_ID Principal en la nueva ficha
      update ft_instdocumento
         set valortxt =
             (select valortxt
                from ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = ln_idlista_serviceid
                 and idcomponente = ln_idcomponente_inter)
       where codigo1 = ln_pid_princ_new
         and idlista = ln_idlista_serviceid
         and idcomponente = ln_idcomponente_inter;

      -- Actualiza MAC y MODEL de equipo en la nueva ficha
      update ft_instdocumento
         set valortxt =
             (select valortxt
                from ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = ln_idlista_macad_cm)
       where codigo1 = ln_pid_princ_new
         and idlista = ln_idlista_macad_cm;

      update ft_instdocumento
         set valortxt =
             (select valortxt
                from ft_instdocumento
               where codigo1 = ln_pid_princ_old
                 and idlista = ln_idlista_model_cm)
       where codigo1 = ln_pid_princ_new
         and idlista = ln_idlista_model_cm;

      --Se actualiza el valortxt del serviceid a null de los adicionales que esten en ambas fichas.

      for ln_actualizador in (select *
                                from sgacrm.ft_instdocumento
                               where idlista in (ln_idlista_servicetype)
                                 and idcomponente in
                                     (cn_idcomponente_adicinter)
                                 and codigo1 = ln_pid_princ_old
                               order by idficha, orden) loop

        begin
          select insidcom
            into ln_insidcom_old
            from ft_instdocumento
           where codigo1 = ln_pid_princ_old
             and valortxt = ln_actualizador.valortxt;

          select valortxt
            into ln_servicetype_old
            from ft_instdocumento
           where codigo1 = ln_pid_princ_old
             and insidcom = ln_insidcom_old
             and idlista = ln_idlista_serviceid;

          select insidcom
            into ln_insidcom_new
            from ft_instdocumento
           where codigo1 = ln_pid_princ_new
             and valortxt = ln_actualizador.valortxt;

          update sgacrm.ft_instdocumento
             set valortxt = null
           where idlista = ln_idlista_serviceid
             and idcomponente = cn_idcomponente_adicinter
             and codigo1 = ln_pid_princ_new
             and insidcom = ln_insidcom_new;

        exception
          when others then
            ln_insidcom_old := 0;
        end;
      end loop ln_actualizador;

      --Actualizamos los serviceID para adicionales
      for ln_actualizador in (select *
                                from sgacrm.ft_instdocumento
                               where idlista in (ln_idlista_servicetype)
                                 and idcomponente in
                                     (cn_idcomponente_adicinter)
                                 and codigo1 = ln_pid_princ_old
                               order by idficha, orden) loop
        begin
          select insidcom
            into ln_insidcom_old
            from ft_instdocumento
           where codigo1 = ln_pid_princ_old
             and valortxt = ln_actualizador.valortxt;

          select valortxt
            into ln_servicetype_old
            from ft_instdocumento
           where codigo1 = ln_pid_princ_old
             and insidcom = ln_insidcom_old
             and idlista = ln_idlista_serviceid;

          select insidcom
            into ln_insidcom_new
            from ft_instdocumento
           where codigo1 = ln_pid_princ_new
             and valortxt = ln_actualizador.valortxt;

          update sgacrm.ft_instdocumento
             set valortxt = ln_servicetype_old
           where idlista = ln_idlista_serviceid
             and idcomponente = cn_idcomponente_adicinter
             and codigo1 = ln_pid_princ_new
             and insidcom = ln_insidcom_new
             and rownum = 1
             and valortxt is null;

        exception
          when others then
            ln_insidcom_old := 0;
        end;

      end loop ln_actualizador;

      if lv_velocidad_old <> lv_velocidad_new then

        select valortxt
          into an_serviceid
          from ft_instdocumento
         where codigo1 = ln_pid_princ_old
           and idlista = ln_idlista_serviceid
           and idcomponente = ln_idcomponente_inter;

        --Se llena el campo observacion
        select 'De: ' || lv_velocidad_old || ' - ' || lv_velocidad_new
          into ln_observacion
          from dual;

        SELECT D.CODIGON
          INTO LN_INCOGNITO
          FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
         WHERE C.TIPOPEDD = D.TIPOPEDD
           AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
           AND D.DESCRIPCION = 'PROVISION INCOGNITO';

        if LN_INCOGNITO = 1 then
          OPERACION.PKG_PROV_INCOGNITO.SGASS_CAMBIO_PLAN(an_codsolot,
                                                         ln_insbono.customer_id,
                                                         an_serviceid,
                                                         lv_velocidad_new,
                                                         '',
                                                         an_codrespuesta,
                                                         av_msgrespuesta);

        else
          an_codrespuesta := 1;
          av_msgrespuesta := 'Provision correcta';

        end if;

      end if;

    end if;

    UPDATE ATCCORP.SGAT_INSBONO
       SET MENSAJE_RESPUESTA = av_msgrespuesta,
           CODIGO_RESPUESTA  = an_codrespuesta
     WHERE CODINSBONO = ln_insbono.codinsbono;

  end;

  PROCEDURE SGASI_GENERAR_SOT(AS_CODINSBONO ATCCORP.SGAT_INSBONO.CODINSBONO%TYPE,
                              AN_SEQ        ATCCORP.SGAT_CO_ID.ID_SEQ%TYPE,
                              PO_CODERROR   OUT NUMBER,
                              PO_MSJERROR   OUT VARCHAR2) IS
    AS_NUMSLC     VTATABSLCFAC.NUMSLC%TYPE DEFAULT NULL;
    AS_NUMPTO     VTADETPTOENL.NUMPTO%TYPE;
    L_NUMSLC      VTATABSLCFAC.NUMSLC%TYPE;
    L_NUMPTO      VTADETPTOENL.NUMPTO%TYPE;
    L_CODCLI      VTATABSLCFAC.CODCLI%TYPE;
    L_CODSUC      VTADETPTOENL.CODSUC%TYPE;
    L_IDPAQ       VTADETPTOENL.IDPAQ%TYPE;
    L_DSCTIPSRV   VTATABSLCFAC.SRVPRI%TYPE;
    L_DESCRIPCION VTADETPTOENL.DESCPTO%TYPE;
    L_DIRECCION   VTADETPTOENL.DIRPTO%TYPE;
    L_CODUBI      VTADETPTOENL.UBIPTO%TYPE;
    L_VENTA       VTATABSLCFAC%ROWTYPE;
    D_VENTA       VTADETPTOENL%ROWTYPE;
    CODERROR3     NUMBER(3);
    CODERROR4     NUMBER(3);
    L_IDFLUJO     NUMBER;
    AS_IDSOLUCION VTATABSLCFAC.IDSOLUCION%TYPE;
    AS_IDCAMPANHA VTATABSLCFAC.IDCAMPANHA%TYPE;
    AS_IDPRODUCTO VTADETPTOENL.IDPRODUCTO%TYPE;
    AS_IDDET      SALES.DETALLE_PAQUETE.IDDET%TYPE;
    AS_IDINSXPAQ  VTADETPTOENL.IDINSXPAQ%TYPE;
    INS_BONO      ATCCORP.SGAT_INSBONO%ROWTYPE;
    MSJERROR      VARCHAR2(500);
    CONTAR        NUMBER := 0;
    L_ESTSOLFAC   VARCHAR2(2) := '00';
    L_CODSOL      VARCHAR2(8) := '00000000';
    L_PLAZO_SRV   VARCHAR2(2) := 10; --INDETERMINADO
    L_NUMPTO_PRIN VARCHAR2(5) := '00001';
    L_TIPTRA_E    NUMBER;
    L_TIPTRA_Q    NUMBER;
    AS_DSCSRV     TYSTABSRV.DSCSRV%TYPE;
    --TEM
    V_WF         OPEWF.WFDEF.WFDEF%TYPE;
    TEM_CODSOLOT OPERACION.SOLOT.CODSOLOT%TYPE;
    TEM_TIPTRA   OPERACION.SOLOT.TIPTRA%TYPE;
    LN_COUNT     NUMBER;
    LN_ESTADO    NUMBER;
    LN_CODRES    NUMBER;

  BEGIN
    SELECT IB.ESTADO, IB.CODIGO_RESPUESTA
      INTO LN_ESTADO, LN_CODRES
      FROM ATCCORP.SGAT_INSBONO IB
     WHERE IB.CODINSBONO = AS_CODINSBONO;

    IF LN_ESTADO = 4 AND LN_CODRES = 1 THEN
      PO_CODERROR := -14;
      PO_MSJERROR := 'PROCESO CON ERROR EN LA WF: ' || SQLERRM;
      RETURN;
    ELSIF LN_ESTADO = 1 AND LN_CODRES = 2 THEN
      PO_CODERROR := -15;
      PO_MSJERROR := 'FALTA RESPONDER A BSCS PARA LA ACTIVACION: ' ||
                     SQLERRM;
      RETURN;
    ELSIF LN_ESTADO = 3 AND LN_CODRES = 2 THEN
      PO_CODERROR := -16;
      PO_MSJERROR := 'FALTA RESPONDER A BSCS PARA LA DESACTIVACION: ' ||
                     SQLERRM;
      RETURN;
    ELSE

      --SI YA EXISTE SOT
      SELECT COUNT(1)
        INTO LN_COUNT
        FROM OPERACION.SOLOT S
       WHERE S.CODSOLOT =
             (SELECT DISTINCT (MAX(SP.CODSOLOT))
                FROM OPERACION.SOLOTPTO SP
               WHERE SP.CODINSSRV =
                     (SELECT MAX(I.CODINSSRV)
                        FROM OPERACION.INSSRV I
                       WHERE I.CODCLI =
                             (SELECT IB.CODCLI
                                FROM ATCCORP.SGAT_INSBONO IB
                               WHERE IB.CODINSBONO = AS_CODINSBONO)
                         AND I.TIPSRV = '0006'
                         AND I.ESTINSSRV = 1))
         AND S.TIPTRA IN
             (SELECT P.CODIGON
                FROM OPERACION.OPEDD P
               WHERE P.DESCRIPCION IN
                     ('HFC - ACTIVAR BONO', 'HFC - DESACTIVAR BONO')
                 AND P.TIPOPEDD =
                     (SELECT TP.TIPOPEDD
                        FROM OPERACION.TIPOPEDD TP
                       WHERE TP.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'))
         AND S.ESTSOL IN (11, 17);

      IF LN_COUNT <> 0 THEN
        PO_CODERROR := -13;
        PO_MSJERROR := 'YA SE CREO SOT EN ESTADO 11 PARA EL CLIENTE: ' ||
                       SQLERRM;
        RETURN;
      ELSIF LN_COUNT = 0 THEN

        SELECT D.CODIGON
          INTO L_TIPTRA_E
          FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
         WHERE C.TIPOPEDD = D.TIPOPEDD
           AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
           AND D.DESCRIPCION = 'HFC - ACTIVAR BONO';

        SELECT D.CODIGON
          INTO L_TIPTRA_Q
          FROM OPERACION.TIPOPEDD C, OPERACION.OPEDD D
         WHERE C.TIPOPEDD = D.TIPOPEDD
           AND C.DESCRIPCION = 'BONO AUMENTA VELOCIDAD'
           AND D.DESCRIPCION = 'HFC - DESACTIVAR BONO';

        --REGISTRO INSBONO
        BEGIN
          SELECT IB.*
            INTO INS_BONO
            FROM ATCCORP.SGAT_INSBONO IB
           WHERE IB.CODINSBONO = AS_CODINSBONO;

          IF INS_BONO.CODINSBONO IS NOT NULL THEN
            --OBTENER CODCLI, CODSUC, IDPAQ Y CODUBI
            BEGIN
              SELECT I.CODCLI,
                     I.CODSUC,
                     I.IDPAQ,
                     TP.DSCTIPSRV,
                     I.DESCRIPCION,
                     I.DIRECCION,
                     I.CODUBI
                INTO L_CODCLI,
                     L_CODSUC,
                     L_IDPAQ,
                     L_DSCTIPSRV,
                     L_DESCRIPCION,
                     L_DIRECCION,
                     L_CODUBI
                FROM INSSRV I, INSPRD IP, TYSTIPSRV TP
               WHERE I.CODINSSRV = IP.CODINSSRV
                 AND I.TIPSRV = TP.TIPSRV
                 AND IP.FLGPRINC = 1
                 AND IP.PID = INS_BONO.PID_OLD;
            EXCEPTION
              WHEN OTHERS THEN
                PO_CODERROR := -1;
                PO_MSJERROR := 'ERROR AL OBTENER EL CODCLI, CODSUC, IDPAQ Y CODUBI: ' ||
                               SQLERRM;
                GOTO FINBONO;
            END;

            --OBTENER IDPRODUCTO
            BEGIN
              IF INS_BONO.ESTADO = 4 THEN
                SELECT TS.IDPRODUCTO, TS.DSCSRV
                  INTO AS_IDPRODUCTO, AS_DSCSRV
                  FROM TYSTABSRV TS
                 WHERE TS.CODSRV = INS_BONO.CODSRV_NEW; --CAM
              ELSIF INS_BONO.ESTADO IN (1, 2) THEN
                SELECT TS.IDPRODUCTO, TS.DSCSRV
                  INTO AS_IDPRODUCTO, AS_DSCSRV
                  FROM TYSTABSRV TS
                 WHERE TS.CODSRV = INS_BONO.CODSRV_OLD; --CAM
              END IF;
            EXCEPTION
              WHEN OTHERS THEN
                PO_CODERROR := -2;
                PO_MSJERROR := 'ERROR AL OBTENER EL IDPRODUCTO: ' ||
                               SQLERRM;
                GOTO FINBONO;
            END;

            --OBTENER IDSOLUCION Y IDCAMPAHNA
            BEGIN
              SELECT SC.IDSOLUCION, C.IDCAMPANHA
                INTO AS_IDSOLUCION, AS_IDCAMPANHA
                FROM SOLUCIONXCAMPANHA SC, CAMPANHA C, PAQUETE_VENTA PV
               WHERE PV.IDPAQ = l_idpaq
                 AND PV.IDSOLUCION = SC.IDSOLUCION
                 AND SC.IDCAMPANHA = C.IDCAMPANHA;

            EXCEPTION
              WHEN OTHERS THEN
                PO_CODERROR := -3;
                PO_MSJERROR := 'ERROR AL OBTENER EL IDSOLUCION Y IDCAMPANHA: ' ||
                               SQLERRM;
                GOTO FINBONO;
            END;

            --OBTENER IDDET
            BEGIN
              SELECT DP.IDDET
                INTO AS_IDDET
                FROM DETALLE_PAQUETE DP
               WHERE DP.IDPAQ = l_idpaq
                 AND DP.IDPRODUCTO = AS_IDPRODUCTO;

            EXCEPTION
              WHEN OTHERS THEN
                PO_CODERROR := -4;
                PO_MSJERROR := 'ERROR AL OBTENER EL IDDET: ' || SQLERRM;
                GOTO FINBONO;
            END;

            --OBTENER IDINSXPAQ
            BEGIN
              SELECT MAX(DP.IDINSXPAQ)
                INTO AS_IDINSXPAQ
                FROM VTADETPTOENL DP, INSPRD IP
               WHERE DP.NUMSLC = IP.NUMSLC
                 AND IP.PID = INS_BONO.PID_OLD;

            EXCEPTION
              WHEN OTHERS THEN
                PO_CODERROR := -5;
                PO_MSJERROR := 'ERROR AL OBTENER EL IDINSXPAQ: ' || SQLERRM;
                GOTO FINBONO;
            END;
          END if;
        EXCEPTION
          WHEN OTHERS THEN
            PO_CODERROR := -6;
            PO_MSJERROR := 'CODIGO:' || AS_CODINSBONO ||
                           ' NO SE ENCUENTA EN LA TABLA INSBONO: ' ||
                           SQLERRM;
            GOTO FINBONO;
        END;
        P_CODCLI_G := L_CODCLI;

        BEGIN
          L_VENTA.NUMSLC    := AS_NUMSLC;
          L_VENTA.CODCLI    := L_CODCLI;
          L_VENTA.FECPEDSOL := SYSDATE;
          L_VENTA.ESTSOLFAC := L_ESTSOLFAC;
          L_VENTA.CODSOL    := L_CODSOL;
          IF INS_BONO.ESTADO = 4 THEN
            L_VENTA.SRVPRI    := 'ENTREGA BONO CAMBIO VELOCIDAD';
            L_VENTA.OBSSOLFAC := 'Se ha Activado el Bono a ' || AS_DSCSRV;
          ELSIF INS_BONO.ESTADO IN (1, 2) THEN
            L_VENTA.SRVPRI    := 'DESACTIVACION BONO CAMBIO VELOCIDAD';
            L_VENTA.OBSSOLFAC := 'Se ha Desactivado el Bono a ' ||
                                 AS_DSCSRV;
          END IF;

          L_VENTA.FECGENFACPIN   := SYSDATE;
          L_VENTA.FECGENFACPEX   := SYSDATE;
          L_VENTA.FECAPR         := SYSDATE;
          L_VENTA.TIPSRV         := P_TIPSRV_G;
          L_VENTA.IDSOLUCION     := AS_IDSOLUCION;
          L_VENTA.PLAZO_SRV      := L_PLAZO_SRV; --INDETERMINADO;
          L_VENTA.TIPO           := 0;
          L_VENTA.FLGCBAN        := 0;
          L_VENTA.FLGCEQU        := 0;
          L_VENTA.FLGCOVE        := 0;
          L_VENTA.FLGPRYESP      := 0;
          L_VENTA.FLGESTCOM      := 0;
          L_VENTA.IDCAMPANHA     := AS_IDCAMPANHA;
          L_VENTA.IDTIPOSOLUCION := 1;
          L_VENTA.CODINCIDENCE   := 0;

          INSERT INTO SALES.VTATABSLCFAC
          VALUES L_VENTA
          RETURNING NUMSLC INTO L_NUMSLC;

        EXCEPTION
          WHEN OTHERS THEN
            PO_CODERROR := -7;
            PO_MSJERROR := 'ERROR INSERT INTO VTATABSLCFAC : ' || SQLERRM;
            GOTO FINBONO;
        END;

        BEGIN

          SELECT LPAD(NVL(TO_NUMBER(MAX(NUMPTO)), 0) + 1, 5, '0')
            INTO AS_NUMPTO
            FROM VTADETPTOENL
           WHERE NUMSLC = L_NUMSLC;

          D_VENTA.NUMSLC      := L_NUMSLC;
          D_VENTA.NUMPTO      := AS_NUMPTO;
          D_VENTA.NUMPTO_PRIN := AS_NUMPTO; --L_NUMPTO_PRIN;
          D_VENTA.DESCPTO     := L_DESCRIPCION;
          D_VENTA.DIRPTO      := L_DIRECCION;
          D_VENTA.UBIPTO      := L_CODUBI;
          IF INS_BONO.ESTADO = 4 THEN
            D_VENTA.CODSRV := INS_BONO.CODSRV_NEW;
          ELSIF INS_BONO.ESTADO = 1 OR INS_BONO.ESTADO = 2 THEN
            D_VENTA.CODSRV := INS_BONO.CODSRV_OLD;
          END IF;
          D_VENTA.FECUSU     := SYSDATE;
          D_VENTA.CODUSU     := USER;
          D_VENTA.FLGREDUN   := 0;
          D_VENTA.ESTMT      := 0;
          D_VENTA.FLGPOST    := 0;
          D_VENTA.CODSUC     := L_CODSUC;
          D_VENTA.IDPAQ      := L_IDPAQ;
          D_VENTA.FLGSRV_PRI := 1;
          IF INS_BONO.ESTADO = 4 THEN
            D_VENTA.TIPTRA := L_TIPTRA_E;
          ELSIF INS_BONO.ESTADO IN (1, 2) THEN
            D_VENTA.TIPTRA := L_TIPTRA_Q;
          END IF;
          D_VENTA.PAQUETE    := 1;
          D_VENTA.TIPO_VTA   := 9;
          D_VENTA.IDPRODUCTO := AS_IDPRODUCTO;
          D_VENTA.IDINSXPAQ  := AS_IDINSXPAQ;
          D_VENTA.IDDET      := AS_IDDET;
          D_VENTA.CODINSSRV  := INS_BONO.CODINSSRV_OLD;
          D_VENTA.PID_OLD    := INS_BONO.PID_OLD;

          --      INSERT INTO SALES.VTADETPTOENL VALUES D_VENTA RETURNING NUMPTO INTO L_NUMPTO;
          INSERT INTO SALES.VTADETPTOENL VALUES D_VENTA;
        EXCEPTION
          WHEN OTHERS THEN
            PO_CODERROR := -8;
            PO_MSJERROR := 'ERROR INSERT INTO VTADETPTOENL : ' || SQLERRM;
            GOTO FINBONO;
        END;

        --INSERTAR PRECON
        SGASI_GENERAR_VTATABPRECON(L_NUMSLC, L_CODCLI, CODERROR3, MSJERROR);
        IF CODERROR3 = -9 THEN
          PO_CODERROR := -9;
          PO_MSJERROR := MSJERROR;
          GOTO FINBONO;
        END IF;

        --INSERTAR EF
        SGASI_GENERAR_EF(L_NUMSLC, CODERROR4, MSJERROR);
        IF CODERROR4 = -10 THEN
          PO_CODERROR := -10;
          PO_MSJERROR := MSJERROR;
          GOTO FINBONO;
        END IF;

        --BUSCAR EL TIPO DE FLUJO
        BEGIN
          SELECT B.IDFLUJO
            INTO L_IDFLUJO
            FROM TIPOSOL_PLANTILLA A, VTAFLUJOESTADO B, VTATABSLCFAC C
           WHERE A.IDPLANTILLA = B.IDPLANTILLA
             AND A.IDTIPOSOLUCION = C.IDTIPOSOLUCION
             AND C.NUMSLC = L_NUMSLC
             AND B.TABEST = '00'
             AND B.CODEST_OLD = '00'
             AND B.CODEST_NEW = '01';

          --EJECUTAR  FLUJO AUTOMATICO
          PQ_PROYECTO.P_EJECUTA_FLUJO_AUTOMATICO(L_NUMSLC, '01', L_IDFLUJO);

        EXCEPTION
          WHEN OTHERS THEN
            PO_CODERROR := -11;
            PO_MSJERROR := 'ERROR FLUJO AUTOMATICO : ' || SQLERRM;
            GOTO FINBONO;
        END;

        PO_CODERROR := 1;
        PO_MSJERROR := 'PROCESO TERMINADO CON EXITO';

      END IF;
    END IF;

    <<FINBONO>>
  --ACTUALIZAR EL ESTADO DE LA TABLA CO_ID
  IF AN_SEQ > 0 THEN
    IF PO_CODERROR = 1 THEN
      UPDATE ATCCORP.SGAT_CO_ID
         SET ESTADO = 1,
         CODE_RESULT = '1',
         MESSAGE_RESULT = 'PROCESO TERMINADO CORRECTAMENTE'
       WHERE ID_SEQ = AN_SEQ;
    ELSIF PO_CODERROR <> 1 THEN
      UPDATE ATCCORP.SGAT_CO_ID
         SET ESTADO = ESTADO + 1
       WHERE ID_SEQ = AN_SEQ;
    END IF;
   END IF;
   
   BEGIN
        SELECT S.CODSOLOT, S.TIPTRA INTO TEM_CODSOLOT,TEM_TIPTRA FROM OPERACION.SOLOT S
         WHERE S.NUMSLC = l_numslc;
           --Actualizacion del codmotot
             --Activacion
             IF INS_BONO.ESTADO = 4 THEN
                  
                UPDATE SOLOT
                   SET CODMOTOT = (SELECT M.CODMOTOT
                                     FROM OPERACION.MOTOT M
                                    WHERE M.DESCRIPCION = 'HFC - ACTIVAR BONO')
                       WHERE CODSOLOT = TEM_CODSOLOT;
             --desactivacion
             ELSIF INS_BONO.ESTADO = 1 THEN
             
                UPDATE SOLOT
                SET  CODMOTOT = (SELECT M.CODMOTOT
                                     FROM OPERACION.MOTOT M
                                    WHERE M.DESCRIPCION = 'HFC - DESACTIVAR BONO') 
                       WHERE CODSOLOT = TEM_CODSOLOT;
              END IF;
    
         --WF ASIGNACION
         IF INS_BONO.ESTADO in (1,2,4) THEN
         
         SELECT WFDEF INTO V_WF FROM OPEWF.WFDEF
         WHERE DESCRIPCION = 'HFC - CAMBIO DE VELOCIDAD (BONO)';
    
           BEGIN    
           PQ_SOLOT.P_ASIG_WF(TEM_CODSOLOT,V_WF);
           END;
           
         END IF; 
         --WF FIN
 END;
  EXCEPTION
    WHEN OTHERS THEN
      PO_CODERROR := -12;
      PO_MSJERROR := 'ERROR: ' || SQLERRM;

  END;

  PROCEDURE SGASI_GENERAR_VTATABPRECON(S_NUMSLC    VTATABSLCFAC.NUMSLC%TYPE,
                                       S_CODCLI    VTATABSLCFAC.CODCLI%TYPE,
                                       PO_CODERROR OUT NUMBER,
                                       PO_MSJERROR OUT VARCHAR2) IS

    P_VENTA SALES.VTATABPRECON%ROWTYPE;

  BEGIN
    P_VENTA.NUMSLC            := S_NUMSLC;
    P_VENTA.CODCLI            := S_CODCLI;
    P_VENTA.NRODOC            := S_NUMSLC;
    P_VENTA.FECACE            := SYSDATE;
    P_VENTA.FECREC            := SYSDATE;
    P_VENTA.FECAPLCOM         := SYSDATE;
    P_VENTA.FECUSU            := SYSDATE;
    P_VENTA.FECCODEMAIL       := SYSDATE;
    P_VENTA.CODMODELO         := 0;
    P_VENTA.CODPAI            := '51';
    P_VENTA.FLAG_FACTXSEGUNDO := 0;
    P_VENTA.FLAG_FACTXMINUTO  := 1;
    P_VENTA.CARTA             := 0;
    P_VENTA.CARRIER           := '0';
    P_VENTA.CODUSU            := USER;

    INSERT INTO SALES.VTATABPRECON VALUES P_VENTA;

  EXCEPTION
    WHEN OTHERS THEN
      PO_CODERROR := -9;
      PO_MSJERROR := 'ERROR AL INSERTAR LA TABLA PRECOM';
  END;

  PROCEDURE SGASI_GENERAR_EF(S_NUMSLC    VTATABSLCFAC.NUMSLC%TYPE,
                             PO_CODERROR OUT NUMBER,
                             PO_MSJERROR OUT VARCHAR2) IS

    EF_VENTA OPERACION.EF%ROWTYPE;
  BEGIN
    EF_VENTA.CODEF     := TO_NUMBER(S_NUMSLC);
    EF_VENTA.NUMSLC    := S_NUMSLC;
    EF_VENTA.CODCLI    := P_CODCLI_G;
    EF_VENTA.ESTEF     := 10; -- ESTADO GENERADO
    EF_VENTA.COSMO     := 0;
    EF_VENTA.COSMAT    := 0;
    EF_VENTA.COSEQU    := 0;
    EF_VENTA.COSMATCLI := 0;
    EF_VENTA.COSMOCLI  := 0;
    EF_VENTA.NUMDIAPLA := 30; --POR DEFINIR
    EF_VENTA.FECUSU    := SYSDATE;
    EF_VENTA.CODUSU    := USER;
    EF_VENTA.TIPSRV    := P_TIPSRV_G;
    EF_VENTA.COSMO_S   := 80;
    EF_VENTA.COSMAT    := 0;

    EF_VENTA.COSMAT_S := 0;

    INSERT INTO OPERACION.EF VALUES EF_VENTA;

  EXCEPTION
    WHEN OTHERS THEN
      PO_CODERROR := -10;
      PO_MSJERROR := 'ERROR AL INSERTAR LA TABLA EF: ' || SQLERRM;

  END;

  PROCEDURE SGASU_ASIGNAR_ESTADOS_SERV(A_IDTAREAWF IN NUMBER,
                                       A_IDWF      IN NUMBER,
                                       A_TAREA     IN NUMBER,
                                       A_TAREADEF  IN NUMBER) IS

    V_CODINSSRV INSSRV.CODINSSRV%TYPE;
    V_COUNT     PLS_INTEGER;
    V_PID_OLD   ATCCORP.SGAT_INSBONO.PID_OLD%TYPE;
    V_PID_NEW   ATCCORP.SGAT_INSBONO.PID_NEW%TYPE;
    V_PID_O     ATCCORP.SGAT_INSBONO.PID_OLD%TYPE;
    V_PID_N     ATCCORP.SGAT_INSBONO.PID_NEW%TYPE;
    V_CODSRV    ATCCORP.SGAT_INSBONO.CODSRV_NEW%TYPE;
    V_MSJERROR  VARCHAR2(1000) := 'PROCESO TERMINADO CON EXITO';
    EX_CUSTOM EXCEPTION;
    V_ACCION PLS_INTEGER;
    V_CODMSJ ATCCORP.SGAT_INSBONO.CODIGO_RESPUESTA%TYPE;
    LN_INSBONO   ATCCORP.SGAT_INSBONO%ROWTYPE;

  BEGIN
    --CODINSSRV CREADO
    SELECT DISTINCT C.CODINSSRV
      INTO V_CODINSSRV
      FROM OPEWF.WF A, OPERACION.SOLOT B, OPERACION.SOLOTPTO C
     WHERE A.CODSOLOT = B.CODSOLOT
       AND A.IDWF = A_IDWF
       AND B.CODSOLOT = C.CODSOLOT
       AND VALIDO = 1;

     SELECT *
        INTO LN_INSBONO
        FROM ATCCORP.SGAT_INSBONO
       WHERE CODINSBONO=(SELECT MAX(CODINSBONO) FROM ATCCORP.SGAT_INSBONO
                         WHERE CODINSSRV_OLD = V_CODINSSRV) ;


    --SI EXISTE REGISTRO
    SELECT COUNT(1)
      INTO V_COUNT
      FROM ATCCORP.SGAT_INSBONO I
     WHERE I.CODINSSRV_OLD = V_CODINSSRV
       AND I.CODINSSRV_D IS NULL
       AND I.CODINSBONO=LN_INSBONO.CODINSBONO;

    --ACTIVACION
    IF V_COUNT = 1 THEN
      V_ACCION := 1;

      SELECT I.CODIGO_RESPUESTA
        INTO V_CODMSJ
        FROM ATCCORP.SGAT_INSBONO I
       WHERE I.CODINSSRV_OLD = V_CODINSSRV
       AND I.CODINSBONO=LN_INSBONO.CODINSBONO;

      IF V_CODMSJ = 1 THEN
        SELECT I.PID_OLD, I.PID_NEW
          INTO V_PID_OLD, V_PID_NEW
          FROM ATCCORP.SGAT_INSBONO I
         WHERE I.CODINSSRV_OLD = V_CODINSSRV
         AND I.CODINSBONO=LN_INSBONO.CODINSBONO;
      END IF;

      --DESACTIVACION
    ELSIF V_COUNT = 0 THEN
      SELECT COUNT(1)
        INTO V_COUNT
        FROM ATCCORP.SGAT_INSBONO
       WHERE CODINSSRV_D = V_CODINSSRV
       AND CODINSBONO=LN_INSBONO.CODINSBONO;

      IF V_COUNT = 1 THEN
        V_ACCION := 3;
        SELECT I.CODIGO_RESPUESTA
          INTO V_CODMSJ
          FROM ATCCORP.SGAT_INSBONO I
         WHERE I.CODINSSRV_D = V_CODINSSRV
         AND I.CODINSBONO=LN_INSBONO.CODINSBONO;

        IF V_CODMSJ = 1 THEN
          --V_ACCION:= 3;
          SELECT I.PID_NEW, I.PID_D
            INTO V_PID_OLD, V_PID_NEW
            FROM ATCCORP.SGAT_INSBONO I
           WHERE I.CODINSSRV_D = V_CODINSSRV
           AND I.CODINSBONO=LN_INSBONO.CODINSBONO;
        END IF;
      END IF;
    END IF;

    IF V_PID_OLD IS NULL OR V_PID_NEW IS NULL THEN
      V_MSJERROR := 'EL PID_OLD Y/O EL PID_NEW ESTAN EN VALOR NULO';
      RAISE EX_CUSTOM;
    END IF;

    BEGIN
      --DESACTIVACION
      SELECT PID
        INTO V_PID_O
        FROM OPERACION.INSPRD
       WHERE PID = V_PID_OLD
         AND FLGPRINC = 1
         AND ESTINSPRD IN (1, 2);

      IF V_PID_O IS NOT NULL THEN

        UPDATE ATCCORP.SGAT_INSBONO B
           SET B.ESTADO = 3, B.FECFIN = SYSDATE
         WHERE B.PID_NEW = V_PID_O
           AND B.ESTADO IN (1, 2);

        UPDATE OPERACION.INSPRD P
           SET P.ESTINSPRD = 3, P.FECFIN = SYSDATE
         WHERE P.PID = V_PID_O;

      END IF;

    END;

    BEGIN
      --ACTIVACION
      SELECT PID, CODSRV
        INTO V_PID_N, V_CODSRV
        FROM OPERACION.INSPRD
       WHERE PID = V_PID_NEW
         AND FLGPRINC = 1
         AND ESTINSPRD = 4;

      IF V_PID_N IS NOT NULL THEN

        UPDATE ATCCORP.SGAT_INSBONO B
           SET B.ESTADO = 1, B.FECINI = SYSDATE
         WHERE B.PID_NEW = V_PID_N
           AND B.ESTADO = 4;

        UPDATE OPERACION.INSSRV S
           SET S.CODSRV = V_CODSRV
         WHERE S.CODINSSRV =
               (SELECT P.CODINSSRV FROM INSPRD P WHERE P.PID = V_PID_N);

        UPDATE OPERACION.INSPRD P
           SET P.ESTINSPRD = 1, P.FECINI = SYSDATE
         WHERE P.PID = V_PID_N;
      END IF;

    END;

    -- ACTUALIZAR CAMPOS :MENSAJE Y CODIGO_RESPUESTA

    IF V_ACCION = 1 THEN
      UPDATE ATCCORP.SGAT_INSBONO
         SET MENSAJE_RESPUESTA = V_MSJERROR, CODIGO_RESPUESTA = 2
       WHERE CODINSSRV_OLD = V_CODINSSRV
         AND CODINSBONO=LN_INSBONO.CODINSBONO;

    ELSIF V_ACCION = 3 THEN
      UPDATE ATCCORP.SGAT_INSBONO
         SET MENSAJE_RESPUESTA = V_MSJERROR, CODIGO_RESPUESTA = 2
       WHERE CODINSSRV_D = V_CODINSSRV
         AND CODINSBONO=LN_INSBONO.CODINSBONO;
    END IF;
  END;
end pq_gestiona_bono;
/