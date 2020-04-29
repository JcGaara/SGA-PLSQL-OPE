CREATE OR REPLACE TRIGGER OPERACION.T_SOLEFXAREA_AI
AFTER INSERT
ON OPERACION.SOLEFXAREA
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
/******************************************************************************

Date        Author           Description
----------  ---------------  ------------------------------------
18/06/2004  Carlos Corrales  Se agrego PRIORIDAD en el envio de mail.


******************************************************************************/
   ls_texto   VARCHAR2 (200);
   ln_prioridad number(3);
    ln_idlog number(8);
   ls_codcli char(8);
   CURSOR cur_correo
   IS
      SELECT a.email
        FROM envcorreo a
       WHERE a.area = :NEW.area AND a.tipo = 4;
BEGIN
   SELECT nvl(idprioridad,0)
     INTO ln_prioridad
     FROM vtatabslcfac
    WHERE numslc = :NEW.numslc;

   ls_texto :=
         'Fue derivado por '
      || :NEW.codusu
      || ' Fecha: '
      || TO_CHAR (:NEW.fecusu, 'dd/mm/yyyy hh24:mi:ss')
      || CHR (13);
   ls_texto := ls_texto || 'Proyecto: ' || :NEW.numslc||CHR (13)||'PRIORIDAD '||ln_prioridad;

   FOR ls_correo IN cur_correo
   LOOP
      p_envia_correo_de_texto_att (   'PRIORIDAD '||ln_prioridad||' Estudio de Factibilidad '
                                   || TO_CHAR (:NEW.codef),
                                   ls_correo.email,
                                   ls_texto
                                  );
   END LOOP;

   select nvl(max(id),0)+1 into ln_idlog from solefxarea_log_ef;
   insert into solefxarea_log_ef(id,codef, usulog, feclog,estado,area)
        values ( ln_idlog,:new.codef ,user,sysdate, 'DERIVADO',:new.area);

   --JMAP
    /* if :new.area <> :old.area  or :old.area is null  then*/
         select codcli into ls_codcli from vtatabslcfac where numslc = :new.numslc;
         insert into operacion.estsolef_dias_utiles(codef,codcli,codarea,estsolef,fechaini)
         values(:new.codef,ls_codcli,:new.area,:new.estsolef,sysdate);
   /*
     end if;*/
   --JMAP
END;
/



