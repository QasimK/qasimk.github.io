.PHONY: watch

watch:
	xdg-open http://localhost:4000/
	jekyll serve --verbose --trace --watch --livereload

watch-drafts:
	xdg-open http://localhost:4000/
	jekyll serve --verbose --trace --drafts --watch --livereload
