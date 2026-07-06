# Opération NordCloud — Livret d'équipe (Jour 4)

Escape Game **Cloud & Sécurité** — Ynov Campus.

NordCloud est une jeune entreprise e-commerce dont l'infrastructure a été montée dans
l'urgence, sans discipline de coûts ni de conformité. La mission : **auditer**, **mettre
en conformité**, puis **reconstruire** une architecture 3-tiers saine et documentée avant
l'audit de demain matin.

Ce dépôt regroupe les livrables de l'équipe : la résolution des énigmes (codes) et le
dossier de mission (architecture 3-tiers décrite en Terraform).

## 🔐 Codes des salles

| Salle | Chapitre | Code |
|:-----:|----------|:----:|
| 1 | L'Audit des coûts (FinOps) | `12435` |

---

## Salle 1 — L'Audit des coûts (FinOps)

Pour chaque ressource, on identifie le levier d'optimisation qui s'applique, dans
l'ordre du tableau. Le code est la suite des 5 numéros.

**Leviers**
1. Rightsizing — la ressource est surdimensionnée
2. Extinction programmée — tourne en continu alors qu'elle ne sert qu'une partie du temps
3. Ajouter des tags — la ressource n'est pas étiquetée
4. Cycle de vie du stockage — donnée froide à basculer vers un stockage économique
5. Aucune action nécessaire — bien dimensionnée et correctement gérée

| Ordre | Ressource | Constat | Levier |
|:-----:|-----------|---------|:------:|
| 1 | `srv-dev-lourd` | 8 vCPU pour 4 % d'usage → surdimensionné | **1** |
| 2 | `srv-recette-nuit` | Allumé 24h/24 mais utilisé seulement la nuit | **2** |
| 3 | `vol-arch-2022` | Volume, dernier accès il y a 300 j → donnée froide | **4** |
| 4 | `srv-api-sans-tag` | Charge saine (82 %) mais **non taggé** | **3** |
| 5 | `srv-web-prod-ok` | Bien dimensionné, taggé, charge cohérente | **5** |

### ✅ Code Salle 1 : `12435`
