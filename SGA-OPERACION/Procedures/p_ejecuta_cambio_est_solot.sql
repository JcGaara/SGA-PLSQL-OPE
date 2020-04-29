/*Aprobacion Crediticia Req 7469 -  Autor: Cristiam Vega  -  Fecha: 24/07/2013*/
CREATE OR REPLACE PROCEDURE OPERACION.p_ejecuta_cambio_est_solot(a_numslc IN SOLOT.NUMSLC%TYPE, an_cod_error  out number,
                                      as_des_error  out varchar2)  IS

ln_estsol number;
ls_estapr varchar2(10);
vn_return   number;

CURSOR CUR_SOT(N_NUMSLC SOLOT.NUMSLC%TYPE) IS
SELECT CODSOLOT, ESTSOL FROM SOLOT WHERE NUMSLC = N_NUMSLC;

BEGIN
    
        FOR C_SOT IN CUR_SOT(a_numslc) LOOP
          ln_estsol := collections.f_get_estadocredito(c_sot.codsolot, 2);
          IF ln_estsol = 11 THEN        
            OPERACION.pq_solot.p_chg_estado_solot(C_SOT.CODSOLOT, ln_estsol); 
            
            for r_doc in (select distinct bf.idbilfac
                            from solot            s,
                                 cnr_prefacturado c,
                                 cnr              cn,
                                 bilfac           bf
                           where cn.idbilfac = bf.idbilfac
                             and cn.idseccnr = c.idseccnr
                             and s.numslc = c.numslc
                             and bf.estfac = '06'
                             and s.NUMPSP is not null
                             and s.codsolot = C_SOT.CODSOLOT) loop
                    
                  update bilfac
                     set estfac = '01'
                   where idbilfac = r_doc.idbilfac; 
            end loop;

          END IF;
        END LOOP;
        -- INI 1.0
        select sales.PQ_VTA_MEJORA_PROYCORP.f_valida_proy_factible_ger(a_numslc) into vn_return from dual;
        if vn_return = 1 then
           select c.estapr into ls_estapr from collections.cxcpspchq c where c.numslc = a_numslc;
           IF NVL(ls_estapr,'Z') = 'A' AND NVL(a_numslc,'A') <> 'A' THEN
              SALES.PQ_VTA_MEJORA_PROYCORP.p_valida_aprob_proy_ger(a_numslc);
           END IF;
        end if;
        -- FIN 1.0
        an_cod_error := 0; 
exception

when others then
   an_cod_error := 1; 
   as_des_error := 'Error al Aprobar la SOT para el Proyecto :' || a_numslc ||'-'||sqlerrm;              
END;
/
