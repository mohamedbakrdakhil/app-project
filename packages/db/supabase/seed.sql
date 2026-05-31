-- ============================================================
-- Seed: Anatomy subject, Skeletal system chapter, 3 levels
-- ============================================================

INSERT INTO public.subjects (id, slug, name_fr, icon, color, description_fr, order_index, is_published)
VALUES (
  'anatomy',
  'anatomy',
  'Anatomie',
  '🦴',
  '#ff4d6d',
  'Étude de la structure du corps humain',
  1,
  true
)
ON CONFLICT (id) DO UPDATE
  SET name_fr = EXCLUDED.name_fr,
      is_published = EXCLUDED.is_published;

INSERT INTO public.chapters (subject_id, slug, title_fr, icon, order_index, is_published)
VALUES (
  'anatomy',
  'skeletal_system',
  'Système squelettique',
  '🦴',
  1,
  true
)
ON CONFLICT (subject_id, slug) DO UPDATE
  SET title_fr = EXCLUDED.title_fr,
      is_published = EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_femur_id uuid;
  v_level_tibia_id uuid;
  v_level_crane_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'skeletal_system';

  -- ---- Fémur ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'femur',
    'Le fémur',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le fémur",
          "subtitle": "Os long de la cuisse",
          "body": "Le fémur est l'os de la cuisse. Il participe à la transmission du poids du bassin vers le genou et sert de point d'insertion à de nombreux muscles.",
          "fact": "Le fémur est généralement décrit comme l'os le plus long et le plus robuste du corps humain.",
          "visual": {"type": "placeholder", "alt": "femur"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system", "note": "Référence générale, contenu réécrit de manière originale."}]
        },
        {
          "type": "recall",
          "questionKey": "femur_role_001",
          "question": "Quel est le rôle mécanique principal du fémur ?",
          "options": ["Transmettre le poids du bassin vers le genou", "Protéger directement l'encéphale", "Former la paroi principale du thorax", "Relier directement l'avant-bras à la main"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "femur_location_001",
          "question": "Où se situe le fémur dans le corps humain ?",
          "options": ["Dans la cuisse, entre la hanche et le genou", "Dans le bras, entre l'épaule et le coude", "Dans la jambe, entre le genou et la cheville", "Dans l'avant-bras, entre le coude et le poignet"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Fémur terminé",
          "body": "Tu connais maintenant le rôle général du fémur dans le membre inférieur.",
          "masteredConcepts": ["anatomy.skeletal.femur.basic_role", "anatomy.skeletal.femur.location"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_femur_id;

  IF v_level_femur_id IS NULL THEN
    SELECT id INTO v_level_femur_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'femur';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_femur_id,
    $json${
      "femur_role_001": {
        "correctIndex": 0,
        "explanation": "Le fémur transmet les contraintes mécaniques entre le bassin et le genou. Les autres propositions concernent le crâne, le thorax ou le membre supérieur.",
        "conceptKey": "anatomy.skeletal.femur.basic_role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "femur_location_001": {
        "correctIndex": 0,
        "explanation": "Le fémur est l'os unique de la cuisse, articulé en haut avec le bassin (articulation coxo-fémorale) et en bas avec le tibia et la rotule (articulation du genou).",
        "conceptKey": "anatomy.skeletal.femur.location",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Tibia ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'tibia',
    'Le tibia',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le tibia",
          "subtitle": "Os médial de la jambe",
          "body": "Le tibia est l'os médial de la jambe. C'est le principal os porteur du membre inférieur entre le genou et la cheville, supportant l'essentiel du poids corporel.",
          "fact": "Le tibia est le deuxième os le plus long du corps humain, après le fémur.",
          "visual": {"type": "placeholder", "alt": "tibia"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "recall",
          "questionKey": "tibia_vs_fibula_001",
          "question": "Entre le tibia et le fibula, lequel supporte le poids principal du corps ?",
          "options": ["Le tibia", "Le fibula", "Les deux également", "Ni l'un ni l'autre"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "tibia_articulations_001",
          "question": "Avec quels os le tibia s'articule-t-il ?",
          "options": ["Avec le fémur en haut et le talus en bas", "Avec l'humérus en haut et le carpe en bas", "Avec le bassin en haut et le fémur en bas", "Avec le radius en haut et la main en bas"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Tibia terminé",
          "body": "Tu connais maintenant le rôle général du tibia dans le membre inférieur.",
          "masteredConcepts": ["anatomy.skeletal.tibia.weight_bearing", "anatomy.skeletal.tibia.articulations"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_tibia_id;

  IF v_level_tibia_id IS NULL THEN
    SELECT id INTO v_level_tibia_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'tibia';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_tibia_id,
    $json${
      "tibia_vs_fibula_001": {
        "correctIndex": 0,
        "explanation": "Le tibia est l'os porteur principal de la jambe, transmettant environ 85% du poids corporel. Le fibula a principalement un rôle de stabilisation.",
        "conceptKey": "anatomy.skeletal.tibia.weight_bearing",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "tibia_articulations_001": {
        "correctIndex": 0,
        "explanation": "Le tibia s'articule en haut avec le fémur (articulation du genou) et en bas avec le talus (articulation de la cheville). Il s'articule aussi latéralement avec le fibula.",
        "conceptKey": "anatomy.skeletal.tibia.articulations",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Crâne ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'crane',
    'Le crâne',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le crâne",
          "subtitle": "Protection de l'encéphale",
          "body": "Le crâne est l'ensemble osseux qui protège l'encéphale et les organes des sens. Il comprend le neurocrâne (boîte crânienne) et le viscérocrâne (massif facial).",
          "fact": "Le crâne adulte est composé de 22 os, dont 8 forment la boîte crânienne et 14 le massif facial.",
          "visual": {"type": "placeholder", "alt": "crane"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "recall",
          "questionKey": "crane_fonction_001",
          "question": "Quelle est la fonction protectrice principale du crâne ?",
          "options": ["Protéger l'encéphale et les organes des sens", "Transmettre le poids du corps vers les membres", "Former la cage thoracique", "Constituer l'axe porteur du membre supérieur"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "crane_vs_autres_001",
          "question": "Quelle structure osseuse protège directement le cerveau ?",
          "options": ["Le crâne", "La colonne vertébrale", "Le thorax", "Le bassin"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Crâne terminé",
          "body": "Tu connais maintenant la fonction principale du crâne.",
          "masteredConcepts": ["anatomy.skeletal.crane.protection", "anatomy.skeletal.crane.structure"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_crane_id;

  IF v_level_crane_id IS NULL THEN
    SELECT id INTO v_level_crane_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'crane';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_crane_id,
    $json${
      "crane_fonction_001": {
        "correctIndex": 0,
        "explanation": "Le crâne (neurocrâne) forme une boîte osseuse rigide qui protège l'encéphale. Le viscérocrâne protège les organes des sens (yeux, oreilles internes, fosses nasales).",
        "conceptKey": "anatomy.skeletal.crane.protection",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "crane_vs_autres_001": {
        "correctIndex": 0,
        "explanation": "C'est le crâne, et plus précisément la boîte crânienne (neurocrâne), qui entoure et protège directement le cerveau. La colonne vertébrale protège la moelle épinière.",
        "conceptKey": "anatomy.skeletal.crane.structure",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Levels 4, 5, 6 — fibula, vertèbre, côtes (with fill_blank)
-- ============================================================
DO $$
DECLARE
  v_chapter_id uuid;
  v_level_fibula_id uuid;
  v_level_vertebre_id uuid;
  v_level_cotes_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'skeletal_system';

  -- ---- Fibula ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'fibula',
    'La fibula',
    4,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La fibula",
          "subtitle": "Os latéral de la jambe",
          "body": "La fibula est l'os latéral de la jambe, plus fin que le tibia. Elle joue un rôle important dans la stabilité de la cheville et sert de point d'attache à de nombreux muscles.",
          "fact": "La fibula ne supporte qu'environ 15% du poids corporel, mais elle est essentielle à la stabilité de la cheville.",
          "visual": {"type": "placeholder", "alt": "fibula"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "fibula_location_001",
          "prompt": "La fibula est l'os ___ de la jambe.",
          "hint": "Pense à sa position par rapport au tibia.",
          "xpReward": 10
        },
        {
          "type": "recall",
          "questionKey": "fibula_articulation_001",
          "question": "Quelle articulation principale forme la fibula avec le tibia ?",
          "options": ["La syndesmose tibio-fibulaire", "L'articulation coxo-fémorale", "L'articulation huméro-radiale", "La symphyse pubienne"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Fibula terminée",
          "body": "Tu connais maintenant la position et le rôle de la fibula.",
          "masteredConcepts": ["anatomy.skeletal.fibula.location", "anatomy.skeletal.fibula.role"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_fibula_id;

  IF v_level_fibula_id IS NULL THEN
    SELECT id INTO v_level_fibula_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'fibula';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_fibula_id,
    $json${
      "fibula_location_001": {
        "acceptedAnswers": ["latéral", "lateral", "externe"],
        "explanation": "La fibula est l'os latéral de la jambe, situé du côté externe par rapport au tibia qui est médial.",
        "conceptKey": "anatomy.skeletal.fibula.location",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "fibula_articulation_001": {
        "correctIndex": 0,
        "explanation": "La fibula s'articule avec le tibia par la syndesmose tibio-fibulaire (en haut et en bas). Cette union fibreuse assure la stabilité de la cheville.",
        "conceptKey": "anatomy.skeletal.fibula.role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Vertèbre type ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'vertebre_type',
    'La vertèbre type',
    5,
    'medium',
    120,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "La vertèbre type",
          "subtitle": "Structure de base",
          "body": "Une vertèbre type est composée d'un corps vertébral en avant, d'un arc vertébral en arrière, et de divers processus (épineux, transverses, articulaires). L'ensemble délimite le canal vertébral qui protège la moelle épinière.",
          "fact": "La colonne vertébrale humaine comprend 33 à 34 vertèbres réparties en 5 régions : cervicale, thoracique, lombaire, sacrée et coccygienne.",
          "visual": {"type": "placeholder", "alt": "vertebra"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "vertebre_canal_001",
          "prompt": "Le canal vertébral est délimité par le ___ en avant et l'arc vertébral en arrière.",
          "hint": "C'est la partie massive et cylindrique de la vertèbre.",
          "xpReward": 10
        },
        {
          "type": "recall",
          "questionKey": "vertebre_cervicales_001",
          "question": "Combien de vertèbres cervicales y a-t-il normalement ?",
          "options": ["7", "5", "12", "4"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Vertèbre type terminée",
          "body": "Tu connais maintenant la structure de base d'une vertèbre.",
          "masteredConcepts": ["anatomy.skeletal.vertebra.structure", "anatomy.skeletal.vertebra.cervical_count"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_vertebre_id;

  IF v_level_vertebre_id IS NULL THEN
    SELECT id INTO v_level_vertebre_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'vertebre_type';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_vertebre_id,
    $json${
      "vertebre_canal_001": {
        "acceptedAnswers": ["corps vertébral", "corps"],
        "explanation": "Le canal vertébral est délimité en avant par le corps vertébral et en arrière par l'arc vertébral. Il contient et protège la moelle épinière.",
        "conceptKey": "anatomy.skeletal.vertebra.structure",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "vertebre_cervicales_001": {
        "correctIndex": 0,
        "explanation": "Il y a normalement 7 vertèbres cervicales (C1 à C7). C1 est l'atlas, C2 est l'axis. Elles permettent les mouvements de la tête.",
        "conceptKey": "anatomy.skeletal.vertebra.cervical_count",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les côtes ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'cotes',
    'Les côtes',
    6,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Les côtes",
          "subtitle": "Cage thoracique",
          "body": "Les côtes sont des os plats et incurvés qui forment la cage thoracique. On distingue les vraies côtes (articulées directement avec le sternum), les fausses côtes (reliées au sternum via le cartilage costal commun) et les côtes flottantes (sans attache sternale).",
          "fact": "Nous avons 12 paires de côtes, soit 24 côtes au total, qui protègent le cœur, les poumons et les gros vaisseaux.",
          "visual": {"type": "placeholder", "alt": "cotes"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "cotes_vraies_001",
          "prompt": "Les ___ premières paires de côtes sont appelées vraies côtes car elles s'articulent directement avec le sternum.",
          "hint": "Un chiffre entre 5 et 10.",
          "xpReward": 10
        },
        {
          "type": "recall",
          "questionKey": "cotes_flottantes_001",
          "question": "Que sont les côtes flottantes ?",
          "options": ["Les côtes 11 et 12 qui n'atteignent pas le sternum", "Les côtes qui se déplacent à l'inspiration", "Les côtes articulées avec le cartilage costal commun", "Les côtes cervicales surnuméraires"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Côtes terminées",
          "body": "Tu connais maintenant la classification des côtes.",
          "masteredConcepts": ["anatomy.skeletal.ribs.classification", "anatomy.skeletal.ribs.count"]
        }
      ]
    }$json$::jsonb,
    'reviewed',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE
    SET title_fr = EXCLUDED.title_fr,
        content_public = EXCLUDED.content_public,
        is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_cotes_id;

  IF v_level_cotes_id IS NULL THEN
    SELECT id INTO v_level_cotes_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'cotes';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_cotes_id,
    $json${
      "cotes_vraies_001": {
        "acceptedAnswers": ["7", "sept"],
        "explanation": "Les 7 premières paires de côtes sont les vraies côtes : elles s'articulent directement avec le sternum via leur cartilage costal propre. Les côtes 8 à 10 sont les fausses côtes et les côtes 11 et 12 sont les côtes flottantes.",
        "conceptKey": "anatomy.skeletal.ribs.classification",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      },
      "cotes_flottantes_001": {
        "correctIndex": 0,
        "explanation": "Les côtes flottantes (11e et 12e paires) n'ont aucune attache au sternum, ni directe ni indirecte. Elles se terminent librement dans les muscles de la paroi abdominale.",
        "conceptKey": "anatomy.skeletal.ribs.count",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Skeletal system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Seed: Muscular system chapter + 3 levels
-- ============================================================

INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES (
  'anatomy',
  'muscular_system',
  'Système musculaire',
  'Les muscles, leurs insertions et leurs fonctions principales.',
  '💪',
  2,
  true
)
ON CONFLICT (subject_id, slug) DO UPDATE SET
  title_fr = EXCLUDED.title_fr,
  description_fr = EXCLUDED.description_fr,
  icon = EXCLUDED.icon,
  order_index = EXCLUDED.order_index,
  is_published = EXCLUDED.is_published;

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_biceps_id uuid;
  v_level_quadriceps_id uuid;
  v_level_diaphragme_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'anatomy' AND slug = 'muscular_system';

  -- ---- Biceps brachial ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'biceps_brachial',
    'Le muscle biceps brachial',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le muscle biceps brachial",
          "subtitle": "Flexion et supination",
          "body": "Le biceps brachial est un muscle de la loge antérieure du bras. Il possède deux chefs d'origine : la longue portion (s'attachant au tubercule supra-glénoïdal) et la courte portion (s'attachant au processus coracoïde). Sa principale fonction est la flexion du coude et la supination de l'avant-bras.",
          "fact": "Le biceps brachial est le muscle le plus souvent représenté dans les illustrations anatomiques populaires.",
          "visual": {"type": "placeholder", "alt": "biceps brachial"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
        },
        {
          "type": "recall",
          "questionKey": "biceps_role_001",
          "question": "Quel est le rôle principal du biceps brachial ?",
          "options": ["Flexion du coude et supination de l'avant-bras", "Extension du coude", "Abduction de l'épaule", "Flexion du genou"],
          "correctIndex": 0,
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "biceps_chefs_001",
          "prompt": "Le muscle biceps brachial possède ___ chefs d'origine.",
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Biceps terminé",
          "body": "Tu connais maintenant le rôle et la structure du biceps brachial.",
          "masteredConcepts": ["anatomy.muscular.biceps.role", "anatomy.muscular.biceps.heads"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_biceps_id;

  IF v_level_biceps_id IS NULL THEN
    SELECT id INTO v_level_biceps_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'biceps_brachial';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_biceps_id,
    $json${
      "biceps_role_001": {
        "correctIndex": 0,
        "explanation": "Le biceps brachial est principalement fléchisseur du coude et supinateur de l'avant-bras. Il agit aussi comme faible fléchisseur de l'épaule.",
        "conceptKey": "anatomy.muscular.biceps.role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      },
      "biceps_chefs_001": {
        "acceptedAnswers": ["deux", "2"],
        "explanation": "Le biceps brachial possède deux chefs : la longue portion et la courte portion, d'où son nom (bi = deux, ceps = têtes).",
        "conceptKey": "anatomy.muscular.biceps.heads",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Quadriceps fémoral ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'quadriceps_femoral',
    'Le muscle quadriceps fémoral',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le muscle quadriceps fémoral",
          "subtitle": "Extension du genou",
          "body": "Le quadriceps fémoral est le plus volumineux muscle du corps humain. Il est composé de quatre chefs : le droit fémoral, le vaste latéral, le vaste médial et le vaste intermédiaire. Sa principale fonction est l'extension du genou.",
          "fact": "Le quadriceps fémoral peut exercer une force de plusieurs centaines de kilogrammes lors des sauts et sprints.",
          "visual": {"type": "placeholder", "alt": "quadriceps femoral"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
        },
        {
          "type": "fill_blank",
          "questionKey": "quadriceps_chefs_001",
          "prompt": "Le quadriceps fémoral est composé de ___ chefs musculaires.",
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "recall",
          "questionKey": "quadriceps_fonction_001",
          "question": "Quelle est la fonction principale du quadriceps fémoral ?",
          "options": ["Extension du genou", "Flexion du genou", "Abduction de la hanche", "Rotation interne du genou"],
          "correctIndex": 0,
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Quadriceps terminé",
          "body": "Tu connais maintenant la structure et la fonction du quadriceps fémoral.",
          "masteredConcepts": ["anatomy.muscular.quadriceps.structure", "anatomy.muscular.quadriceps.function"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_quadriceps_id;

  IF v_level_quadriceps_id IS NULL THEN
    SELECT id INTO v_level_quadriceps_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'quadriceps_femoral';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_quadriceps_id,
    $json${
      "quadriceps_chefs_001": {
        "acceptedAnswers": ["quatre", "4"],
        "explanation": "Le quadriceps fémoral comprend quatre chefs : le droit fémoral, le vaste latéral, le vaste médial et le vaste intermédiaire.",
        "conceptKey": "anatomy.muscular.quadriceps.structure",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      },
      "quadriceps_fonction_001": {
        "correctIndex": 0,
        "explanation": "Le quadriceps fémoral est l'extenseur du genou. Il joue un rôle essentiel dans la marche, la course, et toutes les activités nécessitant l'extension du membre inférieur.",
        "conceptKey": "anatomy.muscular.quadriceps.function",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Diaphragme ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'diaphragme',
    'Le diaphragme',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 4,
      "disclaimer": "Contenu éducatif. Ne remplace pas un avis médical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le diaphragme",
          "subtitle": "Muscle principal de la respiration",
          "body": "Le diaphragme est le muscle respiratoire principal. Il sépare la cavité thoracique de la cavité abdominale. À l'inspiration, il s'abaisse, augmentant le volume thoracique et permettant l'entrée d'air dans les poumons.",
          "fact": "Le diaphragme se contracte environ 20 000 fois par jour lors de la respiration normale.",
          "visual": {"type": "placeholder", "alt": "diaphragme"},
          "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
        },
        {
          "type": "recall",
          "questionKey": "diaphragme_role_001",
          "question": "Quel est le rôle principal du diaphragme ?",
          "options": ["Muscle principal de la respiration", "Muscle de la déglutition", "Muscle de la mastication", "Muscle de la phonation"],
          "correctIndex": 0,
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "diaphragme_separation_001",
          "prompt": "Le diaphragme sépare la cavité ___ de la cavité abdominale.",
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "complete",
          "title": "Diaphragme terminé",
          "body": "Tu connais maintenant le rôle et la localisation du diaphragme.",
          "masteredConcepts": ["anatomy.muscular.diaphragm.role", "anatomy.muscular.diaphragm.location"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_diaphragme_id;

  IF v_level_diaphragme_id IS NULL THEN
    SELECT id INTO v_level_diaphragme_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'diaphragme';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_diaphragme_id,
    $json${
      "diaphragme_role_001": {
        "correctIndex": 0,
        "explanation": "Le diaphragme est le muscle principal de la respiration. Sa contraction abaisse le plancher thoracique et crée une dépression permettant l'entrée d'air dans les poumons.",
        "conceptKey": "anatomy.muscular.diaphragm.role",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      },
      "diaphragme_separation_001": {
        "acceptedAnswers": ["thoracique", "thorax"],
        "explanation": "Le diaphragme est une cloison musculo-tendineuse qui sépare la cavité thoracique (contenant le coeur et les poumons) de la cavité abdominale.",
        "conceptKey": "anatomy.muscular.diaphragm.location",
        "sourceRefs": [{"title": "Open educational anatomy references", "type": "open_educational", "chapter": "Muscular system"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Ticket 09: Physiologie, Histologie, Pharmacologie subjects
-- ============================================================

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'physiology',
  'Physiologie',
  'Physiology',
  '🫀',
  '#00d4ff',
  'Comprends le fonctionnement des organes et des systèmes du corps humain.',
  2,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'histology',
  'Histologie',
  'Histology',
  '🔬',
  '#aa77ff',
  'Explore la structure microscopique des tissus biologiques.',
  3,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

INSERT INTO public.subjects (id, name_fr, name_en, icon, color, description_fr, order_index, is_published)
VALUES (
  'pharmacology',
  'Pharmacologie',
  'Pharmacology',
  '💊',
  '#ffb347',
  'Les médicaments, leurs mécanismes d''action et leurs effets.',
  4,
  true
)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr, name_en = EXCLUDED.name_en, icon = EXCLUDED.icon,
  color = EXCLUDED.color, description_fr = EXCLUDED.description_fr,
  order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- Physiologie — Chapitre cardiovascular
INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('physiology', 'cardiovascular', 'Système cardiovasculaire', 'Le coeur, les vaisseaux et la circulation sanguine.', '❤️', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr, icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- Histologie — Chapitre fundamental_tissues
INSERT INTO public.chapters (subject_id, slug, title_fr, description_fr, icon, order_index, is_published)
VALUES ('histology', 'fundamental_tissues', 'Tissus fondamentaux', 'Les quatre grands types de tissus du corps humain.', '🔬', 1, true)
ON CONFLICT (subject_id, slug) DO UPDATE SET title_fr = EXCLUDED.title_fr, description_fr = EXCLUDED.description_fr, icon = EXCLUDED.icon, order_index = EXCLUDED.order_index, is_published = EXCLUDED.is_published;

-- ============================================================
-- Physiologie — Systeme cardiovasculaire — 3 niveaux
-- ============================================================

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_heart_id uuid;
  v_level_circulation_id uuid;
  v_level_pressure_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'physiology' AND slug = 'cardiovascular';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter physiology/cardiovascular not found';
  END IF;

  -- ---- Le coeur — structure generale ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'heart_structure',
    'Le coeur — structure generale',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le coeur — structure generale",
          "subtitle": "Muscle creux et pompe centrale",
          "body": "Le coeur est un muscle creux situe dans le mediastin, entre les deux poumons. Il est compose de 4 cavites : 2 oreillettes (en haut) et 2 ventricules (en bas). Il pompe le sang en deux circuits : le circuit pulmonaire et le circuit systemique.",
          "fact": "Le coeur bat environ 100 000 fois par jour et pompe pres de 8 000 litres de sang.",
          "visual": {"type": "placeholder", "alt": "coeur"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "image_label",
          "title": "Les 4 cavites du coeur",
          "imageAlt": "Schema simplifie des cavites cardiaques",
          "labels": [
            {"id": "og", "text": "Oreillette gauche", "position": {"x": 30, "y": 35}},
            {"id": "od", "text": "Oreillette droite", "position": {"x": 70, "y": 35}},
            {"id": "vg", "text": "Ventricule gauche", "position": {"x": 30, "y": 65}},
            {"id": "vd", "text": "Ventricule droit", "position": {"x": 70, "y": 65}}
          ],
          "caption": "Schema educatif simplifie — contenu original",
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "heart_cavities_001",
          "question": "Combien de cavites possede le coeur ?",
          "options": ["4 — 2 oreillettes et 2 ventricules", "2 — 1 oreillette et 1 ventricule", "3 — 2 oreillettes et 1 ventricule", "6 — 3 de chaque cote"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "heart_location_001",
          "prompt": "Le coeur est situe dans le ___.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Structure du coeur maitrisee",
          "body": "Tu connais maintenant la structure generale et la localisation du coeur.",
          "masteredConcepts": ["physiology.cardiovascular.heart.structure", "physiology.cardiovascular.heart.location"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_heart_id;

  IF v_level_heart_id IS NULL THEN
    SELECT id INTO v_level_heart_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'heart_structure';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_heart_id,
    $json${
      "heart_cavities_001": {
        "correctIndex": 0,
        "explanation": "Le coeur possede 4 cavites : 2 oreillettes (droite et gauche) en haut, et 2 ventricules (droit et gauche) en bas.",
        "conceptKey": "physiology.cardiovascular.heart.structure",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "heart_location_001": {
        "acceptedAnswers": ["mediastin"],
        "explanation": "Le coeur est situe dans le mediastin, la region centrale du thorax entre les deux poumons.",
        "conceptKey": "physiology.cardiovascular.heart.location",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La circulation sanguine ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'blood_circulation',
    'La circulation sanguine',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "La circulation sanguine",
          "subtitle": "Deux circuits complementaires",
          "body": "Le coeur alimente deux circuits : le circuit pulmonaire (coeur droit vers poumons puis coeur gauche) pour l'oxygenation du sang, et le circuit systemique (coeur gauche vers corps puis coeur droit) pour la distribution aux organes. Les arteres transportent le sang oxygene (sauf les arteres pulmonaires) et les veines ramenent le sang desoxygene (sauf les veines pulmonaires).",
          "fact": "Le sang effectue un tour complet du circuit en environ 1 minute au repos.",
          "visual": {"type": "placeholder", "alt": "circulation sanguine"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "circulation_pulmonaire_001",
          "question": "Que transporte principalement le circuit pulmonaire ?",
          "options": ["Le sang du coeur droit vers les poumons pour oxygenation", "Le sang du coeur gauche vers le corps", "Le sang oxygene vers les organes", "Le sang des membres vers le foie"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "circulation_coeur_001",
          "prompt": "Le sang part du coeur ___ vers les poumons dans la circulation pulmonaire.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Circulation sanguine maitrisee",
          "body": "Tu comprends maintenant les deux grands circuits de la circulation sanguine.",
          "masteredConcepts": ["physiology.cardiovascular.circulation.pulmonary", "physiology.cardiovascular.circulation.systemic"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_circulation_id;

  IF v_level_circulation_id IS NULL THEN
    SELECT id INTO v_level_circulation_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'blood_circulation';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_circulation_id,
    $json${
      "circulation_pulmonaire_001": {
        "correctIndex": 0,
        "explanation": "Le circuit pulmonaire achemine le sang desoxygene du coeur droit vers les poumons, ou il se charge en oxygene avant de revenir au coeur gauche.",
        "conceptKey": "physiology.cardiovascular.circulation.pulmonary",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "circulation_coeur_001": {
        "acceptedAnswers": ["droit", "cote droit"],
        "explanation": "Dans la circulation pulmonaire, le sang part du coeur droit (ventricule droit) pour aller se charger en oxygene dans les poumons.",
        "conceptKey": "physiology.cardiovascular.circulation.systemic",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- La pression arterielle ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'blood_pressure',
    'La pression arterielle',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "La pression arterielle",
          "subtitle": "Systolique et diastolique",
          "body": "La pression arterielle est la force exercee par le sang sur les parois des arteres. Elle se mesure en deux valeurs : la pression systolique (lors de la contraction du ventricule) et la pression diastolique (lors du relachement). Les valeurs normales sont environ 120/80 mmHg.",
          "fact": "L'hypertension arterielle (superieure a 140/90 mmHg) est l'un des principaux facteurs de risque cardiovasculaire.",
          "visual": {"type": "placeholder", "alt": "pression arterielle"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "blood_pressure_systolic_001",
          "question": "Que mesure la pression systolique ?",
          "options": ["La pression lors de la contraction ventriculaire", "La pression lors du repos du coeur", "La frequence des battements", "Le volume sanguin total"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "blood_pressure_normal_001",
          "prompt": "La valeur normale de pression arterielle est approximativement ___ mmHg.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Pression arterielle maitrisee",
          "body": "Tu sais maintenant ce qu'est la pression arterielle et ses valeurs normales.",
          "masteredConcepts": ["physiology.cardiovascular.blood_pressure.definition", "physiology.cardiovascular.blood_pressure.normal_values"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_pressure_id;

  IF v_level_pressure_id IS NULL THEN
    SELECT id INTO v_level_pressure_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'blood_pressure';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_pressure_id,
    $json${
      "blood_pressure_systolic_001": {
        "correctIndex": 0,
        "explanation": "La pression systolique correspond a la pression maximale lors de la contraction (systole) du ventricule gauche.",
        "conceptKey": "physiology.cardiovascular.blood_pressure.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "blood_pressure_normal_001": {
        "acceptedAnswers": ["120/80", "12/8"],
        "explanation": "Les valeurs normales de pression arterielle sont 120 mmHg (systolique) sur 80 mmHg (diastolique), soit 120/80 mmHg.",
        "conceptKey": "physiology.cardiovascular.blood_pressure.normal_values",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;

-- ============================================================
-- Histologie — Tissus fondamentaux — 3 niveaux
-- ============================================================

DO $$
DECLARE
  v_chapter_id uuid;
  v_level_epithelial_id uuid;
  v_level_connective_id uuid;
  v_level_muscle_nerve_id uuid;
BEGIN
  SELECT id INTO v_chapter_id
    FROM public.chapters
   WHERE subject_id = 'histology' AND slug = 'fundamental_tissues';

  IF v_chapter_id IS NULL THEN
    RAISE EXCEPTION 'Chapter histology/fundamental_tissues not found';
  END IF;

  -- ---- Le tissu epithelial ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'epithelial_tissue',
    'Le tissu epithelial',
    1,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le tissu epithelial",
          "subtitle": "Revetement et protection",
          "body": "Le tissu epithelial recouvre les surfaces internes et externes du corps. Ses fonctions principales sont la protection, l'absorption et la secretion. On distingue l'epithelium simple (une seule couche de cellules) de l'epithelium stratifie (plusieurs couches).",
          "fact": "L'epiderme, la couche superficielle de la peau, est un epithelium stratifie squameux.",
          "visual": {"type": "placeholder", "alt": "tissu epithelial"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "epithelial_function_001",
          "question": "Quelle est la fonction principale du tissu epithelial de revetement ?",
          "options": ["Recouvrir et proteger les surfaces du corps", "Transmettre les influx nerveux", "Contracter les organes", "Stocker les graisses"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "epithelial_simple_001",
          "prompt": "Un epithelium ___ est compose d'une seule couche de cellules.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Tissu epithelial maitrise",
          "body": "Tu connais maintenant la definition et la classification du tissu epithelial.",
          "masteredConcepts": ["histology.epithelial.definition", "histology.epithelial.simple_vs_stratified"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_epithelial_id;

  IF v_level_epithelial_id IS NULL THEN
    SELECT id INTO v_level_epithelial_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'epithelial_tissue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_epithelial_id,
    $json${
      "epithelial_function_001": {
        "correctIndex": 0,
        "explanation": "Le tissu epithelial de revetement forme une barriere protectrice a la surface des organes et des cavites du corps.",
        "conceptKey": "histology.epithelial.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "epithelial_simple_001": {
        "acceptedAnswers": ["simple", "unistratifie"],
        "explanation": "Un epithelium simple ne contient qu'une seule couche de cellules, toutes en contact avec la membrane basale.",
        "conceptKey": "histology.epithelial.simple_vs_stratified",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Le tissu conjonctif ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'connective_tissue',
    'Le tissu conjonctif',
    2,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Le tissu conjonctif",
          "subtitle": "Soutien et liaison",
          "body": "Le tissu conjonctif assure le soutien et la liaison entre les autres tissus. Il est compose de cellules (fibroblastes, adipocytes, macrophages) et d'une matrice extracellulaire riche en fibres de collagene et fibres elastiques. Il existe de nombreuses formes : lache, dense, graisseux, osseux, cartilagineux et sanguin.",
          "fact": "Le collagene est la proteine la plus abondante du corps humain, representant environ 25 a 35 % des proteines totales.",
          "visual": {"type": "placeholder", "alt": "tissu conjonctif"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "connective_collagen_001",
          "question": "Quel est le composant principal de la matrice extracellulaire du tissu conjonctif dense ?",
          "options": ["Les fibres de collagene", "Les fibres musculaires", "Les axones nerveux", "Les villosites intestinales"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "connective_fibroblasts_001",
          "prompt": "Les ___ sont les cellules productrices de fibres dans le tissu conjonctif.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "Tissu conjonctif maitrise",
          "body": "Tu connais maintenant la composition et les roles du tissu conjonctif.",
          "masteredConcepts": ["histology.connective.definition", "histology.connective.components"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_connective_id;

  IF v_level_connective_id IS NULL THEN
    SELECT id INTO v_level_connective_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'connective_tissue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_connective_id,
    $json${
      "connective_collagen_001": {
        "correctIndex": 0,
        "explanation": "Dans le tissu conjonctif dense, les fibres de collagene (type I) constituent la majorite de la matrice extracellulaire.",
        "conceptKey": "histology.connective.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "connective_fibroblasts_001": {
        "acceptedAnswers": ["fibroblastes", "fibroblaste"],
        "explanation": "Les fibroblastes sont les cellules principales du tissu conjonctif. Ils synthetisent le collagene et d'autres composants de la matrice extracellulaire.",
        "conceptKey": "histology.connective.components",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

  -- ---- Les tissus musculaire et nerveux ----
  INSERT INTO public.levels (chapter_id, slug, title_fr, order_index, difficulty, xp_reward, content_public, content_status, is_published)
  VALUES (
    v_chapter_id,
    'muscle_nerve_tissue',
    'Tissus musculaire et nerveux',
    3,
    'easy',
    100,
    $json${
      "schemaVersion": 1,
      "locale": "fr",
      "estimatedMinutes": 5,
      "disclaimer": "Contenu educatif. Ne remplace pas un avis medical.",
      "steps": [
        {
          "type": "intro",
          "title": "Tissus musculaire et nerveux",
          "subtitle": "Les 4 tissus fondamentaux",
          "body": "Le tissu musculaire se decline en trois types : strie squelettique (volontaire), strie cardiaque (involontaire) et lisse (involontaire). Le tissu nerveux est compose de neurones (cellules conductrices) et de cellules gliales (soutien). Ces quatre types — epithelial, conjonctif, musculaire, nerveux — forment la base de tous les organes.",
          "fact": "Le cerveau humain contient environ 86 milliards de neurones.",
          "visual": {"type": "placeholder", "alt": "tissus musculaire et nerveux"},
          "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
        },
        {
          "type": "recall",
          "questionKey": "tissue_types_count_001",
          "question": "Combien y a-t-il de types de tissus fondamentaux dans le corps humain ?",
          "options": ["4 — epithelial, conjonctif, musculaire, nerveux", "3 — epithelial, musculaire, nerveux", "5 — epithelial, conjonctif, musculaire, nerveux, osseux", "2 — mou et dur"],
          "timerSeconds": 45,
          "xpReward": 15
        },
        {
          "type": "fill_blank",
          "questionKey": "cardiac_muscle_001",
          "prompt": "Le tissu musculaire cardiaque est ___ et involontaire.",
          "timerSeconds": 45,
          "xpReward": 10
        },
        {
          "type": "complete",
          "title": "4 tissus fondamentaux maitrises",
          "body": "Tu connais maintenant les quatre grands types de tissus fondamentaux du corps humain.",
          "masteredConcepts": ["histology.muscle_tissue.types", "histology.nerve_tissue.definition"]
        }
      ]
    }$json$::jsonb,
    'published',
    true
  )
  ON CONFLICT (chapter_id, slug) DO UPDATE SET
    title_fr = EXCLUDED.title_fr,
    content_public = EXCLUDED.content_public,
    is_published = EXCLUDED.is_published
  RETURNING id INTO v_level_muscle_nerve_id;

  IF v_level_muscle_nerve_id IS NULL THEN
    SELECT id INTO v_level_muscle_nerve_id FROM public.levels WHERE chapter_id = v_chapter_id AND slug = 'muscle_nerve_tissue';
  END IF;

  INSERT INTO public.level_answer_keys (level_id, answers)
  VALUES (
    v_level_muscle_nerve_id,
    $json${
      "tissue_types_count_001": {
        "correctIndex": 0,
        "explanation": "Il existe 4 types de tissus fondamentaux : epithelial (revetement), conjonctif (soutien), musculaire (contraction) et nerveux (conduction).",
        "conceptKey": "histology.muscle_tissue.types",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      },
      "cardiac_muscle_001": {
        "acceptedAnswers": ["strie", "strie cardiaque"],
        "explanation": "Le muscle cardiaque est qualifie de strie car ses cellules presentent des stries transversales visibles en microscopie.",
        "conceptKey": "histology.nerve_tissue.definition",
        "sourceRefs": [{"title": "Open educational references", "type": "open_educational"}]
      }
    }$json$::jsonb
  )
  ON CONFLICT (level_id) DO UPDATE SET answers = EXCLUDED.answers;

END $$;
