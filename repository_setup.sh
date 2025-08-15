#/bin/bash

set -euo pipefail

cat <<EOF
Welcome to the rust-vmm interactive repository setup!

This script will guide you through initilaizing basic components of a fresh
rust-vmm repository, or alternatively lets you update the configuration of an
existing repository (for example, if since the first setup of a repository,
rust-vmm-ci has added new features that you would like to use).

EOF

SUPPORTED_PLATFORMS=("x86_64" "aarch64" "riscv64")
PLATFORMS_FILE=".platforms"

DEPENDABOT_SCHEDULES=("weekly" "monthly")
DEPENDABOT_FILE=".github/dependabot.yaml"

confirm() {
	read -p "$1 [Y/n] " -n 1 -r

	if [ ! -z $REPLY ]; then
		echo # move to new line unless user confirmed with just 'enter'
	else
		return 0
	fi
	[[ $REPLY =~ ^[Yy]$ ]]
}

setup_platforms_file() {
	touch $PLATFORMS_FILE
	echo "Please select the hardware plaforms for which you would like to enable CI support:"
	for platform in "${SUPPORTED_PLATFORMS[@]}"; do
		question="Enable support for $platform?"
		confirm "$question" && echo $platform >> $PLATFORMS_FILE
	done
}

setup_dependabot_config() {
	mkdir -p $(dirname $DEPENDABOT_FILE)
	touch $DEPENDABOT_FILE
	
	cat <<EOF
Dependabot allow you to automatically receive PRs for bumping your cargo dependencies, as well as for updating the rust-vmm-ci submodule. You can choose to run dependabot on different schedules: ${DEPENDABOT_SCHEDULES[@]}

Which schedule would you like to enable?
EOF
}

if [ -f $PLATFORMS_FILE ]; then
	current_platforms=$(tr '\n' ' ' < $PLATFORMS_FILE)
	question="This repository already has a $PLATFORMS_FILE file setup. Do you want to regenerate it? Current supported platforms are: $current_platforms"

	if confirm "$question"; then
		rm $PLATFORMS_FILE
		setup_platforms_file
	fi
else
	setup_platforms_file
fi

if [ -f "$DEPENDABOT_FILE" ]; then

fi
