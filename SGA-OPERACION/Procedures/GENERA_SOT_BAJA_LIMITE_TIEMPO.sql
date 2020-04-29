CREATE OR REPLACE PROCEDURE OPERACION.GENERA_SOT_BAJA_LIMITE_TIEMPO IS
/*********************************************************************************************
     NOMBRE:            OPERACION.GENERA_SOT_BAJA_LIMITE_TIEMPO
     PROPOSITO:         Generar SOT de baja para los servicios en generabajas y SOTs con fecha de compromiso mayor a 30 días
     REVISIONES:
     Ver        Fecha        Autor           Descripcion
     ---------  ----------  ---------------  -----------------------------------
     1.0       05/02/2009   EMELENDEZ
     2.0       16/07/2009   Joseph Asencios  Se comenta el filtro por codsolot que estaba como constante.
                                             Por favor esto sólo se debe hacer para pruebas, luego se debe volver a comentar.
***********************************************************************************************/


l_codsolotbaja solot.codsolot%type;
Cursor curSot Is
Select codsolot
  from solot, generabajas
 where solot.tiptra = generabajas.tiptra
   and solot.tipsrv = generabajas.tipsrv
   and feccom < sysdate - 30
   and estsol in (17, 71, 19, 70, 73)
   /*and codsolot = 148612*/; --Comentado por REQ 97554 JAP
Begin
 For reg in curSot LOOP
  Begin
      OPERACION.P_BAJA_SOT_X_ANULA_N(reg.codsolot,1,'Rechazo por falta de respuesta Cliente. SOT '||reg.codsolot,1,15);
      Commit;
      Exception
        when others then
        null;
  End;
  --Asigna area del usuario
  begin
  select  codsolot_anula into l_codsolotbaja
  from operacion.solot_anula where codsolot=reg.codsolot;
  update solot Set areasol=(select areasol from solot where codsolot=reg.codsolot)  where codsolot=l_codsolotbaja;
  exception
   when no_data_found then
      l_codsolotbaja:=null;
  end;
 End loop;
 End;
/


