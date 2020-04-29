CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_HFC_ALINEACION IS

  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_HFC_ALINEACION
   PROPOSITO:    Paquete de objetos necesarios para realizar alineación SGA - IW - BSCS - JANUS
   REVISIONES:
   Version    Fecha       Autor               Solicitado por    Descripcion
   ---------  ----------  ---------------     --------------    -----------------------------------------
    1.0       04/11/2015  Stephanie Aguilar
    2.0       28/04/2016                                        SD-642508-1 Cambio de Plan Fase II
    3.0       07/12/2016  Servicio Fallas-HITSS		        SD_1040408
    4.0       26/07/2017  Servicio Fallas-HITSS                 INC000000856062
  *******************************************************************************************************/
  function f_valida_sga_xservicio(an_numero in varchar2,
                                  an_cod_id in number,
                                  an_valores_iw in varchar2,
                                  an_tservicio in varchar2,
                                  an_tatributo in varchar2) return number is

  ln_val_iw number;
  valores_sga varchar2(100);
  av_mensaje varchar2(2000);
  begin

     SELECT nvl((T.CUSTOMER_ID||'-'||I.ID_PRODUCTO||'-'||I.ID_PRODUCTO_PADRE),null)
            INTO valores_sga
     FROM operacion.trs_interface_iw I, SOLOT T,OPERACION.TRS_INTERFACE_IW_DET D
     WHERE I.IDTRS = D.IDTRS
           AND T.CODSOLOT = I.CODSOLOT
           AND D.VALOR= an_numero
           AND T.cod_id = an_cod_id
           AND tip_interfase = an_tservicio
           AND D.ATRIBUTO = an_tatributo
           AND ROWNUM=1;

     IF an_valores_iw = valores_sga THEN
        ---valores iw y sga iguales OK
        ln_val_iw:= 1;
     ELSE
        ---valores iw y sga NO iguales Error
        ln_val_iw:= 0;
     END IF;

     return ln_val_iw;

   exception
     when others then
         ln_val_iw     := 0;
         av_mensaje := 'Error' || SQLERRM;
         return ln_val_iw;
  end;

  function f_valida_bscs_xservicio(an_numero in varchar2,
                                   an_cod_id IN number,
                                   an_valores_iw in varchar2,
                                   an_tservicio in varchar2) return number is

  ln_val_iw number;
  valores_bscs varchar2(100);

  begin

     SELECT nvl((c.customer_id || '-' || s.id_producto || '-' ||
                s.id_producto_padre),
                null)
       INTO valores_bscs
       FROM tim.pf_hfc_datos_serv@dbl_bscs_bf s, contract_all@dbl_bscs_bf c
      WHERE c.co_id = s.co_id
        AND c.co_id = an_cod_id
        AND s.tipo_serv = an_tservicio
        AND ROWNUM = 1;
     COMMIT;

     IF an_valores_iw = valores_bscs THEN
       ---valores iw y bscs iguales OK
       ln_val_iw := 1;
     ELSE
       ---valores iw y bscs NO iguales Error
       ln_val_iw := 0;
     END IF;

     return ln_val_iw;

     exception
     when others then
     ln_val_iw     := 0;

     return ln_val_iw;
  end;

  procedure p_valida_tlf_iw(an_numero IN VARCHAR2,
                            an_cod_id IN number,
                            tipo_linea IN NUMBER,
                            an_out     out number,
                            av_mensaje out varchar2) is

    l_clientecrm varchar2(50);
    l_idproducto number;
    l_idproductopadre number;
    l_out2         number;
    l_mens         varchar2(150);
    l_idprodpadre  number;
    l_idventpadre  number;
    l_macadd       varchar2(150);
    l_modelmta     varchar2(150);
    l_profile      varchar2(150);
    l_activcode    varchar2(150);
    l_central varchar2(150);

    an_valores_iw varchar2(100);
    ln_val_iw_sga number;
    ln_val_iw_bscs number;

    an_error number;
    av_error varchar2(1000);

   begin
    --obtener customerid de iw
     --Ini 4.0
     INTRAWAY.PQ_MIGRASAC.P_TRAE_IDPRODUCTO(an_numero, l_idproducto, l_idproductopadre, l_clientecrm);
     --Fin 4.0

     an_valores_iw:=l_clientecrm||'-'||l_idproducto||'-'||l_idproductopadre;
     ln_val_iw_sga:=f_valida_sga_xservicio(an_numero,an_cod_id,an_valores_iw,'TEP','TN'); --VALIDAR IW - SGA
     ln_val_iw_bscs:=f_valida_bscs_xservicio(an_numero,an_cod_id,an_valores_iw,'TEP'); --VALIDAR IW - BSCS

     IF ((tipo_linea=1 AND ln_val_iw_sga = 1) OR (tipo_linea=2 AND ln_val_iw_bscs = 1 AND ln_val_iw_sga = 1)) THEN
         /* --consultado si el cliente se encuentra activo
          intraway.pq_consultaitw.p_int_consultamta(l_clientecrm,
                                                    l_idproductopadre,
                                                    0,
                                                    l_out2,
                                                    l_mens,
                                                    l_idprodpadre,
                                                    l_idventpadre,
                                                    l_macadd,
                                                    l_modelmta,
                                                    l_profile,
                                                    l_activcode,
                                                    l_central);
           --Validar si Existe MacAddres
           IF NVL(l_macadd,NULL) IS NOT NULL THEN*/
              an_out:=1;
              av_mensaje:=l_mens;
          -- END IF;
     ELSE
       --- DATOS NO CORRECTOS IW-SGA
       IF ln_val_iw_sga = 0 and tipo_linea=1 THEN
          p_reg_numero_noalineado(an_numero,an_cod_id,'TEP','SGA','Nro Telefonico no Alineado',an_error,av_error);
          an_out:=0;
          av_mensaje:='Registro Error';
       END IF;

       --- DATOS NO CORRECTOS IW-BSCS
       IF ln_val_iw_bscs = 0 and tipo_linea=2 THEN
          p_reg_numero_noalineado(an_numero,an_cod_id,'TEP','BSCS','Nro Telefonico no Alineado',an_error,av_error);
          an_out:=0;
          av_mensaje:='Registro Error';
       END IF;

     END IF;


    EXCEPTION
      WHEN OTHERS THEN
        an_out:=-1;
        av_mensaje := 'Error' || SQLERRM;

   end;

   PROCEDURE p_regulariza_numero(an_cod_id IN number,
                                 an_numero IN VARCHAR2,
                                 lv_tn_bscs IN VARCHAR2,
                                 tipo_linea IN NUMBER,
                                 an_error OUT INTEGER,
                                 av_error OUT VARCHAR2)
  IS
    num_requerido varchar2(8);
    num_antiguo varchar2(8);
    an_out number;
    av_mensaje varchar2(1000);
    an_codsolot number;

    ln_out_janus         number;
    lv_mensaje_janus     varchar2(500);
    lv_customer_id_janus varchar2(20);
    ln_codplan_janus     number;
    lv_producto_janus    varchar2(100);
    ld_fecini_janus      date;
    lv_estado_janus      varchar2(20);
    lv_ciclo_janus       varchar2(5);
    ln_alinea            number;
    lv_mensaje           varchar2(500);
    ln_parametro         number;
    ln_codinssrv         number;
  BEGIN
      --Tipo de Línea : tipo_linea = 1 (SGA)  / 2 (BSCS)
    if trim(an_numero) != trim(lv_tn_bscs) then

      --VALIDAR QUE NRO SGA ESTE ACTIVO EN IW
      p_valida_tlf_iw(an_numero,an_cod_id,tipo_linea,an_out,av_mensaje);

      ---NRO SGA ESTA ACTIVO EN IW
      IF an_out = 1 THEN

          num_requerido := an_numero; --->> Nro SGA
          num_antiguo := lv_tn_bscs; --->>  Nro BSCS

          --ALINEAR LINEA BSCS (SISACT)
          IF tipo_linea = 2 THEN
             --1 Alineación Nro BSCS y SGA
              p_alinea_numero_bscs_sga(an_cod_id,num_requerido,num_antiguo,an_error,av_error);
              if an_error = 1 then
                 --Actualiza en tablas BSCS despues del 1
                 p_update_bscs(an_cod_id,num_requerido,an_error,av_error);
              end if;

              av_error := 'OK';
          END IF;

          select to_number(c.valor) into ln_parametro
          from constante c where c.constante = 'PARVALJANUSBSCS';

          if ln_parametro = 1 then
            --Validar si número existe en JANUS
            operacion.pq_cont_regularizacion.p_valida_linea_janus(num_requerido,an_error,av_error);
            if an_error = 0 then ---No existe en Janus
               av_error:='Ejecutar ALTA del número en JANUS ';
            else ---Si existe en Janus
               --Obtener datos janus
               operacion.pq_sga_janus.p_valida_linea_bscs_sga(an_codsolot, 'INIFAC',an_error,av_error);
               if an_error = 0 then
                 av_error:='Ejecutar BAJA y ALTA del numero en JANUS';
               elsif an_error = 1 then
                 av_error:='Numero Alineado en JANUS';
               end if;
            end if;
          end if;

          an_error:=1;

         else
           -- Validamos si la linea telefonica de BSCS lo tiene en IW el cliente
           p_valida_tlf_iw(lv_tn_bscs,an_cod_id,tipo_linea,an_out,av_mensaje);

           if an_out = 1 then
             begin
               select nvl(max(ins.codinssrv), 0) into ln_codinssrv
               from solot s, solotpto pto, inssrv ins
               where s.codsolot = pto.codsolot
               and pto.codinssrv = ins.codinssrv
               and ins.tipinssrv = 3
               and ins.numero = an_numero
               and s.cod_id = an_cod_id
               and ins.estinssrv in (1, 2, 4);

               if ln_codinssrv != 0 then
                 update numtel n set n.codinssrv = ln_codinssrv, n.estnumtel = 2
                 where n.numero = lv_tn_bscs;

                 update inssrv i set i.numero = lv_tn_bscs
                 where i.codinssrv = ln_codinssrv;
               end if;
               an_error := 1;

             exception
               when others then
                 an_error := -1;
             end;
           end if;
         end if;
      end if;
  EXCEPTION
    WHEN OTHERS THEN
      an_error:=-1;
      av_error := 'Error' || SQLERRM;
  END;

  procedure p_alinea_numero_bscs_sga(an_cod_id IN number,
                                     an_numero_sga IN VARCHAR2,
                                     lv_tn_bscs IN VARCHAR2,
                                     an_error OUT INTEGER,
                                     av_error OUT VARCHAR2) is
   existe number;
   dn_id_nuevo number;
   dn_id_A number;
   dn_id_B number;
   c_cod_id number;
   dn_num_B  varchar2(100);
   c_num_sga number;
   ln_existe_ccs number;

  begin
      IF ((length(an_numero_sga) <> 8)) or (an_numero_sga is null) then
          an_error:=-1;
          av_error := 'Error el número SGA debe tener ocho dígitos';
          return;
      end if;

      IF (length(lv_tn_bscs) <> 8) then
          an_error:=-1;
          av_error := 'Error el número BSCS debe tener ocho dígitos';
          return;
      end if;

      IF((length(an_numero_sga))=8) and (an_numero_sga <> lv_tn_bscs) THEN

            begin
                select count(0)into existe
                from directory_number@dbl_bscs_bf d
                where d.dn_num=an_numero_sga;

                -- Validar si el número_sga existe en DIRECTORY_NUMBER en BSCS
                IF(existe=0)THEN
                    --Número NO existe en DIRECTORY_NUMBER -> Se registra  en BSCS
                    tim.tim120_reg_nro_fijo@dbl_bscs_bf(an_numero_sga, dn_id_nuevo);

                    IF dn_id_nuevo > 0 THEN

                      ln_existe_ccs := operacion.pq_cont_regularizacion.f_val_existe_contract_sercad(an_cod_id);

                      if ln_existe_ccs = 0 then
                          --Número no existe -> Se registra en CONTR_SERVICES_CAP en BSCS
                         operacion.pq_sga_bscs.p_reg_contr_services_cap(an_cod_id,an_numero_sga,an_error,av_error);
                         IF an_error = 1 THEN
                            an_error:=an_error;
                            av_error:='Se registro número SGA en BSCS ';

                         ELSE
                           an_error:=0;
                           av_error:= 'Número no registro ' || av_error;
                           rollback;
                         END IF;
                       else
                         update contr_services_cap@dbl_bscs_bf ct
                         set ct.dn_id = dn_id_nuevo
                         where ct.co_id = an_cod_id
                         and nvl(ct.cs_deactiv_date,null) is null
                         and ct.seqno=(select max(cs.seqno)
                                         from contr_services_cap@dbl_bscs_bf cs where cs.co_id = ct.co_id);

                         update directory_number@dbl_bscs_bf d
                         set d.dn_status = 'a'
                         where d.dn_id = dn_id_nuevo;

                       end if;
                    END IF;

                    COMMIT;

                ELSE
                  --Número_sga SI existe en DIRECTORY_NUMBER
                  --Obtener dn_id asociado al número_sga
                  SELECT d.dn_id into dn_id_A
                  FROM directory_number@dbl_bscs_bf d
                  WHERE d.dn_num=an_numero_sga;

                  --Obtener dn_id en CONTR_SERVICES_CAP por cod_id(sga)
                  SELECT ct.dn_id into dn_id_B
                  FROM CONTR_SERVICES_CAP@dbl_bscs_bf ct
                  WHERE ct.co_id = an_cod_id AND nvl(ct.cs_deactiv_date,null) is null
                  AND ct.seqno=(SELECT max(cs.seqno)
                                FROM CONTR_SERVICES_CAP@dbl_bscs_bf cs WHERE cs.co_id = an_cod_id);

                  --Validar DN_ID en DIRECTORY_NUMBER y CONTR_SERVICES_CAP
                  IF dn_id_A != dn_id_B THEN
                         ---Actualizar dn_id_A en CONTR_SERVICES_CAP
                         UPDATE CONTR_SERVICES_CAP@dbl_bscs_bf ct
                         SET ct.dn_id = dn_id_A
                         WHERE ct.co_id = an_cod_id AND nvl(ct.cs_deactiv_date,null) is null
                         AND ct.seqno=(SELECT max(cs.seqno)
                                       FROM CONTR_SERVICES_CAP@dbl_bscs_bf cs WHERE cs.co_id = ct.co_id);

                         --Actualiza status de dn_id_A
                         UPDATE directory_number@dbl_bscs_bf d
                         SET d.dn_status = 'a'
                         WHERE d.dn_id=dn_id_A;

                         ---Validar si dn_id_A tiene solo un contrato activo en CONTR_SERVICES_CAP
                         SELECT count(ct.co_id) into c_cod_id
                         FROM CONTR_SERVICES_CAP@dbl_bscs_bf ct
                         WHERE ct.dn_id = dn_id_A and NVL(ct.cs_deactiv_date,null) is not null;

                         IF c_cod_id != 0 THEN
                            ---ACTUALIZAR LA FECHA DESACTIVACION
                            UPDATE CONTR_SERVICES_CAP@dbl_bscs_bf ct
                            SET CT.cs_deactiv_date = (SELECT CH.CH_VALIDFROM FROM CONTRACT_HISTORY@dbl_bscs_bf CH
                                                      WHERE CH.CO_ID = ct.co_id AND  upper(CH.CH_STATUS)=upper('d'))
                            WHERE ct.dn_id = dn_id_A ;
                         END IF;

                         ---Obtener DN_num en DIRECTORY_NUMBER de dn_id_B
                         SELECT d.dn_num into dn_num_B
                         FROM directory_number@dbl_bscs_bf d
                         WHERE d.dn_id=dn_id_B;

                         ---Validar dn_num_B en SGA
                         SELECT count(i.codinssrv) INTO c_num_sga
                         FROM operacion.inssrv i WHERE i.numero = dn_num_B and i.estinssrv != 3;

                         --Si NO existe dn_num_B en SGA actualizar status a 'r' en DIRECTORY_NUMBER
                         IF c_num_sga = 0 THEN
                            UPDATE directory_number@dbl_bscs_bf d
                            SET d.dn_status = 'r'
                            WHERE d.dn_num=dn_num_B;

                         END IF;

                  END IF;

                   an_error:=1;
                   av_error:='Número SGA alineado en BSCS';
                   COMMIT;
                END IF;

          end;
       end if;

    EXCEPTION
    WHEN OTHERS THEN
    an_error:=-1;
    av_error := 'Error' || SQLERRM;
  end;

  procedure p_update_bscs(an_cod_id IN number,
                          an_numero_sga IN VARCHAR2,
                          an_error OUT INTEGER,
                          av_error OUT VARCHAR2) is
  begin
     update tim.pf_hfc_datos_serv@dbl_bscs_bf p
     set campo05=an_numero_sga
     where co_id=an_cod_id and tipo_serv='TEP';

     COMMIT;
     an_error:=1;
     av_error := 'OK';

    EXCEPTION
    WHEN OTHERS THEN
    an_error:=-1;
    av_error := 'Error' || SQLERRM;

  end;

    procedure p_reg_numero_noalineado(an_numero IN VARCHAR2,
                                      an_cod_id IN number,
                                      an_tservicio varchar2,
                                      an_tipo_noalineado IN VARCHAR2,
                                      an_observacion IN VARCHAR2,
                                      an_error OUT INTEGER,
                                      av_error OUT VARCHAR2) is
     ln_alineado number;
  begin

     SELECT operacion.sq_numero_noalineado.nextval INTO ln_alineado FROM dual;

     INSERT INTO OPERACION.NUMERO_NOALINEADO(ID_ALINEADO,TIPO_NOALINEADO,COD_ID,NUMERO,TSERVICIO,OBSERVACION)
     VALUES (ln_alineado,an_tipo_noalineado,an_cod_id,an_numero,an_tservicio,an_observacion);

     an_error := 1;
     av_error := 'OK';
     commit;
   exception
    when others then
      an_error := -1;
      av_error := 'Error al Insertar número no Alineado : '|| sqlerrm;

  end;

  PROCEDURE p_cargar_bscs_tabhfc
  is
  l_var1 number;

    cursor cur1 is
     SELECT tb.dn_num,tb.numero,tb.customer_id,th.co_id,th.ciclo from operacion.tab_hfc_alineacion th, operacion.tab_contract_bscs tb
     WHERE  
          th.co_id = tb.co_id
          AND th.idproducto =  943
          AND th.estinssrv IN (SELECT op.codigon FROM operacion.tipopedd td , operacion.opedd op WHERE td.tipopedd=op.tipopedd AND td.abrev = 'EST_LINEA');

  begin

    for c1 in cur1 loop

       UPDATE operacion.tab_hfc_alineacion b
           SET  
              b.ciclo=c1.ciclo, 
              b.customer=c1.customer_id,
              b.numero_bscs=c1.dn_num,
              b.numero=c1.numero
       WHERE b.co_id = c1.co_id;

      l_var1 := l_var1 + 1;

      if l_var1 = 1000 then
        l_var1 := 0;
        commit;
      end if;
    end loop;
    commit;

  END ;

  PROCEDURE p_carga_db_hfc is

  l_var1 number;
  l_var2 number;
  l_var3 number;
 -- l_var4 number;
  v_unico number;
  l_sql varchar2(100);

  cursor cur1 is
        SELECT i.codcli, i.tipsrv, i.codsrv,t.idproducto, i.codinssrv,i.estinssrv, i.numero, i.numsec,
          (SELECT q.plan from tystabsrv ty, plan_redint q WHERE ty.codsrv = i.codsrv AND ty.idplan = q.idplan) codplan_b,
          (SELECT op.codigon_aux FROM operacion.tipopedd td , operacion.opedd op  WHERE td.tipopedd=op.tipopedd AND td.abrev = 'tip_producto' AND op.codigon=p.idproducto) flg_sistema                                                                                                                                      
        FROM inssrv i, tystabsrv t, producto p
        WHERE i.codsrv = t.codsrv
        AND t.idproducto = p.idproducto
        AND i.tipinssrv=3
        AND i.estinssrv IN (SELECT op.codigon FROM operacion.tipopedd td , operacion.opedd op WHERE td.tipopedd=op.tipopedd AND td.abrev = 'EST_LINEA')
        AND p.idproducto IN (SELECT op.codigon FROM operacion.tipopedd td , operacion.opedd op
                             WHERE td.tipopedd=op.tipopedd AND td.abrev = 'tip_producto' );

   cursor cur2 is
        select a.numero, count(*) from operacion.tab_hfc_alineacion a
        where a.numero is not null
        group by a.numero
        having count(*)=1;

   cursor cur3 is
        select a.numero, count(*) from operacion.tab_hfc_alineacion a
        where a.numero is not null 
        group by a.numero
        having count(*)>1;

   cursor cur3a (p_numero in operacion.inssrv.numero%type) is
        select a.estinssrv, max(a.codinssrv) codinssrv from operacion.tab_hfc_alineacion a
        where a.numero=p_numero
        group by a.estinssrv order by a.estinssrv;

   cursor cur5 is
      SELECT i.codinssrv,s.cod_id, s.customer_id, max(s.codsolot) codsolot
      FROM solot s, solotpto p, inssrv i
      where 
          s.codsolot=p.codsolot
      and p.codinssrv = i.codinssrv
      and i.tipinssrv = 3
      and s.estsol in (SELECT op.codigon FROM operacion.tipopedd td , operacion.opedd op WHERE td.tipopedd=op.tipopedd AND td.abrev = 'ESTSOL_AL')
      and s.tiptra in (SELECT op.codigon FROM operacion.tipopedd td , operacion.opedd op WHERE td.tipopedd=op.tipopedd AND td.abrev = 'tiptra_AL' )
      and exists (select th.codinssrv from operacion.tab_hfc_alineacion th where th.codinssrv= p.codinssrv)
      and s.cod_id is not null and s.customer_id is not null 
      group by i.codinssrv,s.cod_id, s.customer_id;

   cursor cur6 (p_codinssrv in operacion.tab_hfc_alineacion.codinssrv%type,p_codsolot in operacion.tab_hfc_alineacion.codsolot%type) is
      SELECT               
        CASE WHEN th.idproducto = 766 THEN 
             operacion.pq_cont_regularizacion.f_get_ciclo_codinssrv(th.numero,p_codinssrv)
        ELSE
           '01'  END AS ciclo,
        CASE WHEN th.idproducto = 766 THEN 
             (9||th.codcli)
        WHEN  th.idproducto = 852 THEN  
             (SELECT ('P'||s.numslc) FROM solot s WHERE codsolot=p_codsolot and rownum=1)   
        ELSE
           '' END AS customer    
        FROM operacion.tab_hfc_alineacion th
      WHERE 
      th.codinssrv = p_codinssrv
      AND th.codsolot IS NOT NULL 
      AND th.numero IS NOT NULL; 

  BEGIN

  l_var1:=0;
  l_var2:=0;
  l_var3:=0;

  l_sql:= 'truncate table operacion.tab_hfc_alineacion';
  execute immediate l_sql;
  commit;

  for c1 in cur1 loop

      insert into operacion.tab_hfc_alineacion (codcli,tipsrv,codsrv,idproducto,codinssrv,estinssrv,numero,numsec,codplan_b,flg_sistema)
      values(c1.codcli,c1.tipsrv,c1.codsrv,c1.idproducto,c1.codinssrv,c1.estinssrv,c1.numero,c1.numsec,c1.codplan_b,c1.flg_sistema);

      l_var1:=l_var1+1;

      if l_var1=1000 then
         l_var1:=0;
         commit;
      end if;
  end loop;
  commit;

  for c2 in cur2 loop

      update operacion.tab_hfc_alineacion b set b.flg_unico=1 where b.numero=c2.numero;

      l_var2:=l_var2+1;

      if l_var2=1000 then
         l_var2:=0;
         commit;
      end if;
  end loop;
  commit;
 ---activas  1
 ---suspendidas 2
 ---canceladas
  for c3 in cur3 loop
      v_unico:=0;

      for c3a in cur3a(c3.numero) loop

        if c3a.estinssrv=1 and v_unico=0 then
           update operacion.tab_hfc_alineacion b set b.flg_unico=1 where b.codinssrv=c3a.codinssrv;
           v_unico:=1;
           commit;
        end if;
        if c3a.estinssrv=2 and v_unico=0 then
           update operacion.tab_hfc_alineacion b set b.flg_unico=1 where b.codinssrv=c3a.codinssrv;
           v_unico:=1;
           commit;
        end if;
        if c3a.estinssrv=4 and v_unico=0 then
           update operacion.tab_hfc_alineacion b set b.flg_unico=1 where b.codinssrv=c3a.codinssrv;
           v_unico:=1;
           commit;
        end if;
        if c3a.estinssrv=3 and v_unico=0 then
           update operacion.tab_hfc_alineacion b set b.flg_unico=1 where b.codinssrv=c3a.codinssrv;
           v_unico:=1;
           commit;
        end if;
      end loop ;

      l_var3:=l_var3+1;

      if l_var3=200 then
         l_var3:=0;
         commit;
      end if;
  end loop;
  commit;

      -- bucle que recorre todas las instancias
      for c5 in cur5 loop

         -- bucle que recorre cada instancia del servicio
         for c6 in cur6(c5.codinssrv,c5.codsolot) loop
           update operacion.tab_hfc_alineacion b
           set  
              b.co_id=c5.cod_id,
              b.ciclo=c6.ciclo, 
              b.customer=c6.customer,
              b.codsolot=c5.codsolot
           where b.codinssrv = c5.codinssrv;
         end loop ;
      end loop ;
      
      commit;
  ---Cargar datos de las tabla TAB_CONTRACT_BSCS
     OPERACION.PQ_HFC_ALINEACION.p_cargar_bscs_tabhfc;

 commit;
 END;

