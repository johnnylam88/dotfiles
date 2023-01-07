# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

. "${STEAMSHIP_ROOT}/modules/git.sh"

STEAMSHIP_PROMPT_COMMAND_SUBST='true'

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_GIT_SHOW='true'
STEAMSHIP_GIT_PREFIX='on '
STEAMSHIP_GIT_SUFFIX=' '

STEAMSHIP_GIT_BRANCH_SHOW='true'
STEAMSHIP_GIT_BRANCH_PREFIX='{'
STEAMSHIP_GIT_BRANCH_SUFFIX='}'
STEAMSHIP_GIT_BRANCH_SYMBOL=''
STEAMSHIP_GIT_BRANCH_COLOR='MAGENTA'

STEAMSHIP_GIT_STATUS_SHOW='true'
STEAMSHIP_GIT_STATUS_PREFIX=' ['
STEAMSHIP_GIT_STATUS_SUFFIX=']'
STEAMSHIP_GIT_STATUS_COLOR='RED'
STEAMSHIP_GIT_STATUS_UNTRACKED='?'
STEAMSHIP_GIT_STATUS_ADDED='+'
STEAMSHIP_GIT_STATUS_MODIFIED='!'
STEAMSHIP_GIT_STATUS_DELETED='X'
STEAMSHIP_GIT_STATUS_STASHED='$'

TESTS=
TESTDIR="./dir.$$"

assert_equal()
{
	if [ "${3}" = "${4}" ]; then
		echo "${0} > ${1} > ${2}: pass"
	else
		echo "${0} > ${1} > ${2}: FAIL"
		echo "    expected: ${4}"
		echo "    got:      ${3}"
	fi
}

TESTS="${TESTS} test1"
test1() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1

	test1_name=${1}
	test1_with_prefix=$(steamship_git -p)
	test1_without_prefix=$(steamship_git)
	test1_with_prefix_expected=''
	test1_without_prefix_expected=''

	assert_equal "${test1_name}" \
		"no git, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"no git, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test2"
test2() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1
	command git init >/dev/null || return 1

	test2_name=${1}
	test2_with_prefix=$(steamship_git -p)
	test2_without_prefix=$(steamship_git)
	test2_branch="${STEAMSHIP_MAGENTA}{master}${STEAMSHIP_BASE_COLOR}"
	test2_with_prefix_expected="on ${test2_branch} "
	test2_without_prefix_expected="${test2_branch} "

	assert_equal "${test2_name}" \
		"git branch, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"git branch, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test3"
test3() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1
	command git init >/dev/null || return 1
	echo > file1

	test3_name=${1}
	test3_with_prefix=$(steamship_git -p)
	test3_without_prefix=$(steamship_git)
	test3_branch="${STEAMSHIP_MAGENTA}{master}${STEAMSHIP_BASE_COLOR}"
	test3_status="${STEAMSHIP_RED}"' [?]'"${STEAMSHIP_BASE_COLOR}"
	test3_with_prefix_expected="on ${test3_branch}${test3_status} "
	test3_without_prefix_expected="${test3_branch}${test3_status} "

	assert_equal "${test3_name}" \
		"git branch, untracked, with prefix" \
		"${test3_with_prefix}" \
		"${test3_with_prefix_expected}"
	assert_equal "${test3_name}" \
		"git branch, untracked, without prefix" \
		"${test3_without_prefix}" \
		"${test3_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test4"
test4() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1
	command git init >/dev/null || return 1
	echo > file1
	command git add file1 >/dev/null || return 1

	test4_name=${1}
	test4_with_prefix=$(steamship_git -p)
	test4_without_prefix=$(steamship_git)
	test4_branch="${STEAMSHIP_MAGENTA}{master}${STEAMSHIP_BASE_COLOR}"
	test4_status="${STEAMSHIP_RED}"' [+]'"${STEAMSHIP_BASE_COLOR}"
	test4_with_prefix_expected="on ${test4_branch}${test4_status} "
	test4_without_prefix_expected="${test4_branch}${test4_status} "

	assert_equal "${test4_name}" \
		"git branch, added, with prefix" \
		"${test4_with_prefix}" \
		"${test4_with_prefix_expected}"
	assert_equal "${test4_name}" \
		"git branch, added, without prefix" \
		"${test4_without_prefix}" \
		"${test4_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test5"
test5() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1
	command git init >/dev/null || return 1
	echo > file1
	command git add file1 >/dev/null || return 1
	command git commit -m 'initial commit' >/dev/null || return 1
	echo "changes" >> file1

	test5_name=${1}
	test5_with_prefix=$(steamship_git -p)
	test5_without_prefix=$(steamship_git)
	test5_branch="${STEAMSHIP_MAGENTA}{master}${STEAMSHIP_BASE_COLOR}"
	test5_status="${STEAMSHIP_RED}"' [!]'"${STEAMSHIP_BASE_COLOR}"
	test5_with_prefix_expected="on ${test5_branch}${test5_status} "
	test5_without_prefix_expected="${test5_branch}${test5_status} "

	assert_equal "${test5_name}" \
		"git branch, modified, with prefix" \
		"${test5_with_prefix}" \
		"${test5_with_prefix_expected}"
	assert_equal "${test5_name}" \
		"git branch, modified, without prefix" \
		"${test5_without_prefix}" \
		"${test5_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test6"
test6() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1
	command git init >/dev/null || return 1
	echo > file1
	command git add file1 >/dev/null || return 1
	command git commit -m 'initial commit' >/dev/null || return 1
	command git rm file1 >/dev/null || return 1

	test6_name=${1}
	test6_with_prefix=$(steamship_git -p)
	test6_without_prefix=$(steamship_git)
	test6_branch="${STEAMSHIP_MAGENTA}{master}${STEAMSHIP_BASE_COLOR}"
	test6_status="${STEAMSHIP_RED}"' [X]'"${STEAMSHIP_BASE_COLOR}"
	test6_with_prefix_expected="on ${test6_branch}${test6_status} "
	test6_without_prefix_expected="${test6_branch}${test6_status} "

	assert_equal "${test6_name}" \
		"git branch, deleted, with prefix" \
		"${test6_with_prefix}" \
		"${test6_with_prefix_expected}"
	assert_equal "${test6_name}" \
		"git branch, deleted, without prefix" \
		"${test6_without_prefix}" \
		"${test6_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test7"
test7() {
	mkdir -p "${TESTDIR}/a" || return 1
	cd "${TESTDIR}/a" || return 1
	command git init >/dev/null || return 1
	echo > file1
	command git add file1 >/dev/null || return 1
	command git commit -m 'initial commit' >/dev/null || return 1
	echo > file2
	command git add file2 >/dev/null || return 1
	command git stash >/dev/null || return 1

	test7_name=${1}
	test7_with_prefix=$(steamship_git -p)
	test7_without_prefix=$(steamship_git)
	test7_branch="${STEAMSHIP_MAGENTA}{master}${STEAMSHIP_BASE_COLOR}"
	test7_status="${STEAMSHIP_RED}"' [$]'"${STEAMSHIP_BASE_COLOR}"
	test7_with_prefix_expected="on ${test7_branch}${test7_status} "
	test7_without_prefix_expected="${test7_branch}${test7_status} "

	assert_equal "${test7_name}" \
		"git branch, stashed, with prefix" \
		"${test7_with_prefix}" \
		"${test7_with_prefix_expected}"
	assert_equal "${test7_name}" \
		"git branch, stashed, without prefix" \
		"${test7_without_prefix}" \
		"${test7_without_prefix_expected}"

	cd ../..
	rm -fr "${TESTDIR}"
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done