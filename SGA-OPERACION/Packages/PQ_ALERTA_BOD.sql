CREATE OR REPLACE PACKAGE OPERACION.pq_alerta_bod  is


c_separador     VARCHAR2(1):= ';';

procedure p_alerta_tarea_generada_bod_am;
procedure p_alerta_tarea_generada_bod_pm;
procedure p_alerta_cierre_tarea_up_bod( a_idtareawf in number,
                                        a_idwf      in number,
                                        a_tarea     in number,
                                        a_tareadef  in number);

procedure p_alerta_cierre_tarea_down_bod( a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number);

end pq_alerta_bod;
/