PROCEDURE p_cargar_dbjanus_payer IS
 V_FIN NUMBER;
 l_sql1 varchar2(100);
BEGIN
   V_FIN := 0;


  WHILE (V_FIN = 0) LOOP
    BEGIN

    declare
      l_var number;
      l_sql varchar2(100);

      cursor cur1 is
      select j.payer_id_n,j.external_payer_id_v,substr(j.external_payer_id_v,5) numero,j.payer_status_n status,
      (select substr(pb.bill_cycle_n,2,2) from janus_prod_pe.payer_bill_cycle_details@DBL_JANUS pb where pb.payer_id_n=j.payer_id_n) ciclo
      from janus_prod_pe.payers@DBL_JANUS j
      where substr(j.external_payer_id_v,1,4)='IMSI';

      begin
        l_var:=0;
        l_sql:= 'truncate table operacion.payers_janus';
        execute immediate l_sql;

        for c1 in cur1 loop
            insert into operacion.payers_janus (payer_id_n,external_payer_id_v,numero,payer_status_n,bill_cycle_n)
            values (c1.payer_id_n,c1.external_payer_id_v,c1.numero,c1.status,c1.ciclo);

            l_var:= l_var + 1;
            if l_var=1000 then
             l_var:=0;
             commit;
            end if;
        end loop;
        commit;
      end;

       V_FIN := 1;
     EXCEPTION
     WHEN OTHERS THEN

        /*Inicio: Proceso de rollback*/
        l_sql1:= 'truncate table operacion.payers_janus';
        execute immediate l_sql1;
        commit;
        /*Fin: Proceso de rollback*/
        V_FIN := 0;

    END;
  END LOOP;

