CREATE OR REPLACE PROCEDURE OPERACION.P_DET_AUTOMATICO_DERIVACION_EF(lv_id number,lv_tipsrv varchar2,lv_idproducto number,lv_idcampanha number,lv_acceso number,lv_tiptra number) IS
/******************************************************************************
   NOMBRE:      P_DET_AUTOMATICO_DERIVACION_EF
   DESCRIPCION:    Realiza la Derivacion del Proyecto en forma Automatica.

   REVISIONES:
   Version     Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------
   1.0        09/09/2007  Roy Concepcion
   2.0        05/10/2009  Hector Huaman M  REQ.103745:Se añadio procedmiento que actualiza tipo de trabajo.
   3.0        26/07/2010  Antonio Lagos    REQ.134789:Correccion para que tomen los puntos que no tienen asociado un tipo de trabajo
                                           ,campo categoria no es el mismo que acceso y se comenta
   4.0        13/09/2017  Servicio Fallas-HITSS   INC000000903157 
   5.0        09/10/2017 Anderson Julca    Optimización del query y traslado de restricción de créditos
                                           hacia la aprobación de la Oferta Comercial
   6.0        04/04/2019                   PROY-140228 - FUNCIONALIDADES SOBRE SERVICIOS FIJA CORPORATIVA EN SGA										   
******************************************************************************/
cursor cur_vta is
                     select B.NUMSLC , c.numpto,B.CODCLI,B.TIPSRV,B.TIPSOLEF,B.CLIINT,g.codubi,e.idcategoria
                      from vtatabslcfac B, vtadetptoenl C, tystabsrv E, cxcpspchq Q, vtasuccli F, vtatabdst G, tmp_vtatabslcfac_derivef H
                      where /*to_number(B.numslc) not in (select codef from ef where codef = to_number(b.numslc))
                      and*/ b.numslc = c.numslc
                      and b.numslc = q.numslc
                      and c.numslc = h.numslc
                      and c.numpto = h.numpto
                      and b.tipo in (0,5)
                      and (b.tipsrv =trim(lv_tipsrv) or lv_tipsrv is null)
                      and b.estsolfac in ('03')
                      and (e.idproducto =lv_idproducto OR lv_idproducto is null)
                      and (b.idcampanha = lv_idcampanha OR lv_idcampanha is null)
                      --ini 3.0
                      --and (e.idcategoria =lv_acceso OR lv_acceso is null)
                      --fin 3.0
                      and (c.tiptra =lv_tiptra  OR lv_tiptra is null)
                      -- ini 5.0
                      AND TRUNC(b.fecapr)>=TRUNC(SYSDATE)-(SELECT TO_NUMBER(valor) FROM constante WHERE constante='IS_DIASDERIV')
                      -- fin 5.0
                      and c.codsrv = e.codsrv(+)
                      and c.codsuc = f.codsuc(+)
                      and f.ubisuc = g.codubi(+)
                      and h.estado = 1
                     --and b.numslc = '0000076162'
                      group by B.NUMSLC,c.numpto,B.CODCLI,B.TIPSRV,B.TIPSOLEF,B.CLIINT,g.codubi,e.idcategoria;

cursor cur_aut is
            SELECT A.ID,A.TIPSRV,A.IDCAMPANHA,A.TIPTRA,A.IDPRODUCTO,B.AREA,B.RESPONSABLE,A.ACCESO,A.PREPROC,B.DIAVALIDEZ,B.DIAPLAZO,b.zona
            FROM EFAUTOMATICO A,EFAUTOXAREA B
            where A.ID = B.IDEF
            and ( A.tipsrv=trim(lv_tipsrv) or (lv_tipsrv is null))
            and (A.idcampanha=lv_idcampanha  OR lv_idcampanha is null)
            and (A.acceso =lv_acceso OR lv_acceso is null)
            and (A.tiptra =lv_tiptra  OR lv_tiptra is null)
            and (idproducto=lv_idproducto or lv_idproducto is null)
            and id=lv_id;
