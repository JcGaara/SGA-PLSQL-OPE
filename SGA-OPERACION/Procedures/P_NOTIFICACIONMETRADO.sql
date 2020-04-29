CREATE OR REPLACE PROCEDURE OPERACION.P_NOTIFICACIONMETRADO( lv_fecha date,lv_cant number) IS



------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_NOTIFICACIONMETRADO';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='287';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------



ls_destino varchar2(100);
ls_cuerpo varchar2(4000);
ls_subject varchar2(100);
ls_cont number;

/******************************************************************************
Procedimiento para enviar notificaciones todos los dias  por las SOTs que esten
con metrados mayor a 100 mts, para el area Marketing
con usuarios fijos como destino
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
17/04/2006 Luis olarte Procedimiento para enviar correos
   1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

cursor cur_solot is
select s.codsolot,s.numslc,v.codcli,v.nomcli,e.descripcion,se.codcon,c.nombre,sum(sea.candis) cant
from solot s, etapa e, solotptoeta se, solotptoetaact sea,actividad a,contrata c, vtatabcli v
where/* s.codsolot=96685
and*/ upper(e.descripcion) like '%CANALIZA%'
and s.codcli=v.codcli
and s.codsolot=se.codsolot
and se.codeta=e.codeta
and se.codsolot = sea.codsolot
and se.orden = sea.orden
and sea.codact = a.codact
and a.codund = '001'
and se.codcon=c.codcon(+)
and s.codsolot in (select distinct seai.codsolot
                          from solotptoetaact seai , solotptoeta sei, etapa ei
                          where to_char(seai.fecusu,'dd/mm/yyyy') = to_char(lv_fecha,'dd/mm/yyyy')
                          and seai.codsolot=sei.codsolot
                          and seai.orden=sei.orden
                          and sei.codeta=ei.codeta
                          and upper(ei.descripcion) like '%CANALIZA%'
                          )
group by s.codsolot,s.numslc,v.codcli,v.nomcli,e.descripcion,se.codcon,c.nombre
order by 1,2;

begin
ls_cuerpo:='';
ls_cont:=0;
  ls_destino:='karl.lindo@claro.com.pe,raul.jimenez@claro.com.pe';--1.0
  for cur in cur_solot loop
          if cur.cant >= lv_cant then

            ls_cuerpo := ls_cuerpo || 'SOT:' || trim(cur.codsolot);
            ls_cuerpo := ls_cuerpo || chr(13) || 'Proyecto: ' || trim(cur.numslc);
            ls_cuerpo := ls_cuerpo || chr(13) || 'Cliente: ' || trim(cur.codcli)||' - ' || cur.nomcli;
            ls_cuerpo := ls_cuerpo || chr(13) || 'Etapa: ' || trim(to_char(cur.descripcion));
            ls_cuerpo := ls_cuerpo || chr(13) || 'Contratista: ' || trim(cur.nombre);
            ls_cuerpo := ls_cuerpo || chr(13) || 'Metrado: ' || trim(cur.cant);
            ls_cuerpo := ls_cuerpo || chr(13)|| chr(13);
            ls_cont:=ls_cont + 1;
          end if;

  end loop;
      if  ls_cont>0 then
      begin
        ls_subject:= trim('Metrado Canalizacion ' || to_char(lv_fecha,'dd/mm/yyyy'));
        ls_cuerpo := ls_cuerpo || chr(13) || chr(13) || 'Usuario: SGA';
         ls_cuerpo := ls_cuerpo || chr(13)||'Fecha: '||to_char(sysdate,'dd/mm/yyyy');
        opewf.pq_send_mail_job.p_send_mail (ls_subject, ls_destino, ls_cuerpo, 'SGA@Sistema_de_Operaciones');
        end;
      end if;
 commit;


--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

end;
/


