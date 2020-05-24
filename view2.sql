USE pyl_cartels;
-- Le nombre de faiblesse pour chaque individu trié par ordre decroissant
CREATE VIEW `V_Cibles_Potentielles` AS
SELECT ind.prenom, ind.nom, count(pf.id) AS nbFaiblesses FROM individu AS ind
JOIN lien_point_faible_individu AS lpfi ON ind.id=lpfi.id_individu
JOIN point_faible AS pf ON pf.id=lpfi.id_point_faible
GROUP BY ind.id
ORDER BY nbFaiblesses DESC;