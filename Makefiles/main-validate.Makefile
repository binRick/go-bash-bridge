validate: ## Validate 
	color blue black
	env $(EXEC_ENV) ./RELEASE/bin/call_libcso1-static
	color cyan black
	env $(EXEC_ENV) ./RELEASE/bin/call_libcso1-dynamic
	color reset
	color magenta black
	env $(EXEC_ENV) ./RELEASE/bin/call_libgoso1-static
	color yellow black
	env $(EXEC_ENV) ./RELEASE/bin/call_libgoso1-dynamic
	color reset
