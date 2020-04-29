CREATE OR REPLACE PROCEDURE OPERACION.p_actualiza_sucur_hub is

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_ACTUALIZA_SUCUR_HUB';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='865';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
*/
--------------------------------------------------



vn_exit number;
vn_numvia number;
vnnum_seq_ini number;
vnnum_seq_fin number;
vn_resto  number;
vv_lado   nomenglaturahub.lado%type;
vv_idcmts ope_cmts.idcmts%type;
cursor c_sucur is
select a.codsuc,a.codcli,a.numvia,b.num_seq
from vtasuccli a, inmueble b
where a.idinmueble = b.idinmueble and
      a.idhub is null             and
      a.idcmts is null;
cursor c_nome is
select a.idhub, a.num_seq, a.num_seq_ini, a.num_seq_fin, a.lado from nomenglaturahub a
where a.lado = vv_lado or a.lado = 'T';
begin

    for lc_sucur in c_sucur loop
       begin
            vn_numvia := to_number(lc_sucur.numvia);
            select mod(vn_numvia,2) into vn_resto from DUMMY_OPE;
            if vn_resto = 0 then
               vv_lado := 'P';
            else
               vv_lado := 'I';
            end if;
            for lc_nome in c_nome loop
              vnnum_seq_ini := to_number(lc_nome.num_seq_ini);
              vnnum_seq_fin := to_number(lc_nome.num_seq_fin);
              if lc_nome.lado = 'T' then
                  if lc_sucur.num_seq = lc_nome.num_seq then
                     select idcmts into vv_idcmts from ope_cmts where idhub = lc_nome.idhub and rownum = 1;
                     update vtasuccli set idhub = lc_nome.idhub , idcmts = vv_idcmts
                     where  codsuc = lc_sucur.codsuc;
                     exit;
                  end if;
              elsif lc_nome.lado = 'P' then
                  if lc_sucur.num_seq = lc_nome.num_seq and lc_nome.lado = 'P' and vn_numvia >= vnnum_seq_ini and vn_numvia <= vnnum_seq_fin then
                     select idcmts into vv_idcmts from ope_cmts where idhub = lc_nome.idhub and rownum = 1;
                     update vtasuccli set idhub = lc_nome.idhub , idcmts = vv_idcmts
                     where  codsuc = lc_sucur.codsuc;
                     exit;
                  end if;
              elsif lc_nome.lado = 'I' then
                  if lc_sucur.num_seq = lc_nome.num_seq and lc_nome.lado = 'I' and vn_numvia >= vnnum_seq_ini and vn_numvia <= vnnum_seq_fin then
                     select idcmts into vv_idcmts from ope_cmts where idhub = lc_nome.idhub and rownum = 1;
                     update vtasuccli set idhub = lc_nome.idhub , idcmts = vv_idcmts
                     where  codsuc = lc_sucur.codsuc;
                     exit;
                  end if;
              end if;
            end loop;
       exception
       when others then
            vn_exit := 0;
       end;
       commit;
    end loop;

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*
sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
*/
end;
/


