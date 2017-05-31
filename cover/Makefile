cover_sm.png: cover.png
	convert -resize 281x364 cover.png cover_sm.png

cover.png: cover.pdf
	convert -flatten cover.pdf cover.png

cover.pdf: cover.tex cover_image.png
	xelatex cover
