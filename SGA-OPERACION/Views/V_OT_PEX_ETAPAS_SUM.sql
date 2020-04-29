CREATE OR REPLACE VIEW OPERACION.V_OT_PEX_ETAPAS_SUM
AS 
SELECT
   s.codsolot codpre,
   s.punto idubi,
   s.codeta codeta,
   s.orden orden,
   /*A:Dis, Soles*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa  (s.codsolot, s.punto, s.codeta, 1, 0, 1, null) MO_dis_sol,
   /*P:Dis, Soles*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa  (s.codsolot, s.punto, s.codeta, 1, 1, 1, null) Per_dis_sol,
   /*M:Dis, Soles*/PQ_COSTO_OPE.f_sum_matxpuntoxetapa  (s.codsolot, s.punto, s.codeta, 1,    1, null) Mat_dis_sol,
   /*A:Dis, Dolares*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa(s.codsolot, s.punto, s.codeta, 2, 0, 1, null) MO_dis_dol,
   /*P:Dis, Dolares*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa(s.codsolot, s.punto, s.codeta, 2, 1, 1, null) Per_dis_dol,
   /*M:Dis, Doalres*/PQ_COSTO_OPE.f_sum_matxpuntoxetapa(s.codsolot, s.punto, s.codeta, 2,    1, null) Mat_dis_dol,
   /*A:Liq, Soles*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa  (s.codsolot, s.punto, s.codeta, 1, 0, 3, null) MO_liq_sol,
   /*P:Liq, Soles*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa  (s.codsolot, s.punto, s.codeta, 1, 1, 3, null) Per_liq_sol,
   /*M:Liq, Soles*/PQ_COSTO_OPE.f_sum_matxpuntoxetapa  (s.codsolot, s.punto, s.codeta, 1,    3, null) Mat_liq_sol,
   /*A:Liq, Dolares*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa(s.codsolot, s.punto, s.codeta, 2, 0, 3, null) MO_liq_dol,
   /*P:Liq, Dolares*/PQ_COSTO_OPE.f_sum_actxpuntoxetapa(s.codsolot, s.punto, s.codeta, 2, 1, 3, null) Per_liq_dol,
   /*M:Liq, Doalres*/PQ_COSTO_OPE.f_sum_matxpuntoxetapa(s.codsolot, s.punto, s.codeta, 2,    3, null) Mat_liq_dol
FROM
   solotptoeta s;


