# shellcheck shell=sh

STEAMSHIP_ROOT=${PWD%/*}

steamship_modload() { . "${STEAMSHIP_ROOT}/modules/${1}.sh"; }

. "${STEAMSHIP_ROOT}/modules/timestamp.sh"

[ -z "${BASH_VERSION}" ] || unset BASH_VERSION
STEAMSHIP_PROMPT_COMMAND_SUBST='true'

for module in ${STEAMSHIP_MODULES_SOURCED}; do
	module_init_fn="steamship_${module}_init"
	eval "${module_init_fn}"
done

STEAMSHIP_TIMESTAMP_SHOW='true'
STEAMSHIP_TIMESTAMP_PREFIX='at '
STEAMSHIP_TIMESTAMP_SUFFIX=' '
STEAMSHIP_TIMESTAMP_12HR='false'
STEAMSHIP_TIMESTAMP_COLOR='YELLOW'

TESTS=

# Mock
date() { echo '12:34:56'; }

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
	STEAMSHIP_PROMPT_PS1=''
	steamship_timestamp_prompt
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "'"${STEAMSHIP_PROMPT_PS1}"'")'

	test1_name=${1}
	eval "test1_ps1=${STEAMSHIP_PROMPT_PS1}"
	test1_ps1_expected="${STEAMSHIP_YELLOW}12:34:56${STEAMSHIP_BASE_COLOR} "

	# shellcheck disable=SC2154
	assert_equal "${test1_name}" \
		"without prefix" \
		"${test1_ps1}" \
		"${test1_ps1_expected}"
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_PROMPT_PS1='me '
	steamship_timestamp_prompt
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "'"${STEAMSHIP_PROMPT_PS1}"'")'

	test2_name=${1}
	eval "test2_ps1=${STEAMSHIP_PROMPT_PS1}"
	test2_ps1_expected="me at ${STEAMSHIP_YELLOW}12:34:56${STEAMSHIP_BASE_COLOR} "

	# shellcheck disable=SC2154
	assert_equal "${test2_name}" \
		"with prefix" \
		"${test2_ps1}" \
		"${test2_ps1_expected}"
}

for test_fn in ${TESTS}; do
	eval "${test_fn}" "${test_fn}"
done
