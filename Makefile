run: 
	swift run
	
build:
	swift build
	
releaseBuild:
	swift build -c release
	
releaseRun:
	swift run -c release
	
commit:
	git add  .
	git add -u
	git commit -m "$(MSG)"
	
push: commit
	git push