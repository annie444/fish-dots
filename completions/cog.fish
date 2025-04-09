# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_cog_global_optspecs
	string join \n v/verbose q/quiet h/help V/version
end

function __fish_cog_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_cog_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_cog_using_subcommand
	set -l cmd (__fish_cog_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c cog -n "__fish_cog_needs_command" -s v -l verbose -d 'The level of verbosity: -v for ERROR, -vv for WARNING, -vvv for INFO'
complete -c cog -n "__fish_cog_needs_command" -s q -l quiet -d 'Silence all output, no matter the value of verbosity'
complete -c cog -n "__fish_cog_needs_command" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_needs_command" -s V -l version -d 'Print version'
complete -c cog -n "__fish_cog_needs_command" -f -a "check" -d 'Verify all commit messages against the conventional commit specification'
complete -c cog -n "__fish_cog_needs_command" -f -a "commit" -d 'Create a new conventional commit'
complete -c cog -n "__fish_cog_needs_command" -f -a "edit" -d 'Interactively rename invalid commit messages'
complete -c cog -n "__fish_cog_needs_command" -f -a "log" -d 'Like git log but for conventional commits'
complete -c cog -n "__fish_cog_needs_command" -f -a "verify" -d 'Verify a single commit message'
complete -c cog -n "__fish_cog_needs_command" -f -a "changelog" -d 'Display a changelog for the given commit oid range'
complete -c cog -n "__fish_cog_needs_command" -f -a "get-version" -d 'Get current version'
complete -c cog -n "__fish_cog_needs_command" -f -a "bump" -d 'Commit changelog from latest tag to HEAD and create new tag'
complete -c cog -n "__fish_cog_needs_command" -f -a "init" -d 'Install cog config files'
complete -c cog -n "__fish_cog_needs_command" -f -a "install-hook" -d 'Add git hooks to the repository'
complete -c cog -n "__fish_cog_needs_command" -f -a "generate-completions" -d 'Generate shell completions'
complete -c cog -n "__fish_cog_needs_command" -f -a "generate-manpages" -d 'Generate manpage'
complete -c cog -n "__fish_cog_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c cog -n "__fish_cog_using_subcommand check" -s l -l from-latest-tag -d 'Check commit history, starting from the latest tag to HEAD'
complete -c cog -n "__fish_cog_using_subcommand check" -s i -l ignore-merge-commits -d 'Ignore merge commits messages'
complete -c cog -n "__fish_cog_using_subcommand check" -l ignore-fixup-commits -d 'Ignore fixup!, squash! and amend! commit messages'
complete -c cog -n "__fish_cog_using_subcommand check" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand commit" -l skip-ci-override -d 'Override and add the <SKIP_CI_OVERRIDE> string to the commit' -r
complete -c cog -n "__fish_cog_using_subcommand commit" -s B -l breaking-change -d 'Create a BREAKING CHANGE commit'
complete -c cog -n "__fish_cog_using_subcommand commit" -s e -l edit -d 'Open commit message in an editor'
complete -c cog -n "__fish_cog_using_subcommand commit" -s s -l sign -d 'Sign this commit'
complete -c cog -n "__fish_cog_using_subcommand commit" -l skip-ci -d 'Add the skip-ci string defined in the cog.toml (or defaults to [skip ci]) to the commit'
complete -c cog -n "__fish_cog_using_subcommand commit" -s a -l add -d 'Add files to the commit (similar to git add .)'
complete -c cog -n "__fish_cog_using_subcommand commit" -s u -l update -d 'Update but doesn\'t add files to the commit (similar to git add -u .)'
complete -c cog -n "__fish_cog_using_subcommand commit" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand edit" -s l -l from-latest-tag -d 'Edit non conventional commits, starting from the latest tag to HEAD'
complete -c cog -n "__fish_cog_using_subcommand edit" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand log" -s t -l type -d 'Filter on commit type' -r
complete -c cog -n "__fish_cog_using_subcommand log" -s a -l author -d 'Filter on commit author' -r
complete -c cog -n "__fish_cog_using_subcommand log" -s s -l scope -d 'Filter on commit scope' -r
complete -c cog -n "__fish_cog_using_subcommand log" -s B -l breaking-change -d 'Filter BREAKING CHANGE commits'
complete -c cog -n "__fish_cog_using_subcommand log" -s e -l no-error -d 'Omit error on the commit log'
complete -c cog -n "__fish_cog_using_subcommand log" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand verify" -s f -l file -d 'Read message from the specified file' -r -F
complete -c cog -n "__fish_cog_using_subcommand verify" -s i -l ignore-merge-commits -d 'Ignore merge commit messages'
complete -c cog -n "__fish_cog_using_subcommand verify" -l ignore-fixup-commits -d 'Ignore fixup!, squash! and amend! commit messages'
complete -c cog -n "__fish_cog_using_subcommand verify" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand changelog" -s a -l at -d 'Generate the changelog for a specific git tag' -r
complete -c cog -n "__fish_cog_using_subcommand changelog" -s t -l template -d 'Generate the changelog with the given template' -r
complete -c cog -n "__fish_cog_using_subcommand changelog" -s r -l remote -d 'Url to use during template generation' -r
complete -c cog -n "__fish_cog_using_subcommand changelog" -s o -l owner -d 'Repository owner to use during template generation' -r
complete -c cog -n "__fish_cog_using_subcommand changelog" -l repository -d 'Name of the repository used during template generation' -r
complete -c cog -n "__fish_cog_using_subcommand changelog" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c cog -n "__fish_cog_using_subcommand get-version" -s f -l fallback -d 'Fallback version. Has to be semver compliant' -r
complete -c cog -n "__fish_cog_using_subcommand get-version" -l package -d 'Specify which package to get the version for in a monorepo' -r -f -a "entity\t''
server\t''
migration\t''
frontend\t''
micro-url\t''"
complete -c cog -n "__fish_cog_using_subcommand get-version" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand bump" -l version -d 'Manually set the target version' -r
complete -c cog -n "__fish_cog_using_subcommand bump" -l pre -d 'Set the pre-release version' -r
complete -c cog -n "__fish_cog_using_subcommand bump" -l build -d 'Set the build suffix' -r
complete -c cog -n "__fish_cog_using_subcommand bump" -s H -l hook-profile -d 'Specify the bump profile hooks to run' -r -f -a ""
complete -c cog -n "__fish_cog_using_subcommand bump" -l package -d 'Specify which package to bump for monorepo' -r -f -a "entity\t''
server\t''
migration\t''
frontend\t''
micro-url\t''"
complete -c cog -n "__fish_cog_using_subcommand bump" -s A -l annotated -d 'Annotate tag with given message' -r
complete -c cog -n "__fish_cog_using_subcommand bump" -l skip-ci-override -d 'Override and add the skip-ci string with the provided value to the bump commit' -r
complete -c cog -n "__fish_cog_using_subcommand bump" -s a -l auto -d 'Automatically suggest the target version'
complete -c cog -n "__fish_cog_using_subcommand bump" -s M -l major -d 'Increment the major version'
complete -c cog -n "__fish_cog_using_subcommand bump" -s m -l minor -d 'Increment the minor version'
complete -c cog -n "__fish_cog_using_subcommand bump" -s p -l patch -d 'Increment the patch version'
complete -c cog -n "__fish_cog_using_subcommand bump" -s d -l dry-run -d 'Dry-run: print the target version. No action taken'
complete -c cog -n "__fish_cog_using_subcommand bump" -l skip-ci -d 'Add the skip-ci string defined in the cog.toml (or defaults to [skip ci]) to the bump commit'
complete -c cog -n "__fish_cog_using_subcommand bump" -l skip-untracked -d 'Don\'t fail if there are untracked or uncommitted files'
complete -c cog -n "__fish_cog_using_subcommand bump" -l disable-bump-commit -d 'Disable the creation of the bump commit'
complete -c cog -n "__fish_cog_using_subcommand bump" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand init" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand install-hook" -s a -l all -d 'Install all git-hooks'
complete -c cog -n "__fish_cog_using_subcommand install-hook" -s o -l overwrite -d 'Overwrite existing git-hooks'
complete -c cog -n "__fish_cog_using_subcommand install-hook" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand generate-completions" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand generate-manpages" -s h -l help -d 'Print help'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "check" -d 'Verify all commit messages against the conventional commit specification'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "commit" -d 'Create a new conventional commit'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "edit" -d 'Interactively rename invalid commit messages'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "log" -d 'Like git log but for conventional commits'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "verify" -d 'Verify a single commit message'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "changelog" -d 'Display a changelog for the given commit oid range'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "get-version" -d 'Get current version'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "bump" -d 'Commit changelog from latest tag to HEAD and create new tag'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "init" -d 'Install cog config files'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "install-hook" -d 'Add git hooks to the repository'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "generate-completions" -d 'Generate shell completions'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "generate-manpages" -d 'Generate manpage'
complete -c cog -n "__fish_cog_using_subcommand help; and not __fish_seen_subcommand_from check commit edit log verify changelog get-version bump init install-hook generate-completions generate-manpages help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'

