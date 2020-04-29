CREATE OR REPLACE FUNCTION OPERACION.f_requisiciones_montosuma (
lngsolot in  solotpto_id.codsolot%type,
lngpunto in   solotptoeta.punto%type,
lngorden in   solotptoeta.orden%type,
tipo_cambio in float,
moneda      in number
)
return number

is

   fltmontomat solotptoetamat.cosliq%type;
   fltmontoact solotptoetaact.cosliq%type;
   fltmontototal float;
   moneda_actividades int;
   moneda_materiales  int;


   cursor cursor_actividades is
   select solotptoetaact.cosliq*solotptoetaact.canliq, solotptoetaact.moneda_id
   from solotptoetaact, actividad, actxpreciario act1, actxpreciario act2, solotptoeta
   where solotptoetaact.codact = actividad.codact
   and act1.codprec(+) = solotptoetaact.codprecdis
   and act1.codact(+) = solotptoetaact.codact
   and act2.codprec(+) = solotptoetaact.codprecliq
   and act2.codact(+) = solotptoetaact.codact
   and solotptoetaact.codsolot = lngsolot
   and solotptoetaact.punto = lngpunto
   and solotptoetaact.orden = lngorden
   and solotptoeta.codsolot = solotptoetaact.codsolot
   and solotptoeta.punto    = solotptoetaact.punto
   and solotptoeta.orden    = solotptoetaact.orden;


   cursor cursor_materiales is
   SELECT solotptoetamat.cosliq*solotptoetamat.canliq, solotptoetamat.moneda_id
   FROM solotptoetamat, v_matope,
   matope, almtabmat, z_ps_val_busqueda_det, solotptoeta
   WHERE (solotptoetamat.codmat = v_matope.codmat)
   and (solotptoetamat.codmat = matope.codmat)
   and (solotptoetamat.codsolot = lngsolot)
   AND (solotptoetamat.punto = lngpunto)
   AND (solotptoetamat.orden = lngorden)
   AND (solotptoetamat.codmat = almtabmat.codmat)
   AND z_ps_val_busqueda_det.VALOR(+) = NVL(ALMTABMAT.COMPONENTE, '@')
   AND z_ps_val_busqueda_det.CODIGO(+) = 'TIPO_COMP'
   AND z_ps_val_busqueda_det.HABILITADO(+) = 'S'
   and solotptoeta.codsolot = solotptoetamat.codsolot
   and solotptoeta.punto    = solotptoetamat.punto
   and solotptoeta.orden    = solotptoetamat.orden;

begin

   fltmontototal := 0.00;


     --Monto de Actividades
      open cursor_actividades;
      fltmontoact := 0.00;
      fetch cursor_actividades into fltmontoact, moneda_actividades;

      loop

              if moneda = 1 and moneda_actividades = 2 then
                 fltmontoact := fltmontoact*tipo_cambio;
              end if;

              if moneda = 2 and moneda_actividades = 1 then
                 fltmontoact := fltmontoact/tipo_cambio;
              end if;

              if fltmontoact is not null then
                 fltmontototal := fltmontototal + fltmontoact;
              end if;



          fltmontoact := 0.00;
          moneda_actividades := 0;

          fetch cursor_actividades into fltmontoact, moneda_actividades;
          exit when  cursor_actividades %NOTFOUND;
      end loop;

      close cursor_actividades;




     --Monto de Materiales

      open cursor_materiales;
      fltmontomat := 0.00;
      fetch cursor_materiales into fltmontomat, moneda_materiales;

      loop

                if moneda = 1 and moneda_materiales = 2 then
                   fltmontomat := fltmontomat*tipo_cambio;
                end if;

                if moneda = 2 and moneda_materiales = 1 then
                   fltmontomat := fltmontomat/tipo_cambio;
                end if;

                if fltmontomat is not null then
                   fltmontototal := fltmontototal + fltmontomat;
                end if;

            fltmontomat   := 0.00;
           moneda_materiales := 0;

           fetch cursor_materiales into fltmontomat,moneda_materiales;
           exit when  cursor_materiales %NOTFOUND;
      end loop;

      close cursor_materiales;


   if fltmontototal is null then
      fltmontototal := 0.0;
   end if;

   return round(fltmontototal,2);

end;
/


