# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

steamship_modload() { . "${STEAMSHIP_ROOT}/modules/${1}.sh"; }

. "${STEAMSHIP_ROOT}/modules/exit_code.sh"

STEAMSHIP_PROMPT_COMMAND_SUBST='true'

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_EXIT_CODE_SHOW='true'
STEAMSHIP_EXIT_CODE_PREFIX=''
STEAMSHIP_EXIT_CODE_SUFFIX=' '
STEAMSHIP_EXIT_CODE_SYMBOL='X '
STEAMSHIP_EXIT_CODE_COLOR='RED'

TESTS=

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
	STEAMSHIP_RETVAL='128'

	test1_name=${1}
	test1_with_prefix=$(steamship_exit_code -p)
	test1_without_prefix=$(steamship_exit_code)
	test1_with_prefix_expected="${STEAMSHIP_RED}X 128${STEAMSHIP_WHITE} "
	test1_without_prefix_expected="${STEAMSHIP_RED}X 128${STEAMSHIP_WHITE} "

	assert_equal "${test1_name}" \
		"retval 128, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"retval 128, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset STEAMSHIP_RETVAL
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_RETVAL='0'

	test2_name=${1}
	test2_with_prefix=$(steamship_exit_code -p)
	test2_without_prefix=$(steamship_exit_code)
	test2_with_prefix_expected=''
	test2_without_prefix_expected=''

	assert_equal "${test2_name}" \
		"retval 0, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"retval 0, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset STEAMSHIP_RETVAL
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
