CREATE OR REPLACE PROCEDURE OPERACION.P_GENERA_RXCABLE IS
  /******************************************************************************
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        19/11/2008  Hector Huaman M.  Genera SOT de Reconexion de forma automática
                                              con la fecha indicada por el cliente(en la SOT de suspensión)
     2.0        24/02/2009  José Ramos M.     Se cambia el tipo de trabajo para que Genere SOTs con tipo de trabajo
                                              TELMEX TV- RECONEXIÓN TRIPLE PLAY POR FALTA DE PAGO y no con tipo de trabajo
                                              TELMEX TV- RECONEXIÓN DE SERVICIO, que es para Servicio TV Cable.
     3.0        05/04/2013  Juan Mendoza      PROY-7433 IDEA-5497 Traslados Externos
     4.0        12/05/2014  Edilberto Astulle SD_1064022  Casos de ingreso de material por defecto en SOTs de Mantenimiento
     5.0        14/04/2016  Edilberto Astulle SD_868970
  ******************************************************************************/
  l_fecpend     reconexion_apc.fecrec%type;
  l_fecrec      reconexion_apc.fecrec%type;
  l_codsolotsus solot.codsolot%type;
  l_codsolotrx  solot.codsolot%type;
  l_cant_ins    solotpto.codinssrv%type;--3.0
  l_cant_ins_baja solotpto.codinssrv%type;--3.0
  l_cantidad  number(2);
  n_tiptra number;--5.0
  v_tipsrv solot.tipsrv%type;--5.0
  v_tipsrvori solot.tipsrv%type;--5.0
  n_areasol number;--5.0
  cursor cursor_pendientes is
    select * from reconexion_apc r where r.flg_procesado = 0;

  cursor cur_servicios is
    select *
      from solotpto
     where codsolot = l_codsolotsus
     order by punto asc;

BEGIN
  l_fecpend := trunc(sysdate);
  for c1 in cursor_pendientes loop
    BEGIN
      select tipsrv into v_tipsrvori from solot where codsolot=c1.codsolot;--5.0
      l_fecrec := c1.fecrec;
      --Ini 3.0
     select count(1) servicios
       into l_cant_ins
       from inssrv
      where codinssrv in
            (select codinssrv from solotpto where codsolot = c1.codsolot);

      select count(1)
        into l_cant_ins_baja
        from inssrv
       where codinssrv in
             (select codinssrv from solotpto where codsolot = c1.codsolot)
           and estinssrv = 3;

        if l_cant_ins <> l_cant_ins_baja then
        -- goto salto;
          --Inicio 4.0
          if l_fecpend >= l_fecrec then          -- Para que el tome registros con fecrec anteriores
              l_codsolotrx := F_GET_CLAVE_SOLOT();
              if v_tipsrvori='0073' then--5.0
                n_tiptra:=445;
                v_tipsrv:=v_tipsrvori;
                n_areasol:=100;
              else
                n_tiptra:=443;
                v_tipsrv:='0061';
                n_areasol:=202;
              end if;
              insert into solot
                (codsolot,
                 codcli,
                 estsol,
                 tiptra,
                 tipsrv,
                 grado,
                 codmotot,
                 areasol)
              values
                (l_codsolotrx, c1.codcli, 11, n_tiptra, v_tipsrv, 1,12, n_areasol);--5.0
              l_codsolotsus := c1.codsolot;
              for c_serv in cur_servicios loop
                begin
                  insert into solotpto
                    (codsolot,
                     punto,
                     codsrvnue,
                     bwnue,
                     codinssrv,
                     cid,
                     descripcion,
                     direccion,
                     tipo,
                     estado,
                     visible,
                     codubi,
                     flgmt)
                  values
                    (l_codsolotrx,
                     c_serv.punto,
                     c_serv.codsrvnue,
                     c_serv.bwnue,
                     c_serv.codinssrv,
                     c_serv.cid,
                     c_serv.descripcion,
                     c_serv.direccion,
                     c_serv.tipo,
                     c_serv.estado,
                     c_serv.visible,
                     c_serv.codubi,
                     c_serv.flgmt);
                end;
              end loop;

              update reconexion_apc
                 set flg_procesado = 1,
                     fec_proceso   = sysdate,
                     codsolotrx    = l_codsolotrx
               where codsolot = l_codsolotsus;
            ---Atender la SOT de Reconexión
            OPERACION.PQ_SOLOT.p_ejecutar_solot(l_codsolotrx);
            -- Obtengo la tarea de Agendamiento de la SOT de reconexiòn
           operacion.p_ejecuta_activ_desactiv(l_codsolotrx,299,sysdate);
           end if;

        else
          -- goto salto1;
            select count(flg_procesado)
              into l_cantidad
              from reconexion_apc
             where codsolot = c1.codsolot and
            flg_procesado = 0 ;
            if l_cantidad > 0 then
              update reconexion_apc
              set flg_procesado = 1,
              fec_proceso   = sysdate
              where codsolot = c1.codsolot and
              flg_procesado = 0;
            end if;
            --Fin 4.0
        end if;
      end loop;
  end loop;

END;
/