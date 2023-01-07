# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

. "${STEAMSHIP_ROOT}/modules/precmd.sh"

STEAMSHIP_PROMPT_COMMAND_SUBST='true'

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

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

hook() {
	# shellcheck disable=SC2034
	STEAMSHIP_RETVAL=128
}

TESTS="${TESTS} test1"
test1() {
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "${STEAMSHIP_RETVAL}")'
	steamship_precmd_add_hook hook
	steamship_precmd_prompt

	test1_name=${1}
	eval "test1_ps1=${STEAMSHIP_PROMPT_PS1}"
	test1_ps1_expected='128'

	# shellcheck disable=SC2154
	assert_equal "${test1_name}" \
		"add hook in ps1" \
		"${test1_ps1}" \
		"${test1_ps1_expected}"

	unset STEAMSHIP_PROMPT_PS1
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
