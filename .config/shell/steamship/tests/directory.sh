# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

. "${STEAMSHIP_ROOT}/modules/directory.sh"

STEAMSHIP_PROMPT_PARAM_EXPANSION='true'
STEAMSHIP_PROMPT_COMMAND_SUBST='true'

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_DIRECTORY_SHOW='true'
STEAMSHIP_DIRECTORY_PREFIX='in '
STEAMSHIP_DIRECTORY_SUFFIX=' '
STEAMSHIP_DIRECTORY_TRUNCATE='2'
STEAMSHIP_DIRECTORY_TRUNCATE_PREFIX='.../'
STEAMSHIP_DIRECTORY_TRUNCATE_REPO='true'
STEAMSHIP_DIRECTORY_COLOR='CYAN'
STEAMSHIP_DIRECTORY_LOCK_SYMBOL=' [LOCKED]'
STEAMSHIP_DIRECTORY_LOCK_COLOR='RED'

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
	mkdir -p "${TESTDIR}/a/b" || return 1
	cd "${TESTDIR}/a/b" || return 1

	test1_name=${1}
	test1_with_prefix=$(steamship_directory -p)
	test1_without_prefix=$(steamship_directory)
	test1_with_prefix_expected="in ${STEAMSHIP_CYAN}.../a/b${STEAMSHIP_BASE_COLOR} "
	test1_without_prefix_expected="${STEAMSHIP_CYAN}.../a/b${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test1_name}" \
		"truncate, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"truncate, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	cd ../../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test2"
test2() {
	mkdir -p "${TESTDIR}/a/b" || return 1
	cd "${TESTDIR}/a/b" || return 1
	chmod -w .

	test2_name=${1}
	test2_with_prefix=$(steamship_directory -p)
	test2_without_prefix=$(steamship_directory)
	test2_with_prefix_expected="in ${STEAMSHIP_CYAN}.../a/b${STEAMSHIP_BASE_COLOR}${STEAMSHIP_RED} [LOCKED]${STEAMSHIP_BASE_COLOR} "
	test2_without_prefix_expected="${STEAMSHIP_CYAN}.../a/b${STEAMSHIP_BASE_COLOR}${STEAMSHIP_RED} [LOCKED]${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test2_name}" \
		"locked, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"locked, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	cd ../../..
	rm -fr "${TESTDIR}"
}

TESTS="${TESTS} test3"
test3() {
	STEAMSHIP_DIRECTORY_TRUNCATE_REPO='true'

	mkdir -p "${TESTDIR}/a/b" || return 1
	cd "${TESTDIR}/a/b" || return 1
	command git init >/dev/null || return 1

	test3_name=${1}
	test3_with_prefix=$(steamship_directory -p)
	test3_without_prefix=$(steamship_directory)
	test3_with_prefix_expected="in ${STEAMSHIP_CYAN}b${STEAMSHIP_BASE_COLOR} "
	test3_without_prefix_expected="${STEAMSHIP_CYAN}b${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test3_name}" \
		"truncate repo" \
		"${test3_with_prefix}" \
		"${test3_with_prefix_expected}"
	assert_equal "${test3_name}" \
		"truncate repo" \
		"${test3_without_prefix}" \
		"${test3_without_prefix_expected}"

	cd ../../..
	rm -fr "${TESTDIR}"

	unset STEAMSHIP_DIRECTORY_TRUNCATE_REPO
}

TESTS="${TESTS} test4"
test4() {
	STEAMSHIP_DIRECTORY_TRUNCATE_REPO='false'

	mkdir -p "${TESTDIR}/a/b" || return 1
	cd "${TESTDIR}/a/b" || return 1
	command git init >/dev/null || return 1

	test4_name=${1}
	test4_with_prefix=$(steamship_directory -p)
	test4_without_prefix=$(steamship_directory)
	test4_with_prefix_expected="in ${STEAMSHIP_CYAN}.../a/b${STEAMSHIP_BASE_COLOR} "
	test4_without_prefix_expected="${STEAMSHIP_CYAN}.../a/b${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test4_name}" \
		"no truncate repo" \
		"${test4_with_prefix}" \
		"${test4_with_prefix_expected}"
	assert_equal "${test4_name}" \
		"no truncate repo" \
		"${test4_without_prefix}" \
		"${test4_without_prefix_expected}"

	cd ../../..
	rm -fr "${TESTDIR}"

	unset STEAMSHIP_DIRECTORY_TRUNCATE_REPO
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done