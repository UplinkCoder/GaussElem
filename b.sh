dmd -O -release GaussParser.d aaSystem.d ctiota.d forops.d mymain.d \
parseEquationSystem.d reduceMatrix.d pegged/grammar.d pegged/parser.d \
pegged/peg.d pegged/dynamic/grammar.d pegged/dynamic/peg.d -ofGaussElem
