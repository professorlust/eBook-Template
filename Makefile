DIR = _build
INPUT = master
OUTPUT = book
DIAGRAM = --require=asciidoctor-diagram
MATH = --require=asciidoctor-mathematical
REQUIRES = ${DIAGRAM} ${MATH}
OUTPUT_FOLDER = --destination-dir=${DIR}
HTML = --backend=html5 --a data-uri -a max-width=55em
RAW_HTML = --backend=html5 --a data-uri -a stylesheet! -a source-highlighter!
PDF =  --backend=pdf --require=asciidoctor-pdf -a pdf-stylesdir=resources/pdfstyles -a pdf-style=default -a media=prepress
EPUB = --backend=epub3 --require=asciidoctor-epub3 -a epub3-stylesdir=resources/epubstyles -a imagesdir=images -a ebook-validate
KINDLE = ${EPUB} -a ebook-format=kf8

# Public targets

all: html raw_html pdf compressed_pdf epub kindle

html: _build/book.html

raw_html: _build/raw_book.html

pdf: _build/book.pdf

compressed_pdf: _build/compressed_book.pdf

epub: _build/book.epub

kindle: _build/book.mobi

stats:
	wc -w course/*.asc

clean:
	if [ -d ".asciidoctor" ]; \
		then rm -r .asciidoctor; \
	fi; \
	if [ -d "${DIR}" ]; \
		then rm -r ${DIR}; \
	fi; \

# Private targets

_build/book.html:
	asciidoctor ${HTML} ${REQUIRES} ${OUTPUT_FOLDER} --out-file=${OUTPUT}.html ${INPUT}.asc; \

_build/raw_book.html:
	asciidoctor ${RAW_HTML} ${REQUIRES} ${OUTPUT_FOLDER} --out-file=raw_${OUTPUT}.html ${INPUT}.asc; \

_build/book.pdf:
	asciidoctor ${PDF} ${REQUIRES} ${OUTPUT_FOLDER} --out-file=${OUTPUT}.pdf ${INPUT}.asc; \

# Courtesy of
# http://www.smartjava.org/content/compress-pdf-mac-using-command-line-free
# Requires `brew install ghostscript`
_build/compressed_book.pdf: _build/book.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${DIR}/compressed_book.pdf ${DIR}/book.pdf; \

_build/book.epub:
	asciidoctor ${EPUB} ${REQUIRES} ${OUTPUT_FOLDER} --out-file=${OUTPUT}.epub ${INPUT}.asc; \

_build/book.mobi:
	asciidoctor ${KINDLE} ${REQUIRES} ${OUTPUT_FOLDER} --out-file=${OUTPUT}.mobi ${INPUT}.asc; \
	if [ -e "${DIR}/${OUTPUT}-kf8.epub" ]; \
		then rm ${DIR}/${OUTPUT}-kf8.epub; \
	fi; \

