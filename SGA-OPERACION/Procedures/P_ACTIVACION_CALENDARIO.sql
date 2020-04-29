CREATE OR REPLACE PROCEDURE OPERACION.P_ACTIVACION_CALENDARIO(a_idtareawf in number,
                                                              a_idwf      in number,
                                                              a_tarea     in number,
                                                              a_tareadef  in number,
                                                              a_tipesttar in number,
                                                              a_esttarea in number,
                                                              a_mottarchg in number,
                                                              a_fecini in date,
                                                              a_fecfin in date) IS


/************************************************************************
  NOMBRE: P_ACTIVACION_CALENDARIO
  PROPOSITO: Genera la carta de compromiso basada en el calendario
             generado desde la venta
  PROGRAMADO EN JOB: NO
  REVISIONES:
  Versión    Fecha           Autor            Descripción
  ---------  ----------      ---------------  -----------------------
  1.0        18/11/2009      Raúl pari        <REQ 105509>. Creación
************************************************************************/

ln_monedaid cxctabfac.moneda_id%type;
ln_verifica number;
ls_codcli vtatabslcfac.codcli%type;
ln_numcar cxcdetcom.numcar%type;
ls_idfac cxctabfac.idfac%type;
ln_codsolot  solot.codsolot%type;
lc_numslc    vtatabslcfac.numslc%type;
lc_error     varchar2(2000);
error_validacion exception;

cursor cur_cabecera is
select x.numslc,
       x.idbilfac,
       x.totalcuotas,
       x.codinssrv,
       sum(capital) montofinanciado,
       sum(interes) interes,
       sum(valorcuota) total_a_pagar,
       round(sum(interes) / sum(capital), 2) tasa
  from vtacalendariopago x
 where numslc = lc_numslc
 group by x.numslc, x.idbilfac, x.totalcuotas, x.codinssrv;

cursor cur_calendario_pago is
select cuota,
       trunc(fechavencimiento) fechavencimiento,
       sum(capital) capital,
       sum(interes) interes,
       sum(valorcuota) valorcuota,
       round(sum(interes) / sum(capital), 2) tasa
  from vtacalendariopago b
 where b.numslc = lc_numslc
 group by b.cuota, trunc(fechavencimiento)
 order by b.cuota asc;




BEGIN

  if a_tipesttar = 4 then
    lc_error := 'OK';

    begin
      select numslc into lc_numslc
      from solot
      where codsolot =
            (select codsolot from wf where idwf = a_idwf);
    exception
    when others then
         lc_error := 'No existe registro para el IDWF: '||a_idwf|| '. '|| sqlerrm;
         raise error_validacion;
    end;


    for cur_cab in cur_cabecera loop

        select count(*)
          into ln_verifica
          from cxctabfac a, bilfac b
         where a.idfac = b.idfaccxc
           and b.idbilfac = cur_cab.idbilfac;
        if ln_verifica <> 1 then
           lc_error := 'La factura asociada a la venta aún no ha sido emitida, por favor validar con facturación';
           raise error_validacion;
        else
           select a.idfac
             into ls_idfac
             from cxctabfac a, bilfac b
            where a.idfac = b.idfaccxc
              and b.idbilfac = cur_cab.idbilfac;
        end if;

        begin
          select moneda_id
            into ln_monedaid
            from cxctabfac
           where idfac = ls_idfac;
        exception
        when others then
           lc_error := 'Problemas con la moneda: ' || sqlerrm;
           raise error_validacion;
        end;

        begin
          select codcli
            into ls_codcli
            from vtatabslcfac
            where numslc = cur_cab.numslc;
        exception
        when others then
           lc_error := 'Problemas con el codigo del cliente: ' || sqlerrm;
           raise error_validacion;
        end;

        begin
           insert into cxccabcom
           (moneda_id,
            moncar,
            intdoc,
            valtot,
            numcuo,
            codinssrv,
            idtipogestion,
            codcli,
            fecemi,
            fecven,
            intcar,
            sldact,
            estcar,
            flagcorte)
           values
           (ln_monedaid,
            cur_cab.montofinanciado,
            cur_cab.interes,
            cur_cab.total_a_pagar,
            cur_cab.totalcuotas,
            cur_cab.codinssrv,
            2,
            ls_codcli,
            sysdate,
            add_months(sysdate,cur_cab.totalcuotas),
            cur_cab.tasa,
            cur_cab.total_a_pagar,
            '02',
            0)
            returning numcar
                into ln_numcar;
        exception
        when others then
           lc_error := 'Problemas al insertar la cabecera de la carta de compromiso: ' || sqlerrm;
           raise error_validacion;
        end;

        begin
          for cur_det in cur_calendario_pago loop
              insert into cxcdetcom
              (numcar,
               plazcar,
               secuencial,
               fecemi,
               intdoc,
               moncar,
               valtot,
               fecven,
               sldact,
               estcuo)
              values
              (ln_numcar,
               to_number(cur_det.fechavencimiento - sysdate),
               cur_det.cuota,
               sysdate,
               cur_det.interes,
               cur_det.capital,
               cur_det.valorcuota,
               cur_det.fechavencimiento,
               cur_det.valorcuota,
               '01');
          end loop;
        exception
        when others then
           lc_error := 'Problemas al insertar el detalle de la carta de compromiso: ' || sqlerrm;
           raise error_validacion;
        end;

        begin
          update cxctabfac
             set flgcarcomp = 1
           where idfac = ls_idfac;
        exception
        when others then
           lc_error := 'Problemas al actualizar la cxctabfac: ' || sqlerrm;
           raise error_validacion;
        end;
        begin
          insert into cxccarcom_tabfac
          (numcar, idfac)
          values
          (ln_numcar,ls_idfac);
        exception
        when others then
           lc_error := 'Problemas al insertar en cxccarcom_tabfac: ' || sqlerrm;
           raise error_validacion;
        end;


    end loop;
    commit;
  end if;

exception
  when error_validacion then
       rollback;
       raise_application_error (-20411,lc_error);
  when others then
       rollback;
END P_ACTIVACION_CALENDARIO;
/


