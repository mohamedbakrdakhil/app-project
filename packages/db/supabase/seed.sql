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
          "visual": {"type": "placeholder", "alt": "Schéma simplifié du fémur"},
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
          "visual": {"type": "placeholder", "alt": "Schéma simplifié du tibia"},
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
          "visual": {"type": "placeholder", "alt": "Schéma simplifié du crâne"},
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
