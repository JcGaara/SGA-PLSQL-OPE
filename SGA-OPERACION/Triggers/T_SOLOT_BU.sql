CREATE OR REPLACE TRIGGER OPERACION.T_SOLOT_BU
BEFORE UPDATE
ON OPERACION.SOLOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

  /*****************************************************************************************************************
   NAME:       T_SOLOT_BU
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/08/2004  Victor Valqui    Ya no se crea historico cuando hay cambio de estado.
                                           Esta funcionalida fue movida a procedimiento PQ_SOLOT.p_chg_estado_solot.
   2.0        30/10/2007  Luigi Torres     Se incluye lógica que asigna el usuario 'CEXPLORA' si el cliente asociado
                                           a la SOT no cuenta con usuario CCARE asociado. Esto cuando la SOT cambia
                                           de estado a "En Ejecucion""
   3.0        15/07/2008  Jimmy Farfan     Funcionalidad de devoluciones por sot anuladas
   4.0        15/07/2008  Gustavo Ormeño   Se comenta condición que verifica si hay un cambio en el código de cliente
                                           cuando se actualiza una SOT ya anulada (estadoo 13)
   5.0        28/09/2009  Edson Caqui      Req. 102998 - Llamada al procedimiento collections.P_NCXDEVOLUCION es
                                           reemplazada por collections.PQ_NOTACREDITO_AUTOMATICA.P_NCDevolucion_SolotAnulada
   6.0        10/09/2009  Antonio Lagos    Se agrego tipo de estado rechazado para generar una NC y se hizo configurable
                                           a que conceptos aplica.
   7.0        14/07/2010  Edson Caqui      Req.136446
   8.0        10/08/2010  Miguel Aroñe     Req 114326,101786,104205 de cortes y reconexiones
   9.0        18/08/2010  Alexander Yong   REQ-136708: Generación de N/C automáticas.
   10.0       21/10/2010  Luis PATIÑO      CORTES Y RECONEXIONES req:129858.
   11.0       04/03/2011  Miguel Aroñe     REQ 101786 Cortes/reconexiones telefonia fija, tpi y telmex negocio
   12.0       01/02/2013  Alfonso Perez    REQ 163839 Cierre de Facturación
   13.0       09/05/2013  Edson Caqui      Jimmy Cruzatte    REQ. NC en OAC
   14.0       01/08/2013  Edilberto Astulle PQT-141358-TSK-21430
   15.0       30/03/2014  Jorge Armas      PROY-12756 IDEA-13013-Implemen mej. de cód.de activac. HFC y borrado de reservas en IWAY
   16.0       16/04/2015  Juan Gonzales    SD-507517  - Regularizacion Anulación de SOT   
  ******************************************************************************************************************/