ll_preproc varchar2(200);
l_count number;
l_numslc number;
l_return number;
ll_zona number;
ll_cantpro number;
ll_codpai number;
ll_codest number;
ll_codpvc number;
l_proc varchar2(200);
--Ini 4.0
V_SQL_CLOB clob;
v_sql varchar2(32767);
v_sql_1 varchar2(4000);
v_sql_2 varchar2(4000);
v_sql_3 varchar2(4000);
v_sql_4 varchar2(4000);
v_sql_5 varchar2(4000);
v_sql_6 varchar2(4000);
v_sql_7 varchar2(4000);
v_sql_8 varchar2(4000);
v_error varchar2(2500);
NULL_STRING EXCEPTION;
PRAGMA
EXCEPTION_INIT(NULL_STRING, -06535);
--Fin 4.0
l_valida number;
begin
              l_return := 1 ;
              -- Se asigna el SEF al EF
              for row_vta in cur_vta loop
                  --ini 3.0
                  --operacion.p_tiptra_proyecto(row_vta.numslc);--<2.0>
                  --fin 3.0
                  if row_vta.codubi is not null then
                    -- Permite ejecutar el Procedimiento antes de asignar el SEF al EF
                    -- Ini 4.0
                    begin
                      begin
                        select RTRIM(t.preproc)
                          into V_SQL_CLOB
                          from efautomatico t
                         where (t.tipsrv = lv_tipsrv or lv_tipsrv is null)
                           and (t.idcampanha = lv_idcampanha or lv_idcampanha is null)
                           and (t.acceso = lv_acceso or lv_acceso is null)
                           and (t.tiptra = lv_tiptra or lv_tiptra is null)
                           and (t.idproducto = lv_idproducto or lv_idproducto is null)
                           and t.id = lv_id;
                      
                      exception
                        when no_data_found then
                          V_SQL_CLOB := '';
                      end;
                    
                      v_sql_1 := substr(V_SQL_CLOB, 1, 4000);
                      v_sql_2 := substr(V_SQL_CLOB, 4001, 4000);
                      v_sql_3 := substr(V_SQL_CLOB, 8001, 4000);
                      v_sql_4 := substr(V_SQL_CLOB, 12001, 4000);
                      v_sql_5 := substr(V_SQL_CLOB, 16001, 4000);
                      v_sql_6 := substr(V_SQL_CLOB, 20001, 4000);
                      v_sql_7 := substr(V_SQL_CLOB, 24001, 4000);
                      v_sql_8 := substr(V_SQL_CLOB, 28001, 4000);
                    
                      v_sql := v_sql_1 || v_sql_2 || v_sql_3 || v_sql_4 || v_sql_5 || v_sql_6 ||
                               v_sql_7 || v_sql_8;
                    
                      v_sql := replace(replace(v_sql, CHR(10), ' '), CHR(13), ' ');
                      l_valida := operacion.pq_ef.valida_statement(v_sql); --Obtiene la posicion de la sentencia no permitida

                      if l_valida > 0 then --Valida la existencia sentencias no permitidas
                         raise NULL_STRING; --Excepcion para no ejecutar el bloque configurado
                      end if;
                      EXECUTE IMMEDIATE v_sql
                      USING row_vta.numslc;
                    exception
                        WHEN NULL_STRING THEN
                          v_error := SQLERRM;                                                                       
                    end;
                    -- Fin 4.0

                    if l_return = 1 then
                        --Insertamos el estudio de factibilidad

                        /*******************************************************************
                           Ver si el proyecto es de paquete pymes o TPI
                        ********************************************************************/

                        /*************Para todo tipo de proyecto*********************************/
                   /*     select count(*) into ll_cantpro from ef where numslc = row_vta.numslc;

                        if ll_cantpro = 0 then
                              insert into ef (CODEF, NUMSLC, CODCLI, ESTEF, tipsrv, tipsolef, cliint)
                              values ( to_number(row_vta.numslc), row_vta.numslc, row_vta.codcli, 1, row_vta.tipsrv, row_vta.tipsolef, row_vta.cliint);
                              commit;

                              \********************Para insertar los puntos al estudio de factibilidad*************************
                                  p_act_ef_de_sol(to_number(row_vta.numslc))
                              ************************************************************************************************\

                              --Insertamos los puntos del estudio de factibilidad

                              INSERT INTO efpto
                                         (codef, punto, descripcion, direccion, codsuc, codubi, codsrv,
                                          bw, codinssrv, tiptra, coordx1, coordy1, coordx2, coordy2,
                                          nrolineas, nrofacrec, nrohung, nroigual, nrocanal, tiptraef)
                                SELECT to_number(row_vta.numslc), TO_NUMBER (numpto), descpto, dirpto, codsuc, ubipto,
                                       codsrv, NVL (banwid, 0), numckt, tiptra, merabs1, merord1,
                                       merabs2, merord2, nrolineas, nrofacrec, nrohung, nroigual,
                                       nrocanal, tiptraef
                                  FROM vtadetptoenl
                                 WHERE crepto = '1'
                                   AND numslc = LPAD (to_number(row_vta.numslc), 10, '0')
                                   AND (   (codequcom IS NULL)
                                        OR (codequcom IS NOT NULL AND numpto = numpto_prin)
                                       )
                                   AND TO_NUMBER (numpto) NOT IN (SELECT punto
                                                                    FROM efpto
                                                                   WHERE codef = to_number(row_vta.numslc));
                              commit;

                              l_numslc := to_number(row_vta.numslc);
                              --Se procederá a llenar los equipos desde la SEF, en el momento de la derivación de la EF
                              OPERACION.P_ACT_EFEQU_DE_SOLEF(l_numslc);
                        end if;  */

                        -- Se deriva el EF al SOLEFXAREA
                         for row_aut in cur_aut loop
                           -- Para el caso que no se repita el area
                           select count(*) into l_count from solefxarea where codef=to_number(row_vta.numslc)  and area=row_aut.area;
                           -- Para el caso que si el proyecto es de Lima se inserte en el ambito correspondiente de Lima
                               select codpai, codest, codpvc into ll_codpai,ll_codest,ll_codpvc from vtatabdst where codubi = row_vta.codubi;
                           --REQ. 64971
                           if  ll_codpai = 51 then
                              if ll_codest = 1 and (ll_codpvc = 1  or ll_codpvc = 2)then
                                 ll_zona := 1;
                              else
                                 ll_zona := 2;
                              end if;
                           else
                              ll_zona := 1;
                           end if;

