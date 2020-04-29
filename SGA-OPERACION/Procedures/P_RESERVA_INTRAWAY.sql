CREATE OR REPLACE PROCEDURE OPERACION.P_RESERVA_INTRAWAY(
    a_codsolot in number,
    a_wfdef in number,
    p_mensaje_reserva in out  varchar2
)

  /******************************************************************************

       Ver        Date        Author           Description
       --------- ----------  ---------------  ------------------------------------
       1.0       22/08/2008  Hector Huaman     Realiza la reserva en Intraway
       2.0       29/08/2008  Gustavo Ormeño    Actualizacion del estado de la SOT
       3.0       19/03/2009  Hector Huaman    REQ-85701: se modifico query, validar puerta - puerta por el flg_puerta
    ******************************************************************************/

 is

v_opcion    number(2);
p_resultado varchar2(10);
p_mensaje   varchar(1000);
p_error     number;
ls_codcli solot.codcli%type;
ln_3playpuerta number;
begin

  select codcli into ls_codcli from solot where codsolot=a_codsolot;
----Verifica si es proyecto es Puerta-Puerta 3Play
   --REQ 85701
   select count(*)
     into ln_3playpuerta
     from vtatabprecon v, solot s
    where v.numslc = s.numslc
      and s.codsolot = a_codsolot
      and (v.codmotivo_tf in
          (select codmotivo
              from vtatabmotivo_venta
             where codtipomotivo = '023'
               and flg_puerta = 1) or v.codmotivo = 22);--REQ-85701:modifico query, validar puerta - puerta por el flg_puerta

 if ln_3playpuerta >0 then

  --Se asigna el WF
  PQ_SOLOT.P_ASIG_WF(a_codsolot,a_wfdef);

  -- se actualiza el estado de la SOT a "En Ejecucion"
  UPDATE solot set estsol = 17 where codsolot = a_codsolot;
  --Registrar en la Tabla AGENDAMIENTO_INT
  insert into intraway.agendamiento_int (
  codsolot,
  codcli,
  est_envio,
  mensaje)
  values (
         a_codsolot,
         ls_codcli,
         4,
         'Servicio Intraway puerta-puerta'); --1:Listo para procesar
  commit;
  --Validar la correcta configuracion antes de transferir a Intraway
  INTRAWAY.PQ_SOTS_AGENDADAS.p_pretransf_intraw(a_codsolot);

  --Se realiza la reserva
  BEGIN
      v_opcion := 3; -- Corte Límite de Crédito
      intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                                 a_codsolot,
                                                 p_resultado,
                                                 p_mensaje,
                                                 p_error);

    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
        p_mensaje   := SQLERRM;
    END;
  --Se actualiza el estado en la tabla AGENDAMIENTO_INT
  update intraway.agendamiento_int set est_envio=5 where codsolot=a_codsolot;

       commit;
  p_mensaje_reserva:='ok';
  else
  p_mensaje_reserva:='El Proyecto seleccionado no es un Puerta-Puerta(verificar motivo del contrato).';
  end if;

   exception
      when others then
      raise;
END;
/


