# Projet template

## Configuration par projet

Changer dans le `docker-compose.yml` :
- `<project_name>` par le nom de votre projet (formaté en snake_case)
- `<project_host>` par le sous-domaine de `traefik.me` auquel vous souhaitez y accéder

Après avoir fait le `just new-app` :
- Changer le name dans le `package.json`

## Passage sur pnpm sur la production

Convertir le `package-lock.json` en `pnpm-lock.yaml` avec la commande `pnpm import`
