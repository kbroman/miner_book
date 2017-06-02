docs/index.html: cover_sm.png \
				 cover_med.png \
				 _bookdown.yml \
				 index.Rmd \
				 installation.Rmd \
				 stairway-to-heaven.Rmd \
				 stand_on_tower.Rmd \
				 plant_a_garden.Rmd \
				 numguess.Rmd \
				 mc_image.Rmd \
				 R_logo.Rmd \
				 maze.Rmd \
				 random_walks.Rmd \
				 references.Rmd \
				 book.bib
	R -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"

cover_sm.png: cover/cover.png
	cd cover;convert -resize 281x364 cover.png ../cover_sm.png

cover_med.png: cover/cover.png
	cd cover;convert -resize 386x500 cover.png ../cover_med.png

cover/cover.png: cover/cover.pdf
	cd cover;convert -flatten cover.pdf cover.png

cover/cover.pdf: cover/cover.tex cover/cover_image.png
	cd cover;xelatex cover
