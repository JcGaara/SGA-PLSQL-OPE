--Este proceso homologa las MacAddress de Intraway con las del SGA. Se debe correr los días lunes a las 00:00 Horas

begin
  -- Call the procedure
  intraway.pq_homologar_int_sga.p_homologar_sga_intraway;
end;
/