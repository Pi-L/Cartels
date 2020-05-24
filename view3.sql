USE pyl_cartels;
-- individus sans groupe
CREATE VIEW `V_Chomage_technique` AS
SELECT DISTINCT ind.nom, ind.prenom FROM individu AS ind
LEFT JOIN lien_membre_groupe AS lmg ON ind.id=lmg.id_individu
WHERE lmg.id_groupe IS NULL
ORDER BY ind.nom ASC;