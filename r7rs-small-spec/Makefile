# JAE notes
#
# Will need to use other tex conversion software to generate individual pages, IE
#  tth procs.tex
#
# Can add the text to the skeleton, using CSS classes to indicate code blocks and text.
# Will want to experiment with one section (Booleans?) to get everything down. Final CSS
# does not need to be written, but the tags to add need to be defined so each section only
# needs to be visited once for the majority of the work.
# 
# Resources:
# http://www.w3.org/TR/CSS2/sample.html
# http://stackoverflow.com/questions/219219/how-to-change-a-span-to-look-like-a-pre-with-css
#
#
# Will want to remove sections that are not applicable (chapter 7?), and add new ones for 
# husk libraries, etc

.PHONY: all clean cleaner checkindex

all: r7rs.pdf overview.pdf

clean:
	rm -f *~

cleaner: clean
	rm -f *.pdf *.aux *.log *.idx *.toc *.out
#	rm -rf r7rs

DIFF_SOURCES=basic.tex derive.tex example.tex expr.tex \
	lex.tex procs.tex prog.tex struct.tex

SOURCES=r7rs.tex $(DIFF_SOURCES) intro.tex \
	bib.tex syn.tex commands.tex first.tex notes.tex \
	repository.tex index.tex sem.tex stdmod-raw.tex \
	features.tex

# index.tex: r7rs.idx
# 	csi index.sch -e '(run)'

stdmod.tex: stdmod-raw.tex
	./genstdmod.pl < $< > $@

checkindex: stdmod-raw.tex index.tex
	./checkindex.sh

intro-ebook.tex: intro.tex
	sed 's/\\clearextrapart{\(.*\)}/\1/g' $< > $@

r7rs.pdf: $(SOURCES) stdmod.tex
	pdflatex $<
	pdflatex $<

r7rs.html: $(SOURCES) stdmod.tex
	latex2html $<
#	pdflatex $<

overview.pdf: overview.tex overview-body.tex
	pdflatex $<
	pdflatex $<

r7rs-ebook.pdf: r7rs-ebook.tex intro-ebook.tex $(SOURCES) stdmod.tex
	pdflatex $<
	pdflatex $<

r5diff/%.tex: %.tex
	hg cat -r 1 $< > r5diff/old-$<
	latexdiff --type=UNDERLINE --subtype=SAFE r5diff/old-$< $< | \
	  perl -pe 's/\\section{\\DIF(add|del){([^{}]*)}}/\\section{\2}/; s/}\\ev  \\DIFadd{/\\ev/' | \
	  perl -pe 'BEGIN{undef $$/} s/\\ev([^%{]*)(%.*)?\n}/} \\ev \1\n/g' > $@
	rm -f r5diff/old-$<

r5diff/r7rs.pdf: $(DIFF_SOURCES:%=r5diff/%)
	cd r5diff && $(MAKE) r7rs.pdf
