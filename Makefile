##	help:	This.
.PHONY: help
.DEFAULT: help
help:
#	Find all double comments and treat them as docstrings
	@echo "make <command>"
	@sed -n 's/^##//p' $<

##	watch:	Local server including drafts
.PHONY: watch
watch:
	xdg-open http://localhost:4000/
	jekyll serve --verbose --trace --watch --livereload --drafts --host=0.0.0.0

##	watch-public: LAN server including drafts
.PHONY: watch-public
watch-public:
	jekyll serve --verbose --trace --watch --livereload --drafts --host=0.0.0.0

##	watch-prod:	Local server without drafts
.PHONY: watch-prod
watch-prod:
	xdg-open http://localhost:4000/
	jekyll serve --verbose --trace --watch --livereload