END;

PROCEDURE p_cargar_dbjanus_conex (an_error OUT INTEGER,
                                  av_error OUT VARCHAR2) IS
 V_FIN NUMBER;
 l_sql1 varchar2(100);
 cant number;
BEGIN
   V_FIN := 0;

  SELECT count(PAYER_ID_N) into cant FROM operacion.payers_janus;

  IF cant <> 0 THEN
     WHILE (V_FIN = 0) LOOP
          BEGIN

         declare
            l_var number;
            l_sql varchar2(100);
            cursor cur2 is
            select max(ca.start_date_dt) start_date_dt, ca.account_id_n, ca.payer_id_0_n, ca.payer_id_3_n,
            (select x.external_payer_id_v from janus_prod_pe.payers@DBL_JANUS x where x.payer_id_n=ca.payer_id_3_n) customer_id
            from  janus_prod_pe.connection_accounts@DBL_JANUS ca, operacion.payers_janus p where ca.payer_id_0_n=p.payer_id_n 
            group by ca.account_id_n, ca.payer_id_0_n, ca.payer_id_3_n;
            begin

              l_var:=0;
              l_sql:= 'truncate table operacion.connection_accounts_janus';
              execute immediate l_sql;

              for c in cur2 loop

                  insert into operacion.connection_accounts_janus(start_date_dt, account_id_n, payer_id_0_n, payer_id_3_n,customer_id)
                  values (c.start_date_dt, c.account_id_n, c.payer_id_0_n, c.payer_id_3_n,c.customer_id);

                  l_var:= l_var + 1;
                  if l_var=1000 then
                   l_var:=0;
                   commit;
                  end if;
              end loop;
              commit;
            end;

             V_FIN := 1;
              an_error:=1;
              av_error:='OK';
           EXCEPTION
           WHEN OTHERS THEN

              /*Inicio: Proceso de rollback*/
              l_sql1:= 'truncate table operacion.connection_accounts_janus';
              execute immediate l_sql1;
              commit;
              /*Fin: Proceso de rollback*/
              V_FIN := 0;
              an_error:=0;
              av_error:='Error al cargar operacion.payer_tariffs_janus';
          END;
        END LOOP;
  ELSE
     V_FIN := 0;
     an_error:=0;
     av_error:='Para el proceso de carga operacion.connection_accounts_janus debe existir datos en la tabla operacion.payers_janus';
  END IF;