DECLARE

  fec_actual        date;
  ll_cantidad       number;
  dias_plazo        number;
  l_idwf            wf.idwf%type;
  V_CCARE           varchar2(30);
  v_anulada         number(1);
  v_codsolot        solot.codsolot%type := :new.codsolot;
  v_datos_auto      number;
  v_idtareawf       tareawf.idtareawf%type;
  v_idwf            tareawf.idwf%type;
  v_tarea           tareawf.tarea%type;
  v_tareadef        tareawf.tareadef%type;
  v_tipo_est_sol    estsol.tipestsol%type;
  v_tipo_est_old    estsol.tipestsol%type;
  --ini 8.0
  ln_contador number(5) := 0;
  --fin 8.0
  --Ini 9.0
  ln_count_tiptra number;
  --Fin 9.0
  ln_num1  number; --10.0;
  --<INI 12.0>
  ln_idtrans     number;
  lc_resultado   varchar2(100);
  lc_mensaje     varchar2(100);
  --<FIN 12.0>
  --INI 13.0
  V_RESULTADO      NUMBER;
  V_MENSAJE        VARCHAR2(3000);
  --FIN 13.0
  --INI 15.0
  l_iway_tip_rech NUMBER;
  l_iway_est_rxs NUMBER;
  --FIN 15.0  

  BEGIN

  --Estado Anulado
  IF :OLD.ESTSOL = 13 then
    /*IF UPDATING('CODCLI') then -- g.ormeno
       null;
    else*/
    raise_application_error(-20500,
                            'No se pudo modificar una solicitud que ya ha sido anuldada.');
    /*end if;*/
  END IF;

  fec_actual := sysdate;

  if UPDATING('ESTSOL') then
    --Codigo para recalcular la fecha de compromiso cuando se apruebe por primera vez
    if pq_constantes.F_GET_CFG = 'PER' then
      if :new.estsol = 11 then
        begin
          select nvl(count(*), 0)
            into ll_cantidad
            from SOLOTCHGEST
           where codsolot = :new.codsolot
             and estado = 11;
          if ll_cantidad = 0 and :new.numslc is not null then
            select nvl(diacom, 0)
              into dias_plazo
              from vtatabpspcli_v
             where numslc = :new.numslc
               and rownum = 1;
            if dias_plazo > 0 then
              :new.feccom := f_add_dias_utiles(sysdate, dias_plazo);
            end if;
          end if;
        exception
          when others then
            null;
        end;
      end if;
    end if;
    /*Linea Comentada el 01/09/2008 */
    /*if :new.estsol in (12,13,15) then
     update solotpto aa
        set aa.flg_agenda = 0
      where aa.codsolot = :new.codsolot
        and aa.flg_agenda = 1;
    end if;*/

    select e.tipestsol
      into v_tipo_est_sol
      from estsol e
     where e.estsol = :new.estsol;

    --Cambia el flag agenda por el tipo de estado
    if v_tipo_est_sol in (3, 4, 5, 7) then
      update solotpto aa
         set aa.flg_agenda = 0
       where aa.codsolot = :new.codsolot
         and aa.flg_agenda = 1;
    end if;

    --<12.0>
    if v_tipo_est_sol = 7 then
       if ATCCORP.PQ_TRS_CP_ATC.f_valida_sot(:new.codsolot) = 1 then
          ATCCORP.PQ_TRS_CP_ATC.p_anula_baja_cp(:new.codsolot,
                                                     ln_idtrans,
                                                     lc_resultado,
                                                     lc_mensaje)    ;
       end if;
    end if;
    --<12.0>

    -- Modificado 19/09/20008 por GORMEÑO/MBALCAZAR  : Inicio
    -- Cargamos el flag_agenda cuando regrese a estado "En Ejecución"
    select e.tipestsol
      into v_tipo_est_old
      from estsol e
     where e.estsol = :old.estsol;

    select count(*)
      into v_datos_auto
      from tareawf t, wf
     where t.tareadef = 671
       and t.idwf = wf.idwf
       and wf.codsolot = :new.codsolot
       and wf.valido = 1;

    if (v_datos_auto > 0) then
      if :new.estsol = 17 and v_tipo_est_old in (3, 4, 5, 7) then

        select t.idtareawf, t.idwf, t.tarea, t.tareadef
          into v_idtareawf, v_idwf, v_tarea, v_tareadef
          from tareawf t, wf
         where t.tareadef = 671
           and t.idwf = wf.idwf
           and wf.codsolot = :new.codsolot
           and wf.valido = 1;

        operacion.pq_cuspe_ope.p_workflowautomatico(v_idtareawf,
                                                    v_idwf,
                                                    v_tarea,
                                                    v_tareadef);

      end if;
    end if;
    -- Modificado 19/09/20008 por GORMEÑO/MBALCAZAR  :Fin

    if :new.ESTSOL <> :old.ESTSOL then
      -- Es un cambio de estado valido
      /*Linea comentada el 02/08/2004.
                insert into SOLOTCHGEST (codsolot,tipo, estado, fecha)
                values (:NEW.codsolot,1,:NEW.ESTSOL,fec_actual);
      */

      --ini 15.0
     SELECT  t2.tipestsol, t3.codigon
       into l_iway_tip_rech, l_iway_est_rxs
        FROM tipopedd t1, estsol t2 , opedd t3
       WHERE t3.abreviacion = 'RECH_X_SIS'
         AND t3.codigoc = 'ACTIVO'         
         AND t1.abrev='MANT_IWAY_HFC'
         AND t2.estsol = :old.estsol
         AND t1.tipopedd = t3.tipopedd;
          
       if :old.estsol not in (l_iway_est_rxs) then -- 16.0
         :new.fecultest := fec_actual;
      end if;
      --fin 15.0

      -- APROBACION
      --si es aprobado se actualiza la fecha
      if :new.ESTSOL = 11 then
        :new.fecapr := sysdate;
        --:new.estsolope := 1; -- solot como ejecucion
        if :new.codcli is null then
          RAISE_APPLICATION_ERROR(-20500, 'No se especifico el cliente.');
        end if;

        -- Se intenta asignar el WF automaticamente
        begin
          null;
          --l_wfdef := CUSBRA.F_BR_SEL_WF(:new.codsolot);
          --PQ_WF.P_ASIG_WF  ( :new.codsolot, l_wfdef, l_idwf );
        exception
          when others then
            :new.observacion := nvl(:new.observacion, '') || SQLerrm;
        end;

      end if;
      if :new.ESTSOL = 17 and :old.estsol = 10 then
        :new.fecapr := sysdate;
        if :new.fecini is null then
          :new.fecini := sysdate;
        end if;
      end if;

      --ini 8.0
      --Se valida si la sot esta asociada a una transaccion
      if :new.estsol = 12
          or :new.estsol = 29 then --10.0
        --cerrada
        --PQ_CXC_CORTE.p_cierra_transaccion(:new.codsolot);--14.0
        collections.PQ_OAC.p_cierra_transaccion(:new.codsolot);--14.0
      end if;

      --<inicio 10.0
      select  count(1) into ln_num1
      from tipestsol a, estsol b
      where b.estsol=:new.estsol
      and a.tipestsol = b.tipestsol
      and a.tipestsol in (5,7); --anula o rechazo

      if ln_num1> 0 then
         update int_solot_itw
         set estado = 4
         where codsolot=:new.codsolot;
      end if;
      --fin 10.0>

      --Se valida si la sot se esta cambiando a un estado anulado
      select count(1)
        into ln_contador
        from estsol e, tipestsol t
       where e.tipestsol = t.tipestsol
         and e.estsol = :new.estsol
         and t.tipestsol in(5,7); --anulado --11.0 (se agrego 7 - rechazado)

      if ln_contador > 0 then
        --PQ_CXC_CORTE.p_sot_transaccion_anulada(:new.codsolot);--14.0
        collections.PQ_oac.p_sot_transaccion_anulada(:new.codsolot);--14.0
      end if;
      --fin 8.0

      -- ANULADO
      -- Si se anula la solicitud se anulan las OTs
      IF :NEW.ESTSOL = 13 then
        update ot
           set estot = 5
         where codsolot = :new.codsolot
           and estot not in (4, 5);

        -- Se intenta asignar el WF automaticamente
        begin
          select idwf
            into l_idwf
            from wf
           where codsolot = :new.codsolot
             and valido = 1;
          PQ_WF.P_CANCELAR_WF(l_idwf);
        exception
          when no_data_found then
            -- No se encontro un wf
            null;
          when others then
            raise;
        end;

      end if;

      --INI 13.0
      SELECT COUNT(1)
        INTO V_ANULADA
        FROM ESTSOL
       WHERE ESTSOL = :NEW.ESTSOL
         AND TIPESTSOL = 5;
      IF :NEW.TIPTRA IN (1, 404, 419) THEN
        LN_COUNT_TIPTRA := 1;
      END IF;
      --SI LA SOT SE ANULA Y PERTENECE A LOS TIPOS DE TRABAJO INSTALACION
      IF V_ANULADA > 0 AND LN_COUNT_TIPTRA > 0 THEN

          COLLECTIONS.PQ_CXC_NOTACREDITO.P_NC_MAIN(2,--TIPO
                                                 3,--SUBTIPO
                                                 NULL,--INCIDENCIA
                                                 NULL,--CODSOLOT -- 13.1
                                                 :new.numslc,--OTRO --13.1
                                                 '0701',--SERIE --13.1
                                                 V_RESULTADO,
                                                 V_MENSAJE);

      END IF;
      --FIN 13.0

      if :new.ESTSOL = 17 then
        -- 30/10/2007 Luigi Torres

        V_CCARE := NULL;

        IF :NEW.tiptra = 368 OR :NEW.tiptra = 369 THEN
          SELECT NVL(CODCCAREUSER, NULL)
            INTO V_CCARE
            FROM CUSTOMER_ATENTION
           WHERE CUSTOMERCODE = :NEW.CODCLI;

          IF (V_CCARE IS NULL AND :NEW.CODCLI IS NOT NULL) THEN
            update CUSTOMER_ATENTION
               set CODCCAREUSER = 'CEXPLORA'
             WHERE CUSTOMERCODE = :NEW.CODCLI;

          END IF;
        END IF;
      end if;

    end if;
  end if;

  -- Informacion del Proyecto
  if UPDATING('NUMSLC') then
    if :new.numslc is not null then
      begin
        select codcli
          into :new.codcli
          from vtatabslcfac
         where numslc = :new.numslc;
      exception
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20500, 'Numero de proyecto invalido.');
      end;
    end if;
  end if;
END;
/
