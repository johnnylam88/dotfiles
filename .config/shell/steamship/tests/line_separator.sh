# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

. "${STEAMSHIP_ROOT}/modules/line_separator.sh"

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_LINE_SEPARATOR_SHOW='true'

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
	STEAMSHIP_PROMPT_PS1='$ '
	steamship_line_separator_prompt

	test1_name=${1}
	test1_ps1=${STEAMSHIP_PROMPT_PS1}
	test1_ps1_expected='$ 
'

	assert_equal "${test1_name}" \
		"newline in ps1" \
		"${test1_ps1}" \
		"${test1_ps1_expected}"

	unset STEAMSHIP_PROMPT_PS1
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
