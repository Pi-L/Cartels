USE pyl_cartels;
-- 10 requetes avec un peu de tout

-- 1. selectionner les agents doubles hypocondriaques triés par ordre alpha ascendant sur le nom 
-- (on part du principe qu'un individu n'appartient OFFICIELLEMENT au maximum qu'à un groupe)
SELECT ind.nom, ind.prenom, ind.id FROM individu AS ind
JOIN lien_point_faible_individu AS lpfi ON ind.id = lpfi.id_individu
JOIN point_faible AS pf ON pf.id = lpfi.id_point_faible
WHERE ind.id IN (
	SELECT lmg.id_individu FROM lien_membre_groupe AS lmg 
	GROUP BY lmg.id_individu
    HAVING count(lmg.id_individu) > 1)
AND pf.nom = 'hypocondriaque'
ORDER BY ind.nom ASC;


-- 2. Afficher les relations intergroupes et le nom des groupes concernés, triées par type de relation
-- ("ORDER BY CAST" car typeDeRelation est de type ENUM)
SELECT trig.type_relation as typeDeRelation, grpa.nom as nom1, grpb.nom as nom2 FROM type_relation_inter_groupe AS trig
JOIN groupe AS grpa ON trig.id_groupe1=grpa.id
JOIN groupe AS grpb ON trig.id_groupe2=grpb.id
ORDER BY CAST(typeDeRelation AS CHAR) ASC;


-- 3. selectionner les agents doubles appartenant à 2 groupes ayant une relation cooperative
SELECT ind.prenom, ind.nom, grpa.nom AS nomGroupe1, grpb.nom AS nomGroupe2 FROM type_relation_inter_groupe AS trig
JOIN groupe AS grpa ON trig.id_groupe1=grpa.id
JOIN groupe AS grpb ON trig.id_groupe2=grpb.id
JOIN lien_membre_groupe AS lmga ON grpa.id = lmga.id_groupe
JOIN lien_membre_groupe AS lmgb ON grpb.id = lmgb.id_groupe
JOIN individu AS ind ON (ind.id = lmga.id_individu AND ind.id = lmgb.id_individu)
WHERE trig.type_relation = 'cooperative';


-- 4. Selectionner la moyenne d'age de chaque groupe en ordre croissant
SELECT grp.nom AS nomGroupe, ROUND(AVG(a.ages),1) AS moyenneAge FROM 
(
	SELECT id, TIMESTAMPDIFF(YEAR, ddn, CURDATE()) AS ages FROM individu
) 
AS a
JOIN lien_membre_groupe AS lmg ON a.id = lmg.id_individu
JOIN groupe AS grp ON grp.id = lmg.id_groupe
GROUP BY grp.nom
ORDER BY moyenneAge ASC;


-- 5. Selectionner les 5 pseudos les plus long triés du plus grand au plus petit
SELECT DISTINCT pseudo FROM lien_membre_groupe
ORDER BY CHAR_LENGTH(pseudo) DESC
LIMIT 0,5;


-- 6. Selectionner le nombre de membres des forces de l'ordre ayant moins de 30 ans
SELECT count(*) AS nbJeuneFDO FROM (
	SELECT ind.id FROM individu AS ind
    JOIN lien_membre_groupe AS lmg ON ind.id = lmg.id_individu
    JOIN role AS rl ON rl.id = lmg.id_role
	WHERE rl.nom IN ('federal agent', 'policier', 'militaire')
    AND ind.ddn IS NOT NULL
	AND TIMESTAMPDIFF(YEAR, ind.ddn, CURDATE()) < 30 
) AS jfdo;


-- 7. Calculer le budget total des groupes ayant des territoires au mexique
-- (idéalement il faudrait faire une boucle sur les territoires parents pour remonter jusque à la racine. Je ne remonte ici que d'un niveau)
SELECT SUM(grp.budjet) as budjet_mexique_tous_groupes FROM groupe AS grp
JOIN lien_territoire_groupe AS ltg ON grp.id = ltg.id_groupe
JOIN
(
	SELECT id FROM territoire 
	WHERE nom = 'mexique' 
	OR id_territoire_parent = 
		(SELECT id FROM territoire WHERE nom = 'mexique')
) AS ter
ON ltg.id_territoire = ter.id;


-- 8. Selectionner la moyenne du nombre de points faibles par individu pour chaque groupe trié par ordre descendant du nombre de faiblesses moyen
SELECT grp.nom AS nomGroupe, round(AVG(ind.pfcount),2) as moyenneFaiblesses FROM 
	(
    SELECT id, IFNULL(count(id_individu),0) as pfcount FROM lien_point_faible_individu 
	RIGHT JOIN individu AS ind ON id = id_individu 
	GROUP BY id
	) AS ind
JOIN lien_membre_groupe AS lmg ON lmg.id_individu = ind.id
JOIN groupe AS grp ON lmg.id_groupe = grp.id
GROUP BY grp.id
ORDER BY moyenneFaiblesses DESC;


-- 9. Selectionner le territoire où il y a le plus d'individus allergiques au celeri
SELECT tercount.nom, MAX(tercount.celcount) AS maxceleri FROM 
(
	SELECT count(ter.id) AS celcount, ter.nom FROM territoire AS ter
	JOIN lien_territoire_groupe AS ltg ON ter.id = ltg.id_territoire
	JOIN groupe AS grp ON grp.id = ltg.id_groupe
	JOIN lien_membre_groupe AS lmg ON lmg.id_groupe = grp.id
	JOIN individu AS ind ON lmg.id_individu = ind.id
	JOIN lien_point_faible_individu AS lpfi ON lpfi.id_individu = ind.id
	JOIN point_faible AS pf ON pf.id = lpfi.id_point_faible
	WHERE pf.nom LIKE '%celeri%'
	GROUP BY ter.id
) AS tercount;


-- 10. Selectionner les politiciens adeptes de la fraude fiscale
SELECT ind.prenom, lmg.pseudo, ind.nom FROM individu AS ind
JOIN lien_membre_groupe AS lmg ON ind.id = lmg.id_individu
JOIN role AS rl ON rl.id = lmg.id_role
JOIN lien_point_faible_individu AS lpfi ON lpfi.id_individu = ind.id
JOIN point_faible AS pf ON pf.id = lpfi.id_point_faible
WHERE pf.nom LIKE '%fisc%'
AND rl.nom = 'politicien'; 