/*                           if ll_codpai = 51 and ll_codest = 1 and (ll_codpvc = 1  or ll_codpvc = 2)then
                               ll_zona := 1;
                           else
                               ll_zona := 2;
                           end if;*/
                           --REQ. 64971
                           if l_count = 0 then
                             if ll_zona = row_aut.zona   then
                                 insert into solefxarea(codef,area,numslc,esresponsable,estsolef,numdiaval,numdiapla)
                                 VALUES(to_number(row_vta.numslc),row_aut.area,row_vta.numslc,row_aut.responsable,1,row_aut.diavalidez,row_aut.diaplazo);
                                 UPDATE tmp_vtatabslcfac_derivef set estado = 2
                                 where  numslc = row_vta.numslc and numpto = row_vta.numpto;
                             else
                                 if row_aut.zona = 0 then
                                    insert into solefxarea(codef,area,numslc,esresponsable,estsolef,numdiaval,numdiapla)
                                    VALUES(to_number(row_vta.numslc),row_aut.area,row_vta.numslc,row_aut.responsable,1,row_aut.diavalidez,row_aut.diaplazo);
                                    UPDATE tmp_vtatabslcfac_derivef set estado = 2
                                    where  numslc = row_vta.numslc and numpto = row_vta.numpto;
                                 end if;
                             end if;
                           end if;
                         end loop;

                    end if;
                 end if;
               end loop;
			   
			   -- INI 6.0
			   metasolv.pkg_asignacion_pex_unico.sgass_libera_hilo_60_mayor;
			   -- FIN 6.0
			   
               commit;

end;
/


