.PHONY: generate-adapters validate-skills sync-plugin-skills

generate-adapters:
	./scripts/generate-adapters.sh

validate-skills:
	./scripts/validate-skills.sh

sync-plugin-skills:
	./scripts/sync-plugin-skills.sh
