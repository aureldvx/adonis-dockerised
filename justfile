COMPOSE_RUN := "docker compose run --rm"
COMPOSE_NODE := COMPOSE_RUN + " node"
COMPOSE_ACE := COMPOSE_NODE + " ace"
COMPOSE_NPM := COMPOSE_NODE + " npm"

EDITOR_CONFIG_TEMPLATE := '''
root = true

[*]
charset = utf-8
indent_style = tab
tab_width = 2
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.{yml,yaml}]
indent_style = space
indent_size = 4

[justfile]
tab_width = 4

[*.json]
insert_final_newline = false

[*.md]
trim_trailing_whitespace = false
'''

node +arguments:
	{{COMPOSE_NODE}} {{arguments}}

ace +arguments:
	{{COMPOSE_ACE}} {{arguments}}

npm +commands:
	{{COMPOSE_NPM}} {{commands}}

webpack:
	{{COMPOSE_NODE}} ./node_modules/.bin/webpack build --watch

db-flush:
	{{COMPOSE_ACE}} db:wipe
	{{COMPOSE_ACE}} migration:run
	{{COMPOSE_ACE}} db:seed

deploy destination:
	rsync -avz --exclude-from=\".rsyncignore.txt\" --delete ./build/ {{destination}}

lint path=".":
	{{COMPOSE_NODE}} ./node_modules/.bin/eslint {{path}}

lint-fix path=".":
	{{COMPOSE_NPM}} ./node_modules/.bin/eslint {{path}} --fix

format path=".":
	{{COMPOSE_NPM}} ./node_modules/.bin/prettier --write {{path}}

upgrade:
	{{COMPOSE_NODE}} ./node_modules/.bin/ncu -iu

tools:
	{{COMPOSE_NPM}} install --save-dev @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint-plugin-unicorn type-fest npm-check-updates

new-app:
	{{COMPOSE_NPM}} init adonis-ts-app@latest --yes -- temporary_dir --boilerplate slim --name adonis-docker --eslint --prettier
	{{COMPOSE_NODE}} rm -rf temporary_dir/.git && cp -R temporary_dir/. . && rm -rf temporary_dir
	{{COMPOSE_NODE}} npm pkg delete eslintConfig eslintIgnore prettier
	just tools
	echo "{{EDITOR_CONFIG_TEMPLATE}}" > .editorconfig
