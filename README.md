# Opération NordCloud — Livret d'équipe (Jour 4)

> **Équipe : Tartampion** — Farid · Valentin · Dylan · Sylvain
> **Codes trouvés : Salle 1 → `12435` · Salle 2 → `312`**

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
| 2 | La Chambre de conformité | `312` |

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

---

## Salle 2 — La Chambre de conformité

### Énigme B (obligatoire) — Associer chaque référentiel à sa définition

| Description | Référentiel | N° |
|-------------|-------------|:--:|
| (i) Qualification ANSSI, immunité aux lois extraterritoriales non-UE | SecNumCloud | **3** |
| (ii) Réglementation européenne des données personnelles | RGPD | **1** |
| (iii) Norme internationale de sécurité de l'info, spécifique cloud | ISO 27017 | **2** |

Suite des numéros dans l'ordre (i), (ii), (iii).

### ✅ Code Salle 2 : `312`

### Énigme A (bonus) — Qui est responsable de quoi ?

Modèle de responsabilité partagée : `Client (1)` = utilisateur du cloud,
`Fournisseur (2)` = OVHcloud.

| Responsabilité | Responsable |
|----------------|:-----------:|
| Sécurité physique des datacenters | Fournisseur (2) |
| Configuration des Security Groups | Client (1) |
| Virtualisation et hyperviseur | Fournisseur (2) |
| Gestion des comptes utilisateurs (IAM) | Client (1) |
| Chiffrement des données au repos (activation) | Client (1) |
| Infrastructure réseau globale (backbone) | Fournisseur (2) |

---

## Salle 3 — Le Coffre : ouverture du dossier de mission

Les codes `12435` et `312` sont vérifiés (format et cohérence). Le coffre s'ouvre et
révèle le **dossier de mission** : reconstruire une architecture 3-tiers pour NordCloud,
décrite en Infrastructure as Code (Terraform), sécurisée et conforme.

**Les 3 tiers**
- **Présentation** — interface accessible, seul tier exposé à Internet.
- **Application** — instances exécutant la logique métier, réseau privé.
- **Données** — base isolée, accès restreint, volume chiffré.

---

## Salle 4 — La Forge : reconstruction de l'architecture

L'architecture est décrite en Terraform (dossier `terraform/`, modulaire).

### Schéma des flux réseau

```
        Internet
           │ 443
           ▼
  ┌──────────────────┐
  │   PRÉSENTATION   │  IP publique — SG : 443 monde, 22 admin
  └──────────────────┘
           │ 8080
           ▼
  ┌──────────────────┐
  │   APPLICATION    │  privé — SG : 8080 depuis présentation, 22 admin
  └──────────────────┘
           │ 5432
           ▼
  ┌──────────────────┐
  │     DONNÉES      │  privé, volume chiffré — SG : 5432 depuis application
  └──────────────────┘
```

### Security Groups en couches

| Tier | Entrant autorisé | Source |
|------|------------------|--------|
| Présentation | 443 (HTTPS) | Internet |
| Présentation | 22 (SSH) | CIDR admin uniquement |
| Application | 8080 | Security Group présentation |
| Application | 22 (SSH) | CIDR admin uniquement |
| Données | 5432 (PostgreSQL) | Security Group application |
| Données | 22 (SSH) | CIDR admin uniquement |

Le tier données n'accepte **que** l'application : il n'est jamais joignable depuis
Internet ni depuis la présentation.

### Sécurité appliquée

- **IAM à privilège minimal** : un utilisateur de service par tier.
- **Chiffrement au repos** : le volume de données utilise un type de volume chiffré.
- **Segmentation réseau** : chaque tier dans son sous-réseau, seul le tier présentation
  a une IP publique.
- **Aucun secret dans le code** : identifiants injectés par variables d'environnement.

### Optimisation des coûts (écho Salle 1)

- **Rightsizing** : gabarits adaptés à chaque tier (petit pour la présentation).
- **Tags** : toutes les ressources portent `project` / `environment` / `owner`.
- **Scalabilité horizontale** : le nombre d'instances applicatives est paramétrable.

### Conformité (écho Salle 2)

| Référentiel | Application au projet |
|-------------|-----------------------|
| RGPD | Déploiement en région UE, données personnelles isolées et chiffrées |
| ISO 27017 | Segmentation réseau, IAM par tier, chiffrement des volumes |
| SecNumCloud | Hébergement OVHcloud (offre qualifiable), pas de dépendance extra-UE |

### Déploiement

```bash
cd terraform
# charger les identifiants OVHcloud (fichier openrc) puis :
terraform init
terraform plan
terraform apply
```

---

## Salle 5 — L'Audit final : finalisation et dépôt

**Équipe : Tartampion** — Farid, Valentin, Dylan, Sylvain.

**Grille de progression**

| Salle | Code trouvé | Temps pris | Indices utilisés |
|-------|-------------|:----------:|:----------------:|
| 1 — Audit des coûts | `12435` | ~15 min | 0 |
| 2 — Conformité | `312` | ~10 min | 0 |
| 3 — Coffre (mission) | — | ~10 min | 0 |
| 4 — La Forge (projet) | — | ~1h | 0 |
| 5 — Audit final | — | ~20 min | 0 |

**Rendu**
- Architecture 3-tiers décrite en Terraform (`terraform/`), modulaire et validée.
- Sécurité : Security Groups en couches, IAM par tier, chiffrement au repos.
- Conformité RGPD / ISO 27017 / SecNumCloud et leviers de coûts appliqués.
- Codes des salles et raisonnements documentés dans ce README.
