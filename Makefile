
test:
	echo $(rvm current)

.PHONY: watch
watch:
	xdg-open http://localhost:4000/
	jekyll serve --verbose --trace --watch --livereload --drafts

.PHONY: watch-prod
watch-prod:
	xdg-open http://localhost:4000/
	jekyll serve --verbose --trace --watch --livereload