END;

PROCEDURE p_carga_db_janus_ptariffs(an_error OUT INTEGER,
                                    av_error OUT VARCHAR2) IS

V_FIN NUMBER;
l_sql2 varchar2(100);
cant number;
BEGIN

  V_FIN := 0;

  SELECT count(PAYER_ID_N) into cant FROM operacion.payers_janus;

  IF cant <> 0 THEN
       WHILE (V_FIN = 0) LOOP
          BEGIN


            declare
            l_var number;
            l_sql varchar2(100);

            cursor tar is
            select pt.payer_id_n, pt.start_date_dt, pt.tariff_id_n, tm.description_v, tm.tariff_type_v
            from janus_prod_pe.payer_tariffs@DBL_JANUS pt,janus_prod_pe.tariff_master@DBL_JANUS tm,  operacion.payers_janus p
            where pt.payer_id_n=p.payer_id_n
            and pt.tariff_id_n = tm.tariff_id_n
            AND pt.start_date_dt=(SELECT MAX(start_date_dt) FROM janus_prod_pe.payer_tariffs@DBL_JANUS WHERE tariff_id_n = pt.tariff_id_n and payer_id_n = pt.payer_id_n)
            AND pt.status_n = 1
            AND tm.tariff_type_v ='B';

            begin

              l_var:=0;
              l_sql:= 'truncate table operacion.payer_tariffs_janus';
              execute immediate l_sql;

              for pt in tar loop
                  insert into operacion.payer_tariffs_janus (start_date_dt,tariff_id_n,payer_id_n,description_v,tariff_type_v)
                  values (pt.start_date_dt,pt.tariff_id_n,pt.payer_id_n,pt.description_v,pt.tariff_type_v );

                  l_var:= l_var + 1;
                  if l_var=1000 then
                   l_var:=0;
                   commit;
                  end if;
              end loop;
              commit;
            end;

              V_FIN:= 1;
              an_error:=1;
              av_error:='OK';
          EXCEPTION
            WHEN OTHERS THEN

              /*Inicio: Proceso de rollback*/
              l_sql2:= 'truncate table operacion.payer_tariffs_janus';
              execute immediate l_sql2;
              commit;
              /*Fin: Proceso de rollback*/
              V_FIN:= 0;
              an_error:=0;
              av_error:='Error al cargar operacion.payer_tariffs_janus';
          END;
        END LOOP;
  ELSE
    V_FIN:=0;
    an_error:=0;
    av_error:='Para el proceso de carga operacion.payer_tariffs_janus debe existir datos en la tabla operacion.payers_janus ';
  END IF;

