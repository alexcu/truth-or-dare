all:
	if [ -d ./Build ]; then	rm -rf ./Build; fi
	xcodebuild -workspace TruthOrDare.xcworkspace -scheme 'TruthOrDare'
	mv ./Build/TruthOrDare/Build/Products/Debug/ ./Build
	rm -rf ./Build/ModuleCache ./Build/TruthOrDare
