CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAR_PRECIOS_SAP(a_monto in decimal default 3) IS
  /************************************************************
  NOMBRE:     operacion.p_actualizar_precios_sap
  PROPOSITO:  Actualiza los precios en el maestro de material utilizando como fuente el
              sistema SAP y los preciarios.
  PROGRAMADO EN JOB:  No

  REVISIONES:
CREATE OR REPLACE PROCEDURE OPERACION.P_ACTUALIZAR_PRECIOS_SAP(a_monto in decimal default 3) IS
  /************************************************************
  NOMBRE:     operacion.p_actualizar_precios_sap
  PROPOSITO:  Actualiza los precios en el maestro de material utilizando como fuente el
              sistema SAP y los preciarios.
  PROGRAMADO EN JOB:  No
  REVISIONES:
  Ver        Fecha        Autor             Descripción
  ---------  ----------  ---------------    ------------------------
  6.0        03.11.2015  Edilberto Astulle
  *************************************************************/

  Cursor cur_sap is
  select trim(material) material, max(precio_lista) precio_lista
  from sgaweb_material_sap_m
  group by material;
  n_monto number;
  n_id_control number;
  lv_error varchar2(3);
BEGIN
  --Descarga los tipos de Cambio
  operacion.PQ_SINERGIA.p_importtaxrate(lv_error); 
  n_monto :=operacion.PQ_SINERGIA.f_get_ratio_tc('USD', 'PEN');
  --Actualiza los precios en base al tipo de cambio
  for g in cur_sap loop
    begin
      update produccion.almtabmat
      set preprm_usd = round(g.precio_lista / n_monto, 2),preprm=g.precio_lista
      where trim(cod_sap) = g.material;
    exception
      when others then
        null;
    end;
  end loop;
  COMMIT;
  OPERACION.p_actualiza_costo_mat;
  COMMIT;
END;


/