END p_carga_db_janus_ptariffs;


procedure p_proceso_alineacion_masiva (cResultado out rCursor)

is

--Cursor C1 (tab_hfc_alineacion)
    cursor cur1 is
    select
      h.numero, --numero
      h.customer cliente, --cliente
      h.codplan_b, --plan
      h.ciclo,  --ciclo
      h.co_id, --co_id
      h.numero_bscs, --numero_bscs
      h.codsolot, --codsolot
      h.codcli, --codigo cliente
      h.flg_sistema --flag sistema
    from operacion.tab_hfc_alineacion h
    WHERE
    nvl(h.numero,null) is not null
    AND nvl(h.customer,null) is not null
    AND nvl(h.codplan_b,null) is not null
    AND nvl(h.ciclo,null) is not null;

--Cursor C2 (Janus)
    cursor cur2 is
    select
      p.numero, --numero
      ca.customer_id, --cliente
      pt.tariff_id_n, --plan
      p.bill_cycle_n --ciclo
    from
      operacion.payers_janus p,
      operacion.connection_accounts_janus ca,
      operacion.payer_tariffs_janus pt
    where
      p.payer_id_n = ca.payer_id_0_n
      and ca.payer_id_0_n = pt.payer_id_n;

--Variables IW
    v_l_out number := 0;
    v_l_mensaje varchar2(100);
    v_l_clientecrm varchar2(20);
    v_l_idproducto number;
    v_l_idproductopadre number;
    v_l_idventa number;
    v_l_idventapadre number;
    v_l_endpointn number;
    v_l_homeexchangename varchar2(20);
    v_l_homeexchangecrmid varchar2(20);
    v_l_fechaActivacion date;

    v_an_error number;
    v_av_error varchar2(50);

    v_l_mens varchar2(100);
    v_l_idprodpadre number;
    v_l_idventpadre number;
    v_l_macadd varchar2(20);
    v_l_modelmta varchar2(20);
    v_l_profile varchar2(20);
    v_l_activcode varchar2(20);
    v_l_central varchar2(20);

--Variables Janus
    v2_existe_numero number;
    v2_numero varchar2(20); --numero
    v2_customer_id varchar2(20); --cliente
    v2_tariff_id_n number(10); --plan
    v2_bill_cycle_n varchar2(50); --ciclo

    ---FLAG CONSULTA INTRAWAY
    flg_iw number;  --- 1 : Por SP / 0 : Por Tabla

begin
    --OBTENER FLAG CONSULTA IW (PROCEDIMIENTO O TABLA)
    SELECT op.codigon INTO flg_iw FROM operacion.tipopedd td , operacion.opedd op
    WHERE td.tipopedd=op.tipopedd AND td.abrev = 'flg_iw';

    /*Recorremos cada uno de los registros de la tabla tab_hfc_alineacion*/
    for c1 in cur1 loop

        --Para IW ***************
        --Obtenemos los datos de IW
        IF flg_iw=1 then
           Intraway.pq_consultaitw.p_int_consultatn(c1.numero, v_l_out, v_l_mensaje, v_l_clientecrm, v_l_idproducto, v_l_idproductopadre, v_l_idventa, v_l_idventapadre, v_l_endpointn, v_l_homeexchangename, v_l_homeexchangecrmid, v_l_fechaActivacion);
         ELSE
           SELECT ltrim(it.codcli,'0'), it.idproducto INTO v_l_clientecrm,v_l_idproducto
           FROM intraway.int_reg_tlf it where it.Tn = c1.numero AND SUBSTR(it.Homeexchangecrmid,1,6) <> 'CORTFP';
        END IF;

        --Si es cliente masivo puro sga ó cliente claro empresas
        if (c1.flg_sistema = 1) then

            --Si no tiene el mismo cliente
            IF (v_l_clientecrm <> LTRIM(c1.codcli,'0')) then

                --Se registra en la tabla numero_noalineado
                Operacion.PQ_HFC_ALINEACION.p_reg_numero_noalineado(c1.numero, c1.co_id, 'TEP', 'IW', 'Nro. Telefónico no pertenece al cliente', v_an_error, v_av_error);


            ELSE  --Si tiene el mismo cliente

                 --Verificamos si líne está activa en IW 
                 IF flg_iw=1 then
                    intraway.pq_consultaitw.p_int_consultamta(v_l_clientecrm, v_l_idproductopadre, 0, v_l_out, v_l_mens, v_l_idprodpadre, v_l_idventpadre, v_l_macadd, v_l_modelmta, v_l_profile, v_l_activcode, v_l_central);
                    if nvl(v_l_macadd,null) is not null THEN
                       v_l_out:=1;
                    END IF;
           ELSE
                    select case when (im.macaddress is null) then 0 else 1 end flag  into v_l_out from intraway.int_reg_mta im where im.codcli = v_l_clientecrm AND im.idproducto = v_l_idproducto;
                 END IF;
                 --Si no está activo
                 if (v_l_out <> 1) then

                      --Se registra en la tabla numero_noalineado
                      Operacion.PQ_HFC_ALINEACION.p_reg_numero_noalineado(c1.numero, c1.co_id, 'TEP', 'IW', 'Nro. Telefónico no activo', v_an_error, v_av_error);

                 end if;

            end if;

        end if;

        --Si es cliente BSCS - SICSAT
        if (c1.flg_sistema = 2) then

              --Si no tiene el mismo cliente
              IF (v_l_clientecrm <> c1.cliente) then

                  --Se registra en la tabla numero_noalineado
                  Operacion.PQ_HFC_ALINEACION.p_reg_numero_noalineado(c1.numero, c1.co_id, 'TEP', 'IW', 'Nro. Telefónico no pertenece al cliente', v_an_error, v_av_error);

              ELSE --Si tiene el mismo cliente

                 --Verificamos si líne está activa en IW 
                 IF flg_iw=1 then
                    intraway.pq_consultaitw.p_int_consultamta(v_l_clientecrm, v_l_idproductopadre, 0, v_l_out, v_l_mens, v_l_idprodpadre, v_l_idventpadre, v_l_macadd, v_l_modelmta, v_l_profile, v_l_activcode, v_l_central);
                    if nvl(v_l_macadd,null) is not null THEN
                       v_l_out:=1;
                    END IF;
                 ELSE
                    select case when (im.macaddress is null) then 0 else 1 end flag  into v_l_out from intraway.int_reg_mta im where im.codcli = v_l_clientecrm AND im.idproducto = v_l_idproducto;
                 END IF;

                   --Si no está activo
                   if (v_l_out <> 1) then

                        --Se registra en la tabla numero_noalineado
                        Operacion.PQ_HFC_ALINEACION.p_reg_numero_noalineado(c1.numero, c1.co_id, 'TEP', 'IW', 'Nro. Telefónico no activo', v_an_error, v_av_error);

                   end if;

              end if;

        end if;

        --Para BSCS *****************
        if (c1.flg_sistema = 2 and nvl(c1.numero_bscs,null) is not null AND nvl(c1.co_id,null) is not null) then
            Operacion.PQ_HFC_ALINEACION.p_alinea_numero_bscs_sga(c1.co_id, c1.numero, c1.numero_bscs, v_an_error, v_av_error);
        end if;

        --Para JANUS ****************
        v2_existe_numero := 0;

        --Obtenemos los datos del número en Janus
        for c2 in cur2 loop
            if (c1.numero = c2.numero) then
               v2_numero := c2.numero; -- número
               v2_customer_id := c2.customer_id; --cliente
               v2_tariff_id_n := c2.tariff_id_n; --plan
               v2_bill_cycle_n := c2.bill_cycle_n; --ciclo
               v2_existe_numero := 1;
               exit;
            end if;
        end loop;

        --No existe el número
        if (v2_existe_numero = 0) then

             --Alta del número
             operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(1, c1.codsolot, c1.co_id, c1.cliente, 0, c1.numero, v_an_error, v_av_error);

        --Si existe el número
        else
             --Si es diferente plan - cliente - ciclo
             if ((c1.codplan_b||c1.cliente||c1.ciclo) <> (v2_tariff_id_n||v2_customer_id||v2_bill_cycle_n)) then

                --Baja y alta del número
                operacion.pq_sga_janus.p_insertxacc_prov_sga_janus(3, c1.codsolot, c1.co_id, c1.cliente, v2_customer_id, c1.numero, v_an_error, v_av_error);

             end if;

        end if;

    end loop;

    commit;

    --Cargar el resultado
    open cResultado for
    select numero
    from operacion.numero_noalineado
    where to_char(fecusu,'dd/MM/yyyy') = to_char(sysdate,'dd/MM/yyyy');

exception
    when others then
         rollback;
end;


END PQ_HFC_ALINEACION;
/